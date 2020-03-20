
import 'package:etakesh_client/DAO/Presenters/PrestatairesServicePresenter.dart';
import 'package:etakesh_client/DAO/Rest_dt.dart';
import 'package:etakesh_client/Database/DatabaseHelper.dart';
import 'package:etakesh_client/Models/clients.dart';
import 'package:etakesh_client/Models/commande.dart';
import 'package:etakesh_client/Models/google_place_item.dart';
import 'package:etakesh_client/Models/google_place_item_term.dart';
import 'package:etakesh_client/Models/prestataires.dart';
import 'package:etakesh_client/Models/services.dart';
import 'package:etakesh_client/Utils/Loading.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:geodesy/geodesy.dart';

class CommandePage1 extends StatefulWidget {
  final AutoCompleteModel destination;
  final AutoCompleteModel position;
  final Service service;
  final LocationModel locposition;
  final LocationModel locdestination;
  final LatLng location;
  final String prestatId;
  CommandePage1(
      {Key key,
      this.destination,
      this.position,
      this.service,
      this.locposition,
      this.locdestination,
      this.prestatId,
      this.location})
      : super(key: key);
  @override
  State createState() => CommandePageState1();
}

class CommandePageState1 extends State<CommandePage1>
    implements PresetataireServiceContract{
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  PresetataireServicePresenter _presenter;

  Commande cmd;
  int stateIndex;
  Login2 login;
  Client1 client;
  //  PrestataireService
  
  DistanceTime distanceTime;
  Set<Marker> markers = Set();
  Set<Polyline> _polyLines = Set();
  GoogleMapController mapController;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  CommandePageState1() {
    _presenter = new PresetataireServicePresenter(this);
  }
  List<PrestataireService> listprestataires;
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
  int index;

  double midpointLat, midpointLng;
  @override
  void initState() {
    loading = false;
    stateIndex = 0;
   // _sendRequest();
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
       return PhysicalModel(
       //child: Container(
      
       //child: getItem(widget.prestatId),
      
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
                                            child: CircularProgressIndicator(
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
                                        child: Container(child: getItem(index)),
                                       // onTap: () {
                                         // _onSelected(index);
                                          //setState(() {
                                          //  _prestataireselect =
                                         //       listprestataires[index];
                                        //  });
                                      //  },
                                      );
                                    }),
                          ),
                        ]
                      )
                    //  )
                      ),
     //)
     color: Colors.blue,
    );
    }
  }

  Widget getItem(indexItem) {
    int index;
  //  api.getAllPrestatairesServices(login.token, widget.service.serviceid).then((list){
    //  if(list!=null){
      //       for(int i=0;i<=listprestataires.length;i++){
      //if(list[i].prestataireId==int.parse(indexItem))
      //index=i;
     // }
      //}
      return listprestataires[index].prestataire.status == "ONLINE" && listprestataires[indexItem].prestataire.etat==false
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
                          image: NetworkImage(listprestataires[indexItem]
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
            color:
            _selectedIndex != -1 && _selectedIndex == indexItem
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
   // });
  
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
