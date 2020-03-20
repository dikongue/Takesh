import 'dart:async';
import 'dart:math' show cos, sqrt, asin;
import 'package:etakesh_client/DAO/Presenters/PrestatairesServicePresenter.dart';
import 'package:etakesh_client/DAO/Rest_dt.dart';
import 'package:etakesh_client/DAO/google_maps_requests.dart';
import 'package:etakesh_client/Database/DatabaseHelper.dart';
import 'package:etakesh_client/Models/clients.dart';
import 'package:etakesh_client/Models/commande.dart';
import 'package:etakesh_client/Models/google_place_item.dart';
import 'package:etakesh_client/Models/google_place_item_term.dart';
import 'package:etakesh_client/Models/prestataires.dart';
import 'package:etakesh_client/Models/services.dart';
import 'package:etakesh_client/Utils/AppSharedPreferences.dart';
import 'package:etakesh_client/Utils/Loading.dart';
import 'package:etakesh_client/Utils/colors.dart';
import 'package:etakesh_client/pages/Mycolor.dart';
import 'package:etakesh_client/pages/fluttertoast.dart';
import 'package:etakesh_client/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
//import 'pa'

class CommandePage extends StatefulWidget {
  final AutoCompleteModel destination;
  final AutoCompleteModel position;
  final Service service;
  final LocationModel locposition;
  final LocationModel locdestination;
  final LatLng location;
  CommandePage(
      {Key key,
      this.destination,
      this.position,
      this.service,
      this.locposition,
      this.locdestination,
      this.location})
      : super(key: key);
  @override
  State createState() => CommandePageState();
}

class CommandePageState extends State<CommandePage>
    implements PresetataireServiceContract {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  PresetataireServicePresenter _presenter;

  Commande cmd;
  int stateIndex;
  Login2 login;
  Client1 client;
  //  PrestataireService
  List<PrestataireService> listprestataires;
  DistanceTime distanceTime;
  CommandePageState() {
    _presenter = new PresetataireServicePresenter(this);
  }

  Set<Marker> markers = Set();
  Set<Polyline> _polyLines = Set();
  GoogleMapController mapController;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  GooglePlacesItem destinationModel = new GooglePlacesItem();
  GooglePlacesItem positiontionModel = new GooglePlacesItem();
  LocationModel position, destination;
  int _selectedIndex = -1;
  bool isSelected = false;
  PrestataireService _prestataireselect;
  RestDatasource api = new RestDatasource();
  BitmapDescriptor _markerIcon, _markerIconUser;
  bool loading;
  String clientId;
  double midpointLat, midpointLng;

  ///$ Geodesy geodesy=Geodesy();

  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: true,
    isOverlayTapDismiss: true,
    descStyle: TextStyle(fontSize: 14),
    animationDuration: Duration(milliseconds: 100),
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
  @override
  void initState() {
    loading = false;
    LatLng l1 = LatLng(widget.locdestination.lat, widget.locdestination.lng);
    LatLng l2 = LatLng(widget.locposition.lat, widget.locposition.lng);

    //LatLng midpoint=geodesy.midPointBetweenTwoGeoPoints(l1,l2);
    //print("midPoint lat :"+midpoint.latitude.toString());
    // print("midPoint lng :"+midpoint.longitude.toString());

    AppSharedPreferences().setIsState(false);
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(60, 60)),
            'assets/images/arrivee-icon.png')
        .then((onValue) {
      setState(() {
        _markerIconUser = onValue;
      });
    });
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(60, 60)),
      'assets/images/depart-icon.png',
    ).then((onValue) {
      setState(() {
        _markerIcon = onValue;
      });
    });
    _addMarkerPosition(widget.position.place_id);

    _addMarkerDestination(widget.destination.place_id);

    stateIndex = 0;
    _sendRequest();
    DatabaseHelper().getUser().then((Login2 l) {
      if (l != null) {
        login = l;
        _presenter.loadPrestataires(l.token, widget.service.serviceid);
      }
    });

    // on recuperer l'id du client ..
    DatabaseHelper().getClient().then((Client1 c) {
      if (c != null) {
        setState(() {
          clientId = c.client_id.toString();
        });
        print("CLIENT " + c.client_id.toString());
        print(" userId : " + clientId.toString());
      }
    });

    super.initState();
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    if (lat1 != null) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    }
  }
  /*
* [12.12, 312.2, 321.3, 231.4, 234.5, 2342.6, 2341.7, 1321.4]
* (0-------1-------2------3------4------5-------6-------7)
* */

