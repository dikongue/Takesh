import 'dart:async';
import 'dart:math' show cos, sqrt, asin;
import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:etakesh_client/DAO/Presenters/LoginPresenter.dart';
import 'package:etakesh_client/DAO/Rest_dt.dart';
import 'package:etakesh_client/DAO/google_maps_requests.dart';
import 'package:etakesh_client/Database/DatabaseHelper.dart';
import 'package:etakesh_client/Models/clients.dart';
import 'package:etakesh_client/Models/google_place_item_term.dart';
import 'package:etakesh_client/Models/prestataires.dart';
import 'package:etakesh_client/Utils/AppSharedPreferences.dart';
import 'package:etakesh_client/Utils/Loading.dart';
import 'package:etakesh_client/Utils/Scan_qr_code.dart';
import 'package:etakesh_client/Utils/colors.dart';
import 'package:etakesh_client/Utils/notification_util.dart';
import 'package:etakesh_client/pages/Commande/destination_page.dart';
import 'package:etakesh_client/pages/Commande/position_page.dart';
import 'package:etakesh_client/pages/Commande/services.dart';
import 'package:etakesh_client/pages/autres_services.dart';
import 'package:etakesh_client/pages/courses_page.dart';
import 'package:etakesh_client/pages/parameters_page.dart';
import 'package:etakesh_client/pages/tarifs_page.dart';
import 'package:etakesh_client/pages/update_account.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart' as g;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:etakesh_client/pages/Mycolor.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Commande/services2.dart';

const kGoogleApiKey = "AIzaSyBNm8cnYw5inbqzgw8LjXyt3rMhFhEVTjY";

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> implements LoginContract {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  bool pret_a_commander = false;
  bool destination_selected = false;
  bool _isorder = false, iSloading = false;
  LoginPresenter _presenter;
  String destination, position,commande;
  int stateIndex;
  Login2 login;
  Client1 client;
  LatLng target,target1;
  double mylat, mylng;
  HomePageState() {
    _presenter = new LoginPresenter(this);
  }
  Set<Marker> markers = Set();
  GoogleMapController mapController;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  AutoCompleteModel destinationModel = new AutoCompleteModel();
  AutoCompleteModel positiontionModel = new AutoCompleteModel();
//  get prestataire
  RestDatasource api = new RestDatasource();
  BitmapDescriptor _markerIcon, _markerIconUser;
  bool prestaOnline = false,bool12=false;
    GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  //Add for notification
  var notifCmd = new NotificationUtil();

  Timer timer, timer2, timer3, timer1;
  DistanceTime distanceTime;
  List <String> _idMarker=[];
  String token1;
var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: true,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontSize: 18),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.black,
    ),
  );

  bool _serviceEnabled;
//PermissionStatus _permissionGranted;
 LocationData _locationData;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(4.0833446, 9.515695),
    zoom: 11,
  );
//  Future<Null> _selectDate(BuildContext context) async {
//    final DateTime picked = await showDatePicker(
//        context: context,
//        initialDate: selectedDate,
//        firstDate: DateTime(selectedDate.year, 1),
//        lastDate: DateTime(selectedDate.year + 1));
//    if (picked != null && picked != selectedDate)
//      setState(() {
//        selectedDate = picked;
//      });
//    _selectTime(context);
//  }
//
//  Future<void> _selectTime(BuildContext context) async {
//    final TimeOfDay picked = await showTimePicker(
//      context: context,
//      initialTime: selectedTime,
//    );
//    if (picked != null && picked != selectedTime)
//      setState(() {
//        selectedTime = picked;
//      });
//    Navigator.of(context).pushAndRemoveUntil(
//        new MaterialPageRoute(
//            builder: (context) => ServicesPage(
//                  destination: destinationModel,
//                  position: positiontionModel,
//                )),
//        ModalRoute.withName(Navigator.defaultRouteName));
//  }

  @override
  void initState() {

    mylat = 4.0922421;
    mylng = 9.748265;
  
//_locationData = await location.getLocation();


    activeLocation();
    getUserLocation();
 
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(40, 40)),
            'assets/images/taxi_icon.png')
        .then((onValue) {
      setState(() {
        _markerIcon = onValue;
      });
    });
    destination_selected = false;
    pret_a_commander = false;
    _isorder = false;
    iSloading = false;
    destination = "Où allez-vous ?";
    commande="";    

