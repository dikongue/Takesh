import 'dart:async';

import 'package:etakesh_client/DAO/Presenters/TrackingPresenter.dart';
import 'package:etakesh_client/DAO/Rest_dt.dart';
import 'package:etakesh_client/DAO/google_maps_requests.dart';
import 'package:etakesh_client/Database/DatabaseHelper.dart';
import 'package:etakesh_client/Models/clients.dart';
import 'package:etakesh_client/Models/commande.dart';
import 'package:etakesh_client/Utils/Loading.dart';
import 'package:etakesh_client/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingPage extends StatefulWidget {
  final CommandeDetail commande;
  TrackingPage({Key key, this.commande}) : super(key: key);
  @override
  State createState() => TrackingPageState();
}

class TrackingPageState extends State<TrackingPage>
    implements TrackingContract {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  TrackingPresenter _presenter;

  int stateIndex;
  Login2 login;

  Set<Marker> markers = Set();
  Set<Polyline> _polyLines = Set();
  GoogleMapController mapController;
  BitmapDescriptor _markerIcon,_markerIconUser;
  LatLng _mypositio = new LatLng(4.0922421, 9.748265);
  PositionModel position, destination;

  RestDatasource api = new RestDatasource();
  TrackingPageState() {
    _presenter = new TrackingPresenter(this);
  }
  Marker _prestataire;
  Timer timer;

  @override
  void initState() {
    stateIndex = 0;
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(40, 40)),
            'assets/images/stop_taxi.png')
        .then((onValue) {
      setState(() {
        _markerIconUser = onValue;
      });
    });
    DatabaseHelper().getUser().then((Login2 l) {
      if (l != null) {
        login = l;
        _presenter.loadPostions(l.token, widget.commande.position_priseId,
            widget.commande.prestation.prestataire.prestataireid);
      }
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(40, 40)),
            'assets/images/taxi_icon.png')
        .then((onValue) {
      setState(() {
        _markerIcon = onValue;
      });
    });
    super.initState();
  }

  @override
  void dispose() { 
    timer.cancel();
    super.dispose();
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

    print(lList.toString());

    return lList;
  }

  void _createRoute(String encondedPoly) {
    setState(() {
      _polyLines.add(Polyline(
          polylineId: PolylineId(_mypositio.toString()),
          width: 10,
          points: convertToLatLng(decodePoly(encondedPoly)),
          color: Colors.black));
    });
  }

  void _sendRequest() async {
    String route =
        await _googleMapsServices.getRouteCoordinates2(position, destination);
    _createRoute(route);
  }

  void _addMarkerDestination() async {
    _prestataire = new Marker(
          markerId: MarkerId(destination.positionid.toString()),
          position: LatLng(destination.latitude, destination.longitude),
          infoWindow: InfoWindow(
              title: widget.commande.prestation.prestataire.nom+" "+widget.commande.prestation.prestataire.prenom, snippet: destination.libelle),
          icon: _markerIcon
          );
    setState(() {
      markers.add(_prestataire);
    });
  }

  void _addMarkerPosition() async {
    setState(() {
      markers.add(new Marker(
        markerId: MarkerId(position.positionid.toString()),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(
            title: "Point de prise en charge", snippet: position.libelle),
        icon: _markerIconUser
      ));
    });
  }

  void _updateMarker(){
    setState(() {
       markers.remove(markers.firstWhere((Marker marker) => marker.markerId.value == destination.positionid.toString()));
    });
    api.getPositionPrestatire(login.token,widget.commande.prestation.prestataire.prestataireid).then((positonPrest){
      setState(() {
      markers.add(new Marker(
          markerId: MarkerId(destination.positionid.toString()),
          position: LatLng(positonPrest.latitude, positonPrest.longitude),
          infoWindow: InfoWindow(
              title: widget.commande.prestation.prestataire.nom+" "+widget.commande.prestation.prestataire.prenom, snippet: destination.libelle),
          icon: _markerIcon)
          );
    });
    });
  }

  Completer<GoogleMapController> _controller = Completer();

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
        return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.black,
              elevation: 0.0,
              iconTheme: IconThemeData(color: Colors.white),
              title: Text(
                  "Tracking de Mr " +
                      widget.commande.prestation.prestataire.nom.toUpperCase(),
                  style: TextStyle(color: Colors.white)),
            ),
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
                    initialCameraPosition:
                        CameraPosition(target: _mypositio, zoom: 13.0),
                    markers: markers,
                    polylines: _polyLines,
                  )),
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
            ]));
    }
  }

  ///relance le service en cas d'echec de connexion internet
  void _onRetryClick() {
    setState(() {
      stateIndex = 0;
      _presenter.loadPostions(login.token, widget.commande.position_priseId,
          widget.commande.prestation.prestataire.prestataireid);
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
  void onLoadingSuccess(
      PositionModel position, PositionModel positionPrestataire) async {
    if (position != null)
      setState(() {
        this.position = position;
        _addMarkerPosition();
        print("Position");
        print(position.libelle);
      });
    if (positionPrestataire != null)
      setState(() {
        this.destination = positionPrestataire;
        _addMarkerDestination();
        print("Prestataire");
        print(destination.libelle);
      });
    _sendRequest();
    setState(() {
      stateIndex = 3;
    });
    timer = Timer.periodic(
            Duration(seconds: 15), (Timer t) => _updateMarker());
  } 
   
}
