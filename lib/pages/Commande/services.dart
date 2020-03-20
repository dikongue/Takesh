import 'dart:core' as prefix0;
import 'dart:core';
import 'dart:math';

import 'package:etakesh_client/DAO/Presenters/ServicePresenter.dart';
import 'package:etakesh_client/DAO/google_maps_requests.dart';
import 'package:etakesh_client/Models/clients.dart';
import 'package:etakesh_client/Models/commande.dart';
import 'package:etakesh_client/Models/google_place_item_term.dart';
import 'package:etakesh_client/Models/prestataires.dart';
import 'package:etakesh_client/Models/services.dart';
import 'package:etakesh_client/Utils/AppSharedPreferences.dart';
import 'package:etakesh_client/Utils/Loading.dart';
import 'package:etakesh_client/pages/Commande/commander.dart';
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

class ServicesPage extends StatefulWidget {
  final AutoCompleteModel destination;
  final AutoCompleteModel position;
  final LatLng local;
  ServicesPage({Key key, this.destination, this.position, this.local})
      : super(key: key);
  @override
  State createState() => ServicesPageState();
}

class ServicesPageState extends State<ServicesPage>
    implements ServiceContract1 {
  AutoCompleteModel dest;
  AutoCompleteModel post;
  Service serviceSelected;
  bool service_selected;
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
  bool retour = false;
  String _isStarted;
  String _jour;
  String _heur;
  List<CommandeDetail> data1;
  List<PrestataireService> listprestataires;
  RestDatasource api = new RestDatasource();
  bool prestaOnline = false;
  Position position;

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
    _getUserLocation();
    _getDestLocation();
    _getUserLocation();
    dest = widget.destination;
    post = widget.position;
    service_selected = false;
    location = widget.local;

    DatabaseHelper().getClient().then((Client1 c) {
      if (c != null) {
        setState(() {
          _userId = c.client_id.toString();
          _nomClient = c.prenom.toString();
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
        _getPrestataires(l.token);
        setState(() {
          token2 = l.token;
        });
      }
    });
    _getPostLocation();

    stateIndex = 0;
    super.initState();
    initializeDateFormatting();
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

  Future<bool> _onBackPressed() {
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) => HomePage()),
        ModalRoute.withName(Navigator.defaultRouteName));
  }

  _getPrestataires(token2) {
    print(token2.toString());

    print("test prestation............");
    api.getAllPrestataires(token2).then((List<PrestataireOnline> prestataires) {
      print(prestataires);
      if (prestataires != null) {
        for (int i = 0; i < prestataires.length; i++) {
          if (prestataires[i].prestataires.status == "ONLINE" &&
              prestataires[i].prestataires.etat == false) {
            double distance = calculateDistance(
                widget.local.latitude,
                widget.local.longitude,
                prestataires[i].prestataires.positions.latitude,
                prestataires[i].prestataires.positions.longitude);
            if (distance < 20.00) {
              print("Distance :" + i.toString());
              print(distance);

              setState(() {
                prestaOnline = true;
              });
            }
          }
        }
      }
    }).catchError((onError) {
      print("Probleme " + onError.toString());
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
                                  AppSharedPreferences()
                                      .isState()
                                      .then((bool1) {
                                    if (bool1 == true) {
                                      if (prestaOnline == true) {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        CommandePage(
                                                            destination: dest,
                                                            position: post,
                                                            service:
                                                                serviceSelected,
                                                            locposition:
                                                                locposition,
                                                            locdestination:
                                                                locdestination,
                                                            location:
                                                                location)),
                                                ModalRoute.withName(Navigator
                                                    .defaultRouteName));
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                'Un incident s’est produit pendant l’exécution de cette tache veillée essayer plus tard... ',
                                            backgroundColor: MyColors.colorBlue,
                                            textColor: Colors.white,
                                            timeInSecForIos: 3);
                                      }
                                    } else {
                                      verif1();
                                    }
                                  });
                                })
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

  bool verif1() {
    print('la liste........');
    verif();
    if (RestDatasource().getCmdCreatedClient(token, int.parse(_userId)) !=
        null) {
      return true;
    } else
      return false;
  }

  bool verif() {
    RestDatasource().getNewCmdClient(token, int.parse(_userId)).then((data) {
      print(data.length);
      print('liste......');
      int i = 0;
      if (data.length > 0) {
        DateTime dateCmd;
        while (i < data.length) {
          if (data[i].status == "CREATED") {
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
                      " " +
                      _heur,
              buttons: [
                DialogButton(
                  child: Text(
                    "ANNULER",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () => Navigator.pop(context),
                  color:Colors.blue
                ),
                DialogButton(
                  child: Text(
                    "SUPPRIMER",
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
            if (data[i].status == "READ") {
              print(
                  'votre commande a déja étè accepter...............................');
              Alert(
                context: context,
                type: AlertType.info,
                title: "INFORMATION",
                desc:
                    "Vous avez une course  déja acceptée \n  donc pour une nouvelle course vous dévez l'annuler ",
                buttons: [
                  DialogButton(
                    child: Text(
                      "NON",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.of(context).pop();
                     /* Navigator.of(context).pushAndRemoveUntil(
                          new MaterialPageRoute(
                              builder: (context) => HomePage()),
                          ModalRoute.withName(Navigator.defaultRouteName));*/
                    },
                    width: 120,
                  ),
                  DialogButton(
                    child: Text(
                      "OUI",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.red,
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
                  )
                ],
              ).show();
            }
          }
          i = i + 1;
        }
      } else {
        print("pas de cmd............");
        _nbr = 3;
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(
                builder: (context) => CommandePage(
                    destination: dest,
                    position: post,
                    service: serviceSelected,
                    locposition: locposition,
                    locdestination: locdestination,
                    location: location)),
            ModalRoute.withName(Navigator.defaultRouteName));
      }
    });
  }
}