//    check if user created order
    AppSharedPreferences().isOrderCreated().then((bool order) {
      if (order == true) {
//        if it is true we start our service
        
        timer = Timer.periodic(
            Duration(seconds: 5), (Timer t) => notifCmd.init(context));
      }
    });
    //  update when user change profile
    timer2 = Timer.periodic(Duration(seconds: 4), (Timer t) {

  AppSharedPreferences().isOrder().then((bool order) {
      print("cmdTest " + order.toString());
      if (order == true) {
        setState(() {
          _isorder = true;
        });
      }else{
        setState(() {
          _isorder=false;
        });
      }
    });

      AppSharedPreferences().isProfileUpd().then((bool updt) {
        print("Update profile " + updt.toString());
        if (updt == true) {
          DatabaseHelper().getClient().then((Client1 c) {
            print(c);
            if (c != null) {
              setState(() {
                client = c;
              });
              AppSharedPreferences().setProfileUpd(false);
            }
          });
        }
      });
    });

    AppSharedPreferences().isOrder().then((bool order) {
      print("cmdTest " + order.toString());
      if (order == true) {
        setState(() {
          _isorder = true;
        });
      }
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(100, 100)),
            'assets/images/stop_taxi.png')
        .then((onValue) {
      setState(() {
        _markerIconUser = onValue;
      });
    });
    DatabaseHelper().getUser().then((Login2 l) {
      if (l != null) {
        login = l;
        token1=l.token;
        print(" fababy token  "+token1);
        _getPrestataires(l.token);
        _presenter.detailClient(l.userId, l.token);
      }
    });
    stateIndex = 0;
    
    //refresh();
    super.initState();

  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  _updatePosition() {
    _presenter.updatePosition(client.positionId, mylat, mylng, login.token);
  }

  Future _showDetailPrestataire(PrestataireOnline prest, DistanceTime distanceT) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext contex) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            height: 400.0,
            width: 210.0,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 150.0,
                    ),
                    Container(
                      height: 100.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0)),
                          color: Colors.black),
                    ),
                    Positioned(
                      top: 40.0,
                      left: 94.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(45.0),
                        child: new CachedNetworkImage(
                          imageUrl: prest.prestataires.image +
                              "?access_token=" +
                              login.token,
                          height: 90.0,
                          width: 90.0,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                      ),
                     
                    ),
                    Positioned(
                     top: 0.0,
                     right: -2.0,
                    child: FlatButton(
                      child: Icon(Icons.close,color: Colors.white,),
                      onPressed: (){
                         Navigator.of(context).pop();
                      },
                    ),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Mr " +
                        prest.prestataires.nom +
                        ' ' +
                        prest.prestataires.prenom,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                new Container(
               child: Row(
                 children: <Widget>[
                   SizedBox(width: 50.0),
                   Container(
                     child: Icon(Icons.phone),
                     ),
                     SizedBox(width: 8.0),
                       InkWell(
                              // InkWell ici permet de lie la fonction onTap()  au container
                              child: Container(
//                                softWrap: true,
                                child:Text("" + prest.prestataires.telephone,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  letterSpacing: 1.0,
                                ),),
                              ),
                              onTap: () {
                                _callphone(prest.prestataires.telephone);
                              },
                            )
                   
                 ],
               ),
                ),
             SizedBox(height: 10.0),
                bool12?
                Text(distanceT.duree.time + " de vous",
                    style: TextStyle(
                        color : Colors.black54,
                        fontSize: 14.0))
                        :Container(),
                SizedBox(height: 0),
                bool12?
                Text(distanceT.distance.dist + " de vous",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                    ))
                    :Container(),
               SizedBox(height: 10.0),
          
                bool12 ? 
                Center(
                  child: FlatButton(
                      color: Colors.black,
                      padding: EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
          
                      child: Text(
                        commande,
                        style: TextStyle(fontSize: 14.0, color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                   if(commande=="commandée"){
                       showDestinationPlaces1(prest.prestataireId.toString());
                   }else{
                        commande=" ";
                   }   
                      }),

                )
        :Container(),
                
              ],
            ),
          ),
        );
      },
    );
  }
  _callphone (String numero) async{
    final String phone="tel:"+numero;
    if(await canLaunch(phone)){
    await launch(phone);
    }else{
    throw 'Could not launch $phone';
    }
  }
  /*
  _onSelected(int index) {
    _googleMapsServices
        .getDistanceTime(
            widget.location.latitude,
            widget.location.longitude,
            listprestataires[index].prestataire.positions.latitude,
            listprestataires[index].prestataire.positions.longitude)
        .then((DistanceTime datemine) {
      setState(() {
        isSelected = true;
        _selectedIndex = index;
        distanceTime = datemine;
      });
    });
  }*/

  _getPrestataires(token) {
        print(token.toString());
    _idMarker=[];
    
    print("test prestation............");
    api.getAllPrestataires(token).then((List<PrestataireOnline> prestataires) {
      print(prestataires);
      if (prestataires != null) {
        for (int i = 0; i < prestataires.length; i++) {
          if (prestataires[i].prestataires.status == "ONLINE" && prestataires[i].prestataires.etat==false) {
            double distance = calculateDistance(
                mylat,
                mylng,
                prestataires[i].prestataires.positions.latitude,
                prestataires[i].prestataires.positions.longitude);

               _idMarker.add(prestataires[i].prestataires.telephone);

              print("Distance :" + i.toString());
              print(distance);
              setState(() {
                prestaOnline = true;
                markers.add(
                  Marker(
                      markerId:
                          MarkerId(prestataires[i].prestataires.telephone),
                      icon: _markerIcon,
                      position: LatLng(
                          prestataires[i].prestataires.positions.latitude,
                          prestataires[i].prestataires.positions.longitude),
                        onTap: () {
                            _googleMapsServices
         .getDistanceTime(
            mylat,
            mylng,
            prestataires[i].prestataires.positions.latitude,
            prestataires[i].prestataires.positions.longitude)
        .then((DistanceTime datemine) {
            _showDetailPrestataire(prestataires[i], datemine);
           });                     
                            
                          }
                     /* infoWindow: InfoWindow(
                          title: prestataires[i].prestataires.nom,
                          snippet: "Voir les details",
                          )*/),
                          
                );
                iSloading=false;
              });
         if (distance < 50.00) {
  
            setState(() {
              commande="commandée";
            });
          }
          }
        }
      }
    }).catchError((onError) {
      print("Probleme " + onError.toString());
    });
  }

