import 'dart:core' as prefix0;
import 'dart:core';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:etakesh_client/DAO/Presenters/PrestatairesServicePresenter.dart';
import 'package:etakesh_client/DAO/Presenters/ServicePresenter.dart';
import 'package:etakesh_client/DAO/google_maps_requests.dart';
import 'package:etakesh_client/Models/clients.dart';
import 'package:etakesh_client/Models/commande.dart';
import 'package:etakesh_client/Models/google_place_item_term.dart';
import 'package:etakesh_client/Models/prestataires.dart';
import 'package:etakesh_client/Models/prestation.dart';
import 'package:etakesh_client/Models/services.dart';
import 'package:etakesh_client/Utils/AppSharedPreferences.dart';
import 'package:etakesh_client/Utils/Loading.dart';
import 'package:etakesh_client/pages/Commande/commander.dart';
import 'package:etakesh_client/pages/Commande/commander1.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:etakesh_client/Database/DatabaseHelper.dart';
import 'package:etakesh_client/DAO/Rest_dt.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Mycolor.dart';
import '../fluttertoast.dart';
import '../home_page.dart';
import 'package:intl/date_symbol_data_local.dart';

class ServicesPage2 extends StatefulWidget {
  final AutoCompleteModel destination;
  final AutoCompleteModel position;
  final LatLng local;
  final String prestaId;
  ServicesPage2(
      {Key key, this.destination, this.position, this.local, this.prestaId})
      : super(key: key);
  @override
  State createState() => ServicesPageState();
}