//  this method will convert list of doubles into latlng
  List<LatLng> convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }

    return result;
  }

  List decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];
    return lList;
  }

  void createRoute(String encondedPoly) {
    setState(() {
      _polyLines.add(Polyline(
          polylineId: PolylineId(widget.location.toString()),
          width: 10,
          points: convertToLatLng(decodePoly(encondedPoly)),
          color: Colors.black));
    });
  }

  void _sendRequest() async {
    String route = await _googleMapsServices.getRouteCoordinates(
        widget.locposition, widget.locdestination);
    createRoute(route);
  }

  void _addMarkerDestination(String paceId) async {
    LocationModel dest = await _googleMapsServices.getRoutePlaceById(paceId);
    setState(() {
      destination = dest;
      markers.add(Marker(
          markerId: MarkerId(paceId),
          position: LatLng(destination.lat, destination.lng),
          infoWindow: InfoWindow(
              title: widget.destination.adresse, snippet: "Destination"),
          icon: _markerIcon));
    });
  }

  void _addMarkerPosition(String paceId) async {
    LocationModel post = await _googleMapsServices.getRoutePlaceById(paceId);
    setState(() {
      position = post;
      markers.add(Marker(
          markerId: MarkerId(paceId),
          position: LatLng(position.lat, position.lng),
          infoWindow: InfoWindow(
              title: widget.position.adresse, snippet: "Point de départ"),
          icon: _markerIconUser));
    });
  }

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
  }

  Completer<GoogleMapController> _controller = Completer();

  Future<bool> _onBackPressed() {
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.warning,
      title: "AVERTISSEMENT!!!",
      desc: "Vous etez sur le point d'annuler votre commande \n",
      buttons: [
        DialogButton(
          child:
              new Text("ANNULER", style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.pop(context, false);
          },
          color:Colors.blue,
        ),
        DialogButton(
          child: new Text("CONFIRMER", style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.pop(context, true);
            Navigator.of(context).pushAndRemoveUntil(
                new MaterialPageRoute(builder: (context) => HomePage()),
                ModalRoute.withName(Navigator.defaultRouteName));
          },
          color:Colors.red,
        )
      ],

      //                             ProgressBouton(),
    ).show();
    /*
    showDialog<bool>(
                context: context,
                      builder: (BuildContext context) {
                        return new AlertDialog(
                          title: new Text("Avertissement !!!"),
                          content: new SingleChildScrollView(
                            child: new ListBody(
                              children: <Widget>[
                                new Text(
                                    "Vous etez sur le point d'annuler votre commande"),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text("ANNULER",
                                  style: TextStyle(color: Colors.lightGreen)),
                              onPressed: () {
                                Navigator.pop(context,false);
                              },
                            ),
                            new FlatButton(
                              child: new Text("CONFIRMER",
                                  style: TextStyle(color: Colors.blue)),
                              onPressed: () {
                                Navigator.pop(context,true);
                                Navigator.of(context).pushAndRemoveUntil(
                                    new MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                    ModalRoute.withName(
                                        Navigator.defaultRouteName));
                              },
                            ),
                          ],
                        );
                      },
                    ); */
  }

  @override
  Widget build(BuildContext context) {
    switch (stateIndex) {
      case 0:
        return ShowLoadingView();
      case 1:
        return ShowLoadingErrorView(_onRetryClick);
      case 2:
        return ShowConnectionErrorView(_onRetryClick);
      default:
        return WillPopScope(
            onWillPop: _onBackPressed,
            child: new Scaffold(
                key: _scaffoldKey,
                body: Stack(children: <Widget>[
                  Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          mapController = controller;
                        },
                        compassEnabled: true,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                                widget.locposition.lat, widget.locposition.lng),
                            zoom: 12.0),
                        markers: markers,
                        polylines: _polyLines,
                      )),
                  Positioned(
                    height: 50.0,
                    left: 5.0,
                    top: 15.0,
                    child: IconButton(
                      onPressed: () {
                        _onBackPressed();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 300,
                    right: 1.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
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
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                          color: Colors.white,
                          child: new Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: new Center(
                                  child: Text(
                                    "Commandez vos taxis",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18.0),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child: new Center(
                                  child: Text(
                                    "Economique, rapide et fiable",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 16.0),
                                  ),
                                ),
                              ),
                              Container(
                                height: 165.0,
                                child: loading
                                    ? Container(
                                        padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 30.0,
                                            bottom: 15.0),
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
//                                            padding: EdgeInsets.all(20.0),
                                                child:
                                                    CircularProgressIndicator(
                                                  backgroundColor:
                                                      Color(0xFF0C60A8),
                                                ),
                                              ),
                                              Text(
                                                "Chargement...",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                            top: 10.0,
                                            bottom: 10.0),
                                        itemCount: listprestataires.length,
                                        itemBuilder:
                                            (BuildContext ctxt, int index) {
                                          return InkWell(
                                            child: Container(
                                                child: getItem(index)),
                                            onTap: () {
                                              _onSelected(index);
                                              setState(() {
                                                _prestataireselect =
                                                    listprestataires[index];
                                              });
                                            },
                                          );
                                        }),
                              ),
                              Divider(),
                              _prestataireselect != null
                                  ? Row(
                                      children: <Widget>[
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15.0, bottom: 10.0),
                                                child: RaisedButton(
                                                    color: Color(0xFFDEAC17),
                                                    child: Text(
                                                        " CONFIRMER " +
                                                            _prestataireselect
                                                                .prestataire
                                                                .prenom
                                                                .toUpperCase(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20.0)),
                                                    padding: EdgeInsets.only(
                                                        left: 15.0,
                                                        right: 15.0,
                                                        top: 10.0,
                                                        bottom: 10.0),
                                                    onPressed: () {
                                                      setState(() {
                                                        loading = true;
                                                      });
                                                      api
                                                          .savePosition(
                                                              widget
                                                                  .locdestination
                                                                  .lat,
                                                              widget
                                                                  .locdestination
                                                                  .lng,
                                                              widget.destination
                                                                  .adresse,
                                                              login.token)
                                                          .then((PositionModel
                                                              dest) {
                                                        if (dest != null) {
                                                          api
                                                              .savePosition(
                                                                  widget
                                                                      .locposition
                                                                      .lat,
                                                                  widget
                                                                      .locposition
                                                                      .lng,
                                                                  widget
                                                                      .position
                                                                      .adresse,
                                                                  login.token)
                                                              .then(
                                                                  (PositionModel
                                                                      post) {
                                                            if (post != null) {
                                                              api
                                                                  .saveCmd(
                                                                      widget
                                                                          .service
                                                                          .prix_douala,
                                                                      post
                                                                          .positionid,
                                                                      dest
                                                                          .positionid,
                                                                      client
                                                                          .client_id,
                                                                      _prestataireselect
                                                                          .prestationid,
                                                                      _prestataireselect
                                                                          .prestataire
                                                                          .prestataireid,
                                                                      widget
                                                                          .position
                                                                          .adresse,
                                                                      widget
                                                                          .destination
                                                                          .adresse,
                                                                      login
                                                                          .token)
                                                                  .then((Commande
                                                                      cmdCreate) {
                                                                if (cmdCreate !=
                                                                    null) {
                                                                  Fluttertoast.showToast(
                                                                      msg:
                                                                          'votre commande a bien été effectuée ...',
                                                                      backgroundColor:
                                                                          MyColors
                                                                              .colorVert,
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      timeInSecForIos:
                                                                          8);
                                                                } else {
                                                                  Fluttertoast.showToast(
                                                                      msg:
                                                                          'cette opération a échouer veillez recommencer..',
                                                                      backgroundColor:
                                                                          MyColors
                                                                              .colorRouge,
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      timeInSecForIos:
                                                                          5);
                                                                }

                                                                AppSharedPreferences()
                                                                    .setOrderCreatedTrue(
                                                                        true);

                                                                //  AppSharedPreferences().setPositionCmdPrecedent(widget.position.adresse);
                                                                //AppSharedPreferences().setDestinationCmdPrecedent(widget.destination.adresse);

                                                                setState(() {
                                                                  loading =
                                                                      false;
                                                                });

                                                                Navigator.of(context).pushAndRemoveUntil(
                                                                    new MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                HomePage()),
                                                                    ModalRoute.withName(
                                                                        Navigator
                                                                            .defaultRouteName));
                                                              });
                                                            }
                                                          });
                                                        }
                                                      });
                                                    }))),
                                        Container(
                                          height: 50.0,
                                          width: 50.0,
                                          margin: EdgeInsets.only(left: 15.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      _prestataireselect
                                                              .prestataire
                                                              .image +
                                                          "?access_token=" +
                                                          login.token),
                                                  fit: BoxFit.cover)),
                                        )
                                      ],
                                    )
                                  : Container(),
                            ],
                          ))),
                ])));
    }
  }

  Widget getItem(indexItem) {
    double distance;
    if (widget.location.latitude != null) {
      print("latitude" + widget.location.latitude.toString());
      distance = calculateDistance(
          widget.location.latitude,
          widget.location.longitude,
          listprestataires[indexItem].prestataire.positions.latitude,
          listprestataires[indexItem].prestataire.positions.longitude);
      if (distance < 50.0) {
        return listprestataires[indexItem].prestataire.status == "ONLINE" &&
                listprestataires[indexItem].prestataire.etat == false
            ? Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 75.0,
                        width: 75.0,
                        margin: EdgeInsets.only(left: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(37.5),
                            image: DecorationImage(
                                image: NetworkImage(
                                    listprestataires[indexItem].vehicule.image +
                                        "?access_token=" +
                                        login.token),
                                fit: BoxFit.cover)),
                      ),
                      Positioned(
                        bottom: 50.0,
                        left: 50.0,
                        child: Container(
                          height: 25.0,
                          width: 25.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.5),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      listprestataires[indexItem]
                                              .prestataire
                                              .image +
                                          "?access_token=" +
                                          login.token),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Center(
                    child: Text(
                      listprestataires[indexItem].prestataire.prenom,
                      style: TextStyle(color: Colors.black, fontSize: 20.0),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  isSelected &&
                          _selectedIndex != -1 &&
                          _selectedIndex == indexItem
                      ? Container(
                          margin: EdgeInsets.only(right: 10.0),
                          padding: EdgeInsets.only(right: 5.0, left: 5.0),
                          color: _selectedIndex != -1 &&
                                  _selectedIndex == indexItem
                              ? Color(0xFF0C60A8)
                              : Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(distanceTime.duree.time + " de vous",
                                  style: TextStyle(
                                      color: _selectedIndex != -1 &&
                                              _selectedIndex == indexItem
                                          ? Colors.white
                                          : Colors.black54,
                                      fontSize: 14.0)),
                              SizedBox(height: 0),
                              Text(distanceTime.distance.dist + " de vous",
                                  style: TextStyle(
                                    color: _selectedIndex != -1 &&
                                            _selectedIndex == indexItem
                                        ? Colors.white
                                        : Colors.black54,
                                    fontSize: 14.0,
                                  )),
                            ],
                          ),
                        )
                      : Container()
                ],
              )
            : null;
      }
    }
  }

  ///relance le service en cas d'echec de connexion internet
  void _onRetryClick() {
    setState(() {
      stateIndex = 0;
      _presenter.loadPrestataires(login.token, widget.service.serviceid);
    });
  }

  ///soucis de connexion internet
  @override
  void onConnectionError() {
    setState(() {
      stateIndex = 2;
    });
  }

  ///en cas de soucis
  @override
  void onLoadingError() {
    setState(() {
      stateIndex = 1;
    });
  }

  @override
  void onLoadingSuccess(List<PrestataireService> prestataires) async {
    DatabaseHelper().getClient().then((Client1 c) {
      if (c != null) {
        print("Client " + c.client_id.toString());
        setState(() {
          client = c;
        });
      }
    });
    if (prestataires.length != 0) {
      print(" Prestataires List" + prestataires.toString());
      setState(() {
        listprestataires = prestataires;
        stateIndex = 3;
      });
    }
  }
}