activeLocation() async{
   Location location = new Location();
_serviceEnabled = await location.serviceEnabled();
if (!_serviceEnabled) {
  _serviceEnabled = await location.requestService();
  if (!_serviceEnabled) {
    return;
  }
}
/*
_permissionGranted = await location.hasPermission();
if (_permissionGranted == PermissionStatus.DENIED) {

  _permissionGranted = await location.requestPermission();

  if (_permissionGranted != PermissionStatus.GRANTED) {
    return;

  }
}
*/
}
/*

  Future<String> _initCurrentMarker() async {
//    Map<String, double> myCurrentLocation;
    LocationData currentLocation;
    Location location = new Location();

    // AppSharedPreferences().setAllowsNotifications(false);

    try {
      currentLocation = await location.getLocation();
      print("lat :" + currentLocation.latitude.toString());
      print("lng :" + currentLocation.longitude.toString());
      setState(() {
        print('${TAG}:initPlatform _currentLocation ${_currentLocation}');
        _currentLocation = currentLocation;
        _markers.add(
          new Marker(
              markerId: MarkerId('current position'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              position:
                  LatLng(_currentLocation.latitude, _currentLocation.longitude),
              infoWindow: InfoWindow(
                title: 'Ma position courante',
                snippet: 'Vous vous trouvez ici en ce moment',
              ),
              onTap: () {
//                Fluttertoast.showToast(msg: "Position Courant click listener");
              }),
        );

//        print("${TAG} _markers size = ${_markers.length} | ${_markers}");
      });

      _goToTheLake(_currentLocation.latitude, _currentLocation.longitude, 14.0);

      return null;
//      as Map<String, double>;
    } on PlatformException catch (e) {
      if (e.code == "PERMISSION_DENIED") {
        error = "PERMISSION_DENIED";
        return null;
      } else if (e.code == "PERMISSION_DENIED_NEVER_ASK") {
        error = "Never Ask";
      }
      currentLocation = null;
      return null;
    }
  }
*/

  Future<LatLng> getUserLocation() async {

 /*    Geolocator geolocator=Geolocator()..forceAndroidLocationManager=true;
  GeolocationStatus geolocationStatus= await geolocator.checkGeolocationPermissionStatus();
   print("vericationnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn");
   print(geolocationStatus);
   if(geolocationStatus.toString()=="GeolocationStatus.disabled"){


print("123456");
Alert(
        context: context,
        style: alertStyle,
        type: AlertType.warning,
        title: "AVERTISSEMENT!!!",
        desc:
            "Vous n'avez pas activé la localisation de votre téléphone  \n Veillez l'activé svp... \n",
        /* content: Column(
                                    children: <Widget>[
                                     /* Container(
                                        child: CircularProgressIndicator(),
                                      )*/
                                     /*ProgressBouton(
                                        ncmds: _ncmds,
                                        indexC: indexItem,
                                        token: _token,
                                      ),*/
                                    ],
                                  ),*/
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.blue,
            
          ),
        ],
      ).show();
}else{ */
print("654321");

//Location location = new Location();

   try {
   Position position= await Geolocator()
          .getCurrentPosition(desiredAccuracy: g.LocationAccuracy.high);
    await Geolocator().getCurrentPosition(desiredAccuracy: g.LocationAccuracy.best).then((post){
                 if (post!=null){
                   target1 = LatLng(post.latitude, post.longitude);
                   bool12=true;
                 }
          });
        print('positionement !'+position.longitude.toString());
 if(position.latitude!=null&&position.longitude!=null){
      var lat = position.latitude;
      var lng = position.longitude; 

      setState(() {
        mylat = position.latitude;
        mylng = position.longitude;
        target = LatLng(lat, lng);
        bool12 = true;
        print("Ma Position1 Lat" +
            position.latitude.toString() +
            "Lng" +
            position.longitude.toString());
        markers.add(
          Marker(
              markerId: MarkerId('current position'),
              icon: _markerIconUser,
              position: target,
              infoWindow: InfoWindow(
                title: 'Ma position courante',
                snippet: 'Vous vous trouvez ici en ce moment',
              )),
        );
      });
      return target;
    }
    } on Exception catch (e) {
      print("execptionnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnjxk548");
      print(e);
     /*  if (e.code == "PERMISSION_DENIED") {
        error = "PERMISSION_DENIED";
        return null;
      } else if (e.code == "PERMISSION_DENIED_NEVER_ASK") {
        error = "Never Ask";
      }
      currentLocation = null; */
      return null;
    }
}
 