class ServicesPageState extends State<ServicesPage2>
    implements ServiceContract1 {
  AutoCompleteModel dest;
  AutoCompleteModel post;
  Service serviceSelected;
  bool service_selected, valPosition;
  int stateIndex;
  List<Service> services;
  ServicePresenter1 _presenter;
  String token, token2;
  int curent_service = 0;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  LocationModel locposition;
  LocationModel locdestination;
  LatLng location;
  String _userId;
  String _nomClient;
  String _position;
  String _destination;
  String _date;
  int _cmdId, _nbr = 0;
  String _nomPest;
  bool retour = false, iSloading = false;
  String _isStarted;
  String _jour;
  String _heur;
  String prenom;
  List<PrestataireService> listprestataires;
  PrestataireService prestat, prest1;

  PrestatairePrestationOnline prest;
  List<CommandeDetail> data1;
  //List<PrestataireService> listprestataires;
  RestDatasource api = new RestDatasource();
  bool prestaOnline = false, etatp = false, valDestination;
  Position position;
  Client1 clt;
  bool test = false;
  PresetataireServicePresenter _presenter1;

  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: true,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(color: Colors.red, fontSize: 20),
  );

  @override
  void initState() {
    prenom ='';
    //_getUserLocation();
    _getDestLocation();
    _getUserLocation();
    dest = widget.destination;
    post = widget.position;
    service_selected = false;
    location = widget.local;
    iSloading = false;
    valPosition = false;
    valDestination = false;
    DatabaseHelper().getClient().then((Client1 c) {
      if (c != null) {
        setState(() {
          _userId = c.client_id.toString();
          _nomClient = c.prenom.toString();
          clt = c;
        });
        print("CLIENT " + c.client_id.toString());
        print(" userId : " + _userId.toString());
      }
    });

    AppSharedPreferences().getToken().then((String token1) {
      if (token1 != '') {
        token = token1;
        _presenter = new ServicePresenter1(this);
        _presenter.loadServices(token1);
      }
    }).catchError((err) {
      print("Not get Token " + err.toString());
    });

    DatabaseHelper().getUser().then((Login2 l) {
      if (l != null) {
        // _getPrestataires(l.token);
        setState(() {
          token2 = l.token;
        });
      }
    });

    _getPostLocation();
    _photo();
    stateIndex = 0;
    super.initState();
    initializeDateFormatting();
    //_etatLoading();
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

  _getUserLocation() async {
    try {
      if (location == null) {
        position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
        print("latitude:");
        if (position.latitude != null && position.longitude != null) {
          print(position.latitude);
          var lat = position.latitude;
          var lng = position.longitude;
          setState(() {
            location = LatLng(lat, lng);
          });
        } else {
          _getUserLocation();
        }
      } else
        return location;
    } on Exception {
//     currentLocation = null;return null;
    }
  }

  _getDestLocation() async {
    await _googleMapsServices
        .getRoutePlaceById(widget.destination.place_id)
        .then((destination) {
      print("destination....................");
      print("destinatiol modele" + destination.toString());
      if (destination != null)
        setState(() {
          valDestination = true;
          locdestination = destination;
        });
    });
  }

  _getPostLocation() async {
    await _googleMapsServices
        .getRoutePlaceById(widget.position.place_id)
        .then((position) {
      print("loc positionnnnnnnnnnnnnnn");
      setState(() {
        valPosition = true;
        locposition = position;
      });
    });
  }

  Future<bool> _onBackPressed() {
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) => HomePage()),
        ModalRoute.withName(Navigator.defaultRouteName));
  }

  _commander(String prest0, int serviceId) {
    print("fabiol");
    print(prest0);
    print(serviceId);
    setState(() {
      iSloading = true;
    });
    print(listprestataires);
    print("fabiol1");
    if (valDestination && valPosition) {
      for (int i = 0; i < listprestataires.length; i++) {
        print("fabiol2");
        if (listprestataires[i].serviceId == serviceId.toString()) {
          print("fabiol3");
          api
              .savePosition(locdestination.lat, locdestination.lng,
                  widget.destination.adresse, token2)
              .then((PositionModel dest) {
            if (dest != null) {
              print("savePosition");
              api
                  .savePosition(locposition.lat, locposition.lng,
                      widget.position.adresse, token2)
                  .then((PositionModel post) {
                print("savePositionModel");
                if (post != null) {
                  api
                      .saveCmd(
                          serviceSelected.prix_douala,
                          post.positionid,
                          dest.positionid,
                          clt.client_id,
                          listprestataires[i].prestationid,
                          listprestataires[i].prestataireId,
                          widget.position.adresse,
                          widget.destination.adresse,
                          token2)
                      .then((Commande cmdCreate) {
                    if (cmdCreate != null) {
                      print("cmd created");
                      setState(() {
                        iSloading = false;
                      });

                      Fluttertoast.showToast(
                          msg: 'votre commande a bien été effectuée ...',
                          backgroundColor: MyColors.colorVert,
                          textColor: Colors.white,
                          timeInSecForIos: 8);
                      AppSharedPreferences().setOrderCreatedTrue(true);
                      Navigator.of(context).pushAndRemoveUntil(
                          new MaterialPageRoute(
                              builder: (context) => HomePage()),
                          ModalRoute.withName(Navigator.defaultRouteName));
                    }
                  });
                }
              });
            }
          });
        }
      }
    } else {
      _commander(prest0, serviceId);
    }
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
        return WillPopScope(
            onWillPop: _onBackPressed,
            child: new Scaffold(
                appBar: new AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      _onBackPressed();
                    },
                  ),
                  title: new Text(
                    'Choisissez un service',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.black,
                ),
                body: Stack(children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 0.8,
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
                    bottom: 228.0,
                    right: 0.0,
                    left: 0.0,
                    child: new Container(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: new Center(
                              child: Text(
                                "Commandez votre taxis",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.0),
                            child: new Center(
                              child: Text(
                                "Economique, rapide et fiable",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 16.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80.0,
                    right: 0.0,
                    left: 0.0,
                    child: Padding(
                      padding: EdgeInsets.only(top: 80.0),
                      child: Center(child: getPresta('indexItem')),
                    ),
                  ),
                  Positioned(
                    bottom: 10.0,
                    right: 0.0,
                    left: 0.0,
                    child: Padding(
                      padding: EdgeInsets.only(top: 100.0),
                      child: Center(
                        child: service_selected
                            ? (iSloading
                                ? Container(
                                    child: CircularProgressIndicator(),
                                  )
                                : RaisedButton(
                                    padding:
                                        EdgeInsets.only(left: 5.0, right: 5.0),
                                    color: Color(0xFFDEAC17),
                                    child: Text(
                                      "CONFIRMER " + prenom,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 21.0),
                                    ),
                                    onPressed: () {
                                      //  _presenter1.loadPrestataires(token2,serviceSelected.serviceid);
                                      //  _showDetailCommand(widget.prestaId,serviceSelected.serviceid);
                                      verif(widget.prestaId,
                                          serviceSelected.serviceid);
                                    }))
                            : RaisedButton(
                                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                color: Colors.grey,
                                child: Text(
                                  "COMMANDER",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 21.0),
                                ),
                                onPressed: () {}),
                      ),
                    ),
                  )
                ])));
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

  bool verif1(String prest0, int serviceId) {
    print('la liste........');
    verif(prest0, serviceId);
    if (RestDatasource().getCmdCreatedClient(token, int.parse(_userId)) !=
        null) {
      return true;
    } else
      return false;
  }

  void verif(String prest0, int serviceId) {
    print("verifie");
    RestDatasource().getNewCmdClient(token, int.parse(_userId)).then((data) {
      print(data.length);
      print('liste......');
      int i = 0;
      if (data.length > 0) {
        print('liste......');
        DateTime dateCmd;
        // while(i<data.length) {
        if (data[i].is_accepted.toString() == 'false' &&
            data[i].is_refused.toString() == 'false') {
          print(
              'votre commande a déja étè accepter...............................');
          _position = data[i].position_prise_en_charge.toString();
          _destination = data[i].position_destination.toString();
          _date = data[i].date.toString();
          _cmdId = data[i].commandeid;
          _isStarted = data[i].is_started.toString();
          print(_destination);
          print(_date);
          print(_position);
          print(_cmdId);
          print(_isStarted);
          print(data.length);
          print(i);

          dateCmd = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(_date);
          var formatter = new DateFormat('EEEE d MMMM y', 'fr_CA');
          _jour = formatter.format(dateCmd);
          _heur = " à " + DateFormat.Hm().format(dateCmd) + " min";
          print(dateCmd);
          print(_jour);
          Alert(
            context: context,
            style: alertStyle,
            type: AlertType.warning,
            title: "AVERTISSEMENT",
            desc:
                "Cette nouvelle course entrainera la suppression de la course de " +
                    _position +
                    " à " +
                    _destination +
                    " que vous avez passer le " +
                    _jour +
                    " à" +
                    _heur +
                    " qui es en attente d'aceptation ",
            buttons: [
              DialogButton(
                child: Text(
                  "NON",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () => Navigator.of(context).pop(),
                color: Colors.blue,
              ),
              DialogButton(
                child: Text(
                  "OUI",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () {
                  RestDatasource()
                      .deletCmdClient1(token, int.parse(_userId), _cmdId)
                      .then((data) {
                    if (data == '200') {
                      print("commande supprimer ");
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                          msg: 'course supprimée ...',
                          backgroundColor: MyColors.colorRouge,
                          textColor: Colors.white,
                          timeInSecForIos: 5);
                    }
                  });
                },
                color: Colors.red,
              )
            ],
          ).show();
        } else {
          if (data[i].is_accepted.toString() == 'true') {
            _nbr = 2;
            print(
                'votre commande a déja étè accepter...............................');
            Alert(
              context: context,
              type: AlertType.info,
              title: "INFORMATION",
              desc:
                  "Vous avez une course  accepter \n  donc pour une nouvelle course vous dévez l'annuler ",
              buttons: [
                DialogButton(
                  child: Text(
                    "NON",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    /* Navigator.of(context).pushAndRemoveUntil(
                        new MaterialPageRoute(builder: (context) => HomePage()),
                        ModalRoute.withName(Navigator.defaultRouteName));*/
                  },
                  width: 120,
                  color: Colors.blue,
                ),
                DialogButton(
                  child: Text(
                    "OUI",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    RestDatasource()
                        .updateCmdStatus1(data[i], token)
                        .then((dat) {
                      if (dat != null) {
                        print('commande annuler avec sucess........');
                        print(data[i].prestation.prestataireId.toString());
                        print(dat.status);

                        print("prestatairesId ......." +
                            dat.prestataireId.toString());
                        String prestataireId =
                            data[i].prestation.prestataireId.toString();

                        api
                            .getPrestataires1(token, prestataireId)
                            .then((List<PrestataireOnline> prestataires) {
                          if (prestataires != null) {
                            print("fababy........");
                            api
                                .updatPresta(prestataires[0], "false", token)
                                .then((stat) {
                              if (stat == '200') {
                                Navigator.of(context).pop();
                                Fluttertoast.showToast(
                                    msg: 'course annuler...',
                                    backgroundColor: MyColors.colorVert,
                                    textColor: Colors.white,
                                    timeInSecForIos: 5);
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        'cette opération a échouer veillez recommencer..',
                                    backgroundColor: MyColors.colorRouge,
                                    textColor: Colors.white,
                                    timeInSecForIos: 5);
                              }
                            });
                          }
                        });

                        print("cmd update");
                      }
                    });
                  },
                  color: Colors.red,
                  width: 120,
                )
              ],
            ).show();
          }
        }
        i = i + 1;
        //  }*/
      } else {
        print("pas de cmd............");
        _nbr = 3;
        _commander(prest0, serviceId);
      }
    });
  }

  _photo() async {
    api.getOnePrestatairesServices(token2, widget.prestaId).then((p) {
      print("mince!!");
      print(p);
      if (p != null) {
        print("monsieur le prestataire");
        setState(() {
          prenom=p[0].prestataire.prenom;
          listprestataires = p;
          prest1 = p[0];
          test = true;
        });
        print(p[0].vehicule.image);
        print(p[0].prestataire.nom);
      }
    });
  }

  Widget getPresta(indexItem) {
    _photo();
    if (test) {
      return Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 120.0,
                width: 120.0,
                margin: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(55.5),
                    image: DecorationImage(
                        image: NetworkImage(
                            prest1.vehicule.image + "?access_token=" + token),
                        fit: BoxFit.cover)),
              ),
              Positioned(
                bottom: 60.0,
                left: 60.0,
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.5),
                      image: DecorationImage(
                          image: NetworkImage(prest1.prestataire.image +
                              "?access_token=" +
                              token),
                          fit: BoxFit.cover)),
                ),
              ),
            ],
          ),
          SizedBox(height: 5.0),
          Center(
            child: Text(
              prest1.prestataire.prenom,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 10.0),
            padding: EdgeInsets.only(right: 5.0, left: 5.0),
            color: Color(0xFF0C60A8),
          )
        ],
      );
    }else
    return Container();
  }
}
