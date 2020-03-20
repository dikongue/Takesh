
import 'package:etakesh_client/DAO/Presenters/ServicePresenter.dart';
import 'package:etakesh_client/DAO/google_maps_requests.dart';
import 'package:etakesh_client/Models/clients.dart';
import 'package:etakesh_client/Models/google_place_item_term.dart';
import 'package:etakesh_client/Models/services.dart';
import 'package:etakesh_client/Utils/AppSharedPreferences.dart';
import 'package:etakesh_client/Utils/Loading.dart';
import 'package:etakesh_client/pages/Commande/commander.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class AutresServices extends StatefulWidget {
  final AutoCompleteModel destination;
  final AutoCompleteModel position;
  AutresServices({Key key, this.destination, this.position}) : super(key: key);
  @override
  _AutresServicesState createState() => _AutresServicesState();
}

class _AutresServicesState extends State<AutresServices>
    implements ServiceContract1 {
      GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  AutoCompleteModel dest;
  AutoCompleteModel post;
  Service serviceSelected;
  bool service_selected;
  int stateIndex;
  List<Service> services;
  ServicePresenter1 _presenter;
  String token;
  int curent_service = 0;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  LocationModel locposition;
  LocationModel locdestination;
  LatLng location;
  @override
  void initState() {
    _getDestLocation();
    _getUserLocation();
    dest = widget.destination;
    post = widget.position;
    service_selected = false;
    AppSharedPreferences().getToken().then((String token1) {
      if (token1 != '') {
        token = token1;
        _presenter = new ServicePresenter1(this);
        _presenter.loadServices1(token1);
      }
    }).catchError((err) {
      print("Not get Token " + err.toString());
    });
    _getPostLocation();
    stateIndex = 0;
    super.initState();
  }

  _getUserLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      var lat = position.latitude;
      var lng = position.longitude;
      setState(() {
        location = LatLng(lat, lng);
      });
      return location;
    } on Exception {
//      currentLocation = null;
      return null;
    }
  }
  _getDestLocation() async {
    LocationModel destination = await _googleMapsServices
        .getRoutePlaceById(widget.destination.place_id);
    setState(() {
      locdestination = destination;
    });
  }

  _getPostLocation() async {
    LocationModel position =
    await _googleMapsServices.getRoutePlaceById(widget.position.place_id);
    setState(() {
      locposition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    Card getItem(indexItem) {
      return Card(
          child: Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Padding(
                      padding: new EdgeInsets.only(left: 16.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(this.services[indexItem].intitule,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w400)),
                          new Text(
                            this.services[indexItem].temps,
                            style: TextStyle(
                                color: Colors.black54, fontSize: 12.0),
                          ),
                        ],
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(left: 1.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            this.services[indexItem].prix_douala.toString() +
                                " XAF",
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: new Radio(
                          activeColor: Color(0xFFDEAC17),
                          value: this.services[indexItem].serviceid,
                          groupValue: curent_service,
                          onChanged: (active) {
                            setState(() {
                              curent_service =
                                  this.services[indexItem].serviceid;
                              service_selected = true;
                              serviceSelected = this.services[indexItem];
                            });
                          }),
                    ),
                  ],
                ),
              )));
    }

    switch (stateIndex) {
      case 0:
        return ShowLoadingView();

      case 2:
        return ShowConnectionErrorView(_onRetryClick);

      default:
        return new Scaffold(
          key: _scaffoldKey,
            appBar: new AppBar(
              title: new Text(
                'Choisissez un autre service',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.black,
//            iconTheme: IconThemeData(color: Colors.white),
            ),
            body: Stack(children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                        flex: 1,
                        child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(0.0),
                            scrollDirection: Axis.vertical,

                            itemCount: this.services.length,

                            itemBuilder: (BuildContext ctxt, int index) {
                              return getItem(index);
                            })),
                  ],
                ),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                left: 0.0,
                child: Padding(
                  padding: EdgeInsets.only(top: 100.0),
                  child: Center(
                    child: service_selected
                        ? RaisedButton(
                        padding: EdgeInsets.only(left: 5.0, right: 5.0),
                        color: Color(0xFFDEAC17),
                        child: Text(
                          "OK",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 21.0),
                        ),
                        onPressed: () {

                          _scaffoldKey.currentState.showSnackBar(new SnackBar(
                            content: new Text(
                              "Ce service n'es pas encore disponible .....",
                             // style: TextStyle(color: Colors.black),
                            ),
                          ));
                          ///en atente d'une solution ......
                          /*Navigator.of(context).pushAndRemoveUntil(
                              new MaterialPageRoute(

                                  builder: (context) => CommandePage(
                                      destination: dest,
                                      position: post,
                                      service: serviceSelected,
                                      locposition: locposition,
                                      locdestination: locdestination,
                                      location: location
                                  )),
                              ModalRoute.withName(
                                  Navigator.defaultRouteName));
                          */} )
                        : RaisedButton(
                        padding: EdgeInsets.only(left: 5.0, right: 5.0),
                        color: Colors.grey,
                        child: Text(
                          "OK",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 21.0),
                        ),
                        onPressed: () {}),
                  ),
//                      ),
//                    ],
                ),
              )
            ]));
    }
  }

  ///relance le service en cas d'echec de connexion internet
  void _onRetryClick() {
    setState(() {
      stateIndex = 0;
      _presenter.loadServices(token);
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

  ///si tout ce passe bien
  @override
  void onLoadingSuccess(List<Service> services) {
    setState(() {
      this.services = services;
      stateIndex = 3;
    });
  }
}