//  }

//  get TownName of user

  _getLocation() async {
    final coordinates = new Coordinates(mylat, mylng);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("Position");
    print(first.locality);
    print(first.countryCode);
    print(first.countryName);
  }

  Completer<GoogleMapController> _controller = Completer();
/*
  void refresh() async {
final center = await getUserLocation();
print("Ma Position2 " + center.toString());
   mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
     target: center == null ? LatLng(0, 0) : center, zoom: 11.0)));
  }*/
  //void _onMapCreated(GoogleMapController controller) {
//_controller.complete(controller);
//mapController = controller;
//refresh();
// }
void _updateMarker(token){

    setState(() {
    iSloading=true;  
  });
  api.getAllPrestataires(token).then((List<PrestataireOnline> prestataires) {
   if (prestataires != null) {
      for (int i = 0; i < prestataires.length; i++) {
          if (prestataires[i].prestataires.status == "ONLINE" && prestataires[i].prestataires.etat==false) {
          _idMarker.add(prestataires[i].prestataires.telephone);
           }
          }
   }
  });
if(_idMarker!=null){
   for(int i=0; i<_idMarker.length;i++){
     print(_idMarker[i]);
     setState(() {
       markers.remove(markers.firstWhere((Marker marker)=>marker.markerId.value ==_idMarker[i]));
     });
     api.getAllPrestataires(token).then((list){
      if(list.isNotEmpty){
        for(int j=0;j<list.length;j++){
          if(list[j].prestataires.status=="ONLINE" && list[j].prestataires.etat==false && list[j].prestataires.telephone.toString() ==_idMarker[i].toString()){
              print(_idMarker[i].toString());
              print(list[j].prestataires.telephone.toString() );
               setState(() {
                prestaOnline = true;
                markers.add( new 
                  Marker(
                      markerId:
                          MarkerId(list[j].prestataires.telephone),
                      icon: _markerIcon,
                      position: LatLng(
                          list[j].prestataires.positions.latitude,
                          list[j].prestataires.positions.longitude),
                   onTap: () {
                            _googleMapsServices
                  .getDistanceTime(
                      mylat,
                      mylng,
                      list[j].prestataires.positions.latitude,
                      list[j].prestataires.positions.longitude)
                    .then((DistanceTime datemine) {
                     _showDetailPrestataire(list[j], datemine);
                   });                     
                            
                          }
                    /*  infoWindow: InfoWindow(
                          title: list[j].prestataires.nom,
                          snippet: "Voir les details",
                         )
                         */),
                         
                );
                // iSloading=false;
              });
          }else{
            if(list[j].prestataires.status=="ONLINE" && list[j].prestataires.etat==false && list[j].prestataires.telephone.toString() !=_idMarker[i].toString()){
                
                _idMarker.add(list[j].prestataires.telephone);
              print("new prestataire");
                setState(() {
                prestaOnline = true;
                markers.add( new 
                  Marker(
                      markerId:
                          MarkerId(list[j].prestataires.telephone),
                      icon: _markerIcon,
                      position: LatLng(
                          list[j].prestataires.positions.latitude,
                          list[j].prestataires.positions.longitude),
                         onTap: () {
                            _googleMapsServices
                  .getDistanceTime(
                      mylat,
                      mylng,
                      list[j].prestataires.positions.latitude,
                      list[j].prestataires.positions.longitude)
                    .then((DistanceTime datemine) {
                     _showDetailPrestataire(list[j], datemine);
                   });                     
                            
                          }
                      /*infoWindow: InfoWindow(
                          title: list[j].prestataires.nom,
                          snippet: "Voir les details",
                         )*/
                         ),
                          
                );
                // iSloading=false;
              });
            }
          }
          setState(() {
            iSloading=false;
          });
        }
      }
     });
   }
  //_idMarker=[];
  }else{
    print("pas de prestataire en ligne ...");
   _getPrestataires(token1); 
  }
     AppSharedPreferences().isOrder().then((bool order) {
       print("cmdTest " + order.toString());
        if (order == true) {
           setState(() {
             _isorder = true;
           });
        }
    });
}
  @override
  Widget build(BuildContext context) {
    switch (stateIndex) {
      case 0:
        return ShowLoadingView();
      case 1:
        return ShowConnectionErrorView(_onRetryClick);
      case 2:
        return ShowLoadingErrorView(_onRetryClick);
      default:
        return new Scaffold(
          key: _scaffoldKey,
          drawer: new Drawer(
              child: new ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              new DrawerHeader(
                child: ListTile(
                  leading: Stack(
                    children: <Widget>[
                      // Container(
                      //   height: 70.0,
                      //   width: 70.0,
                      //   margin: EdgeInsets.only(top: 10.0, left: 2.0),
                      //   decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(35.0),
                      //       // image: DecorationImage(
                      //       //     image: NetworkImage(client.image),
                      //       //     fit: BoxFit.cover),
                      //       boxShadow: [
                      //         BoxShadow(blurRadius: 7.0, color: Colors.black)
                      //       ])
                      //       ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(45.0),
                        child: new CachedNetworkImage(
                          imageUrl:
                              client.image + "?access_token=" + login.token,
                          height: 60.0,
                          width: 60.0,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                      ),

                      Positioned(
                        bottom: 10.0,
                        right: 2.0,
                        child: Container(
                          height: 30.0,
                          width: 30.0,
                          padding: EdgeInsets.all(1.0),
                          child: IconButton(
                              icon: new Icon(
                                Icons.edit,
                                color: Color(0xFF0C60A8),
                                size: 25.0,
                              ),
                              onPressed: () {}),
                        ),
                      ),
                    ],
                  ),
                  title: new Text(client.nom + " " + client.prenom,
                      maxLines: 1,
                      style: TextStyle(color: Colors.white, fontSize: 15.0)),
                  subtitle: new Text(client.phone,
                      maxLines: 1, style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => UpdateAccountPage(
                                token: login.token,
                              )),
                    );
                  },
                ),
//                  ),
                decoration: new BoxDecoration(color: Colors.black),
              ),
              new ListTile(
                title: new Text(
                  'Vos courses',
                  style: TextStyle(fontSize: 18.0),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => CoursesPage()),
                  );
                },
              ),
              SizedBox(
                height: 1.0,
              ),
              new ListTile(
                title: new Text(
                  'Consulter les tarifs',
                  style: TextStyle(fontSize: 18.0),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => TarifsPage()),
                  );
                },
              ),
              SizedBox(
                height: 1.0,
              ),
              SizedBox(
                height: 1.0,
              ),

              /*new ListTile(
                title: new Text(
                  'Autres Services',
                  style: TextStyle(fontSize: 18.0),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => AutresServices()),
                  );
                },
              ),*/
              new ListTile(
                title: new Text(
                  'Paramètres',
                  style: TextStyle(fontSize: 18.0),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => ParametersPage()),
                  );
                },
              ),
              // the new option

            ],
          )),
          body: Stack(children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    mapController = controller;
                  },
                  zoomGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  myLocationButtonEnabled: true,
                  initialCameraPosition:    _kGooglePlex ,
                  /* initialCameraPosition:
                      CameraPosition(target: LatLng(mylat, mylng), zoom: 13.0), */
                  markers: markers,
                )),
            Positioned(
              height: 50.0,
              left: 5.0,
              top: 15.0,
              child: IconButton(
                iconSize: 35.0,
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
              ),
            ),
            Positioned(
                top: 80.0,
                left: 10.0,
                right: 10.0,
                height: 60.0,
                child: Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    child: InkWell(
                      child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                new Padding(
                                  padding: new EdgeInsets.symmetric(
                                      horizontal: 32.0 - 12.0 / 2),
                                  child: new Container(
                                    height: 5.0,
                                    width: 5.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: Color(0xFFDEAC17)),
                                  ),
                                ),
                                new Text(
                                  destination,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 19.0),
                                )
                              ],
                            ),
                          )),
                      onTap: () {
                        if (prestaOnline == true) {
                           if(bool12==true){
                              showDestinationPlaces();
                           }else{
                               Fluttertoast.showToast(
                                 msg: 'Veiller patienté votre localisation......',
                                 backgroundColor: MyColors.colorBlue,
                                 textColor: Colors.white,
                                 timeInSecForIos: 3);
                            /*setState(() {
                              destination=" locatisation...";
                            });*/
                           }
                          
                        } else if (prestaOnline == false) {

                          setState(() {
                            destination = "Aucun prestataire en ligne";
                          });

                        }
                      },
                    ))),
            _isorder
                ? Positioned(
                    height: 50.0,
                    right: 10.0,
                    bottom: 50.0,
                    child: GestureDetector(
                      child: Image.asset(
                        "assets/images/qr_code.png",
                        height: 35.0,
                        width: 35.0,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => ScanScreen()),
                        );
                      },
                    ),
                  )
                : Container(),
              Positioned(
               bottom: 55,
               width:MediaQuery.of(context).size.width,
               child: iSloading ?
                Center(
                    child: CircularProgressIndicator(),
                )
               :  Center(
                 child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                       RawMaterialButton(
                        child: Icon(
                                    Icons.refresh,
                                    color: MyColors.colorBlue,
                                    size: 45.0,
                                  ),
                        onPressed: () {
                          _updateMarker(token1);
                        },
                      shape: new CircleBorder(),
                        //elevation: 1.0,
                        fillColor: Colors.white,
                        //padding: EdgeInsets.all(5.0),
                      ),
                    ],
                 )
             ),
              ),
            Positioned(
              bottom: 10,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RawMaterialButton(
                        child: Icon(
                          Icons.zoom_in,
                          color: AppColors.blueColor,
                          size: 25.0,
                        ),
                        onPressed: () {
                          mapController.animateCamera(
                            CameraUpdate.zoomIn(),
                          );
                        },
                        shape: new CircleBorder(),
                        elevation: 2.0,
                        fillColor: Colors.white,
                        padding: EdgeInsets.all(10.0),
                      ),
                      RawMaterialButton(
                        child: Icon(
                          Icons.zoom_out,
                          color: AppColors.blueColor,
                          size: 25.0,
                        ),
                        onPressed: () {
                          mapController.animateCamera(
                            CameraUpdate.zoomOut(),
                          );
                        },
                        shape: new CircleBorder(),
                        elevation: 2.0,
                        fillColor: Colors.white,
                        padding: EdgeInsets.all(10.0),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]),
        );
    }
  }
  void showDestinationPlaces1(String prestaId) async {
    destinationModel = await Navigator.of(context)
        .push(new MaterialPageRoute<AutoCompleteModel>(
            builder: (BuildContext context) {
              return new DestinationPage(latitude: mylat, longitude: mylng);
            },
            fullscreenDialog: true));
    if (destinationModel != null) {
      setState(() {
        destination_selected = true;
        destination = destinationModel.adresse;
      });
      showPositionPlaces1(prestaId);
    }
  }

  void showDestinationPlaces() async {
    destinationModel = await Navigator.of(context)
        .push(new MaterialPageRoute<AutoCompleteModel>(
            builder: (BuildContext context) {
              return new DestinationPage(latitude: mylat, longitude: mylng);
            },
            fullscreenDialog: true));
    if (destinationModel != null) {
      setState(() {
        destination_selected = true;
        destination = destinationModel.adresse;
      });
      showPositionPlaces();
    }
  }


  Future showPositionPlaces1(String prestaId) async {
    positiontionModel = await Navigator.of(context)
        .push(new MaterialPageRoute<AutoCompleteModel>(
            builder: (BuildContext context) {
              return new PositionPage(
                latitude: mylat,
                longitude: mylng,
                destination: destinationModel,
              );
            },
            fullscreenDialog: true));
    if (positiontionModel != null) {
      setState(() {
        pret_a_commander = true;
        position = positiontionModel.adresse;
      });
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(
              builder: (context) => ServicesPage2(
                    local: target1,
                    destination: destinationModel,
                    position: positiontionModel,
                    prestaId:prestaId ,
                  )),
          ModalRoute.withName(Navigator.defaultRouteName));
    }
  }
  Future showPositionPlaces() async {
    positiontionModel = await Navigator.of(context)
        .push(new MaterialPageRoute<AutoCompleteModel>(
            builder: (BuildContext context) {
              return new PositionPage(
                latitude: mylat,
                longitude: mylng,
                destination: destinationModel,
              );
            },
            fullscreenDialog: true));
    if (positiontionModel != null) {
      setState(() {
        pret_a_commander = true;
        position = positiontionModel.adresse;
      });
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(
              builder: (context) => ServicesPage(
                    local: target1,
                    destination: destinationModel,
                    position: positiontionModel,
                  )),
          ModalRoute.withName(Navigator.defaultRouteName));
    }
  }

  Widget listItem(String title, Color color) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Container(
          color: Color(0x88F9FAFC),
          child: Row(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.symmetric(horizontal: 32.0 - 12.0 / 2),
                child: new Container(
                  height: 10.0,
                  width: 10.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.rectangle, color: color),
                ),
              ),
              new Text(title)
            ],
          ),
        ));
  }

  ///relance le service en cas d'echec de connexion internet
  void _onRetryClick() {
    setState(() {
      stateIndex = 0;
      _presenter.detailClient(login.userId, login.token);
      _getPrestataires(login.token);
    });
  }

  ///soucis de connexion internet
  @override
  void onConnectionError() {
    setState(() {
      stateIndex = 1;
    });/*
       setState(() {
            iSloading=false;
          });
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        "Verifiez votre connexion internet",
        style: TextStyle(color: Colors.orange),
      ),
    ));*/
  }

  ///en cas de soucis
  @override
  void onLoginError() {
       setState(() {
            iSloading=false;
          });
/*
    setState(() {
      stateIndex = 2;
    });*/
  }

  @override
  void onLoginSuccess(Client1 datas) async {
    if (datas != null) {
      print(" CLIENT" + datas.prenom);
      setState(() {
        _getLocation();
        // _profileUrl =
        //     api.getProfileImgURL(datas.code, datas.image, login.token);
        client = datas;
        stateIndex = 3;
        // if order was accepted by prestataire : we update the position of custumer
        if (_isorder) {
          timer3 = Timer.periodic(
              Duration(seconds: 5), (Timer t) => _updatePosition());
        }
        DatabaseHelper().getClient().then((Client1 c) {
          if (c != null) {
            print("USERExist " + c.user_id.toString());
          } else {
            DatabaseHelper().saveClient(datas);
          }
        });
      });
    }
        timer = Timer.periodic(
            Duration(seconds: 10), (Timer t) => _updateMarker(token1));
  }
}
