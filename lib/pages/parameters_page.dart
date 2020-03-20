import 'package:cached_network_image/cached_network_image.dart';
import 'package:etakesh_client/DAO/Presenters/LoginPresenter.dart';
import 'package:etakesh_client/DAO/Rest_dt.dart';
import 'package:etakesh_client/Database/DatabaseHelper.dart';
import 'package:etakesh_client/Models/clients.dart';
import 'package:etakesh_client/Utils/AppSharedPreferences.dart';
import 'package:etakesh_client/Utils/AppSharedPreferences.dart' as prefix0;
import 'package:etakesh_client/Utils/Loading.dart';
import 'package:etakesh_client/pages/add_home_adresse.dart';
import 'package:etakesh_client/pages/add_office_adresse.dart';
import 'package:etakesh_client/pages/confidentialite.dart';
import 'package:etakesh_client/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class ParametersPage extends StatefulWidget {
  @override
  State createState() => ParametersPageState();
}

class ParametersPageState extends State<ParametersPage>
    implements ParameterContract {
  bool loading;
  bool err = false;
  bool _isOfficeSave = false;
  bool _isHomeSave = false;
  Client1 client;
  RestDatasource api = new RestDatasource();
  int stateIndex;
  LatLng target;
  double mylat = 4.0922421;
  double mylng = 9.748265;
  LocalAdress _homeAdresse, _officeAdresse;
  String _token;
  final GlobalKey<ScaffoldState> _mScaffoldState =
      new GlobalKey<ScaffoldState>();
  ParameterPresenter _presenter;
  ParametersPageState() {
    _presenter = new ParameterPresenter(this);
  }
  @override
  void initState() {
    target = LatLng(mylat, mylng);
    AppSharedPreferences().getToken().then((String token) {
      _token = token;
    });
    stateIndex = 0;
    AppSharedPreferences().isOfficeSave().then((bool office) {
      print("Office " + office.toString());
      if (office == true) {
        DatabaseHelper().getOfficeAdresse().then((LocalAdress l) {
          setState(() {
            _isOfficeSave = true;
            _officeAdresse = l;
          });
        });
      }
    });

    AppSharedPreferences().isHomeSave().then((bool home) {
      print("Home " + home.toString());
      if (home == true) {
        DatabaseHelper().getHomeAdresse().then((LocalAdress l) {
          setState(() {
            _isHomeSave = true;
            _homeAdresse = l;
          });
        });
      }
    });
    _presenter.datasClient();
    loading = false;
    err = false;
    super.initState();
  }

  Widget _optionsHome() => PopupMenuButton<int>(
        itemBuilder: (context) => [
          // PopupMenuItem(
          //   value: 1,
          //   child: Text("Modifier"),
          // ),
          PopupMenuItem(
            value: 2,
            child: Text("Supprimer"),
          ),
        ],
        onSelected: (value) {
          print("Home value :$value");
          if (value == 2) {
            showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return new AlertDialog(
                  title: new Text("Avertissement !!!"),
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: <Widget>[
                        new Text(
                            "Vous etez sur le point de supprimer l'adresse de votre domicile"),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("ANNULER",
                          style: TextStyle(color: Colors.lightGreen)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    new FlatButton(
                      child:
                          new Text("Ok", style: TextStyle(color: Colors.blue)),
                      onPressed: () {
                        DatabaseHelper().clearHomeAdd();
                        AppSharedPreferences().setHomeSave(false);
                        setState(() {
                          _isHomeSave = false;
                        });
                        Navigator.of(context).pop();
                         _showErrSnackBar("Adresse supprimée avec Success !!!");
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        icon: Icon(
          Icons.more_vert,
          color: Colors.black,
        ),
      );

  Widget _optionsOffice() => PopupMenuButton<int>(
        itemBuilder: (context) => [
          // PopupMenuItem(
          //   value: 1,
          //   child: Text("Modifier"),
          // ),
          PopupMenuItem(
            value: 2,
            child: Text("Supprimer"),
          ),
        ],
        onSelected: (value) {
          print("Office value :$value");
          if (value == 2) {
            showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return new AlertDialog(
                  title: new Text("Avertissement !!!"),
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: <Widget>[
                        new Text(
                            "Vous etez sur le point de supprimer votre adresse professionnelle"),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("ANNULER",
                          style: TextStyle(color: Colors.lightGreen)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    new FlatButton(
                      child:
                          new Text("Ok", style: TextStyle(color: Colors.blue)),
                      onPressed: () {
                        DatabaseHelper().clearOfficeAdd();
                        AppSharedPreferences().setOfficeSave(false);
                        setState(() {
                          _isOfficeSave = false;
                        });
                        Navigator.of(context).pop();
                         _showErrSnackBar("Adresse supprimée avec Success !!!");
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        icon: Icon(
          Icons.more_vert,
          color: Colors.black,
        ),
      );

  void _showAddHomeAdressPage() async {
    if (!_isHomeSave)
      _homeAdresse =
          await Navigator.of(context).push(new MaterialPageRoute<LocalAdress>(
              builder: (BuildContext context) {
                return new AddHommeAdressPage(
                  lat: target.latitude,
                  lng: target.longitude,
                );
              },
              fullscreenDialog: true));
    if (_homeAdresse != null) {
      print("Domicile" + _homeAdresse.adresse);
      setState(() {
        _isHomeSave = true;
      });
    }
  }

  void _showAddOfficeAdressPage() async {
    if (!_isOfficeSave)
      _officeAdresse =
          await Navigator.of(context).push(new MaterialPageRoute<LocalAdress>(
              builder: (BuildContext context) {
                return new AddOfficeAdressPage(
                  lat: target.latitude,
                  lng: target.longitude,
                );
              },
              fullscreenDialog: true));
    if (_officeAdresse != null) {
      print("Office" + _officeAdresse.adresse);
      setState(() {
        _isOfficeSave = true;
      });
    }
  }

  void _showErrSnackBar(String body) {
    var snackBar = SnackBar(
      content: Text(
        body,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      action: SnackBarAction(label: "OK", onPressed: () {}),
    );
    _mScaffoldState.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    switch (stateIndex) {
      case 0:
        return ShowLoadingView();
      case 1:
        return ShowLoadingErrorView(_onRetryClick);

      default:
        return new Scaffold(
            key: _mScaffoldState,
            appBar: new AppBar(
              title: new Text(
                'Paramètres du compte',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.black,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: <Widget>[
                  new ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: new CachedNetworkImage(
                          imageUrl: client.image + "?access_token=" + _token,
                          height: 70.0,
                          width: 65.0,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                      ),

                      // Container(
                      //     width: 75.0,
                      //     height: 75.0,
                      //     child: ClipRRect(
                      //       borderRadius: BorderRadius.circular(20.0),
                      //         child: CachedNetworkImage(
                      //       fit: BoxFit.cover,
                      //       imageUrl: client.image,
                      //       placeholder: (context, url) => Center(
                      //           child: CircularProgressIndicator(
                      //         backgroundColor: Colors.lightBlue,
                      //       )),
                      //       errorWidget: (context, url, error) =>
                      //           new Icon(Icons.error),
                      //     )),
                      //     decoration: new BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       border:
                      //           new Border.all(color: Colors.black, width: 2.0),
                      //     )),

                      title: new Text("\n"+client.nom + " " + client.prenom,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      subtitle: new Text(client.phone + "\n",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      isThreeLine: true),
                  Divider(
                    height: 4.0,
                    color: Color(0xFFE2E2E2),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ListTile(
                    title: new Text("Favoris",
                        style: TextStyle(color: Colors.black54)),
                  ),
                  SizedBox(
                    height: 0.0,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.home,
                      color: Colors.black,
                    ),
                    title: _isHomeSave
                        ? Text("Votre domicile",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))
                        : Text("Ajouter un domicile",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                    subtitle: _isHomeSave
                        ? Text(_homeAdresse.adresse,
                            style: TextStyle(color: Colors.lightBlueAccent))
                        : null,
                    onTap: () {
                      _showAddHomeAdressPage();
                    },
                    trailing: _isHomeSave ? _optionsHome() : null,
                  ),
                  SizedBox(
                    height: 0.0,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.business_center,
                      color: Colors.black,
                    ),
                    title: _isOfficeSave
                        ? Text("Votre adreese professionnelle",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))
                        : Text("Ajouter une adresse professionnelle",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                    subtitle: _isOfficeSave
                        ? Text(_officeAdresse.adresse,
                            style: TextStyle(color: Colors.lightBlueAccent))
                        : null,
                    onTap: () {
                      _showAddOfficeAdressPage();
                    },
                    trailing: _isOfficeSave ? _optionsOffice() : null,
                  ),
                  // ListTile(
                  //   title: new Text(
                  //     "Autres lieux enregistres",
                  //     style: TextStyle(color: Colors.lightBlueAccent),
                  //   ),
                  // ),
                  Divider(
                    height: 4.0,
                    color: Color(0xFFE2E2E2),
                  ),
                  ListTile(
                    title: new Text("Paramètres de confidentialite",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    subtitle: new Text(
                      "Gérer les données que vous partagez avec nous",
                      style: TextStyle(
                          color: Colors.grey.withOpacity(0.7), fontSize: 12.0),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => ConfidentialitePage()),
                      );
                    },
                  ),
                  Divider(
                    height: 4.0,
                    color: Color(0xFFE2E2E2),
                  ),
                  ListTile(
                    title: new Text("Déconnexion",
                        style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0)),
                    trailing: loading
                        ? CircularProgressIndicator(
                            backgroundColor: Color(0xFF0C60A8),
                          )
                        : Text(""),
                    onTap: () {
                      showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return new AlertDialog(
                            title: new Text("Avertissement !!!"),
                            content: new SingleChildScrollView(
                              child: new ListBody(
                                children: <Widget>[
                                  new Text(
                                      "Vous etez sur le point de vouloir vous déconnecter"),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("ANNULER",
                                    style: TextStyle(color: Colors.lightGreen)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              new FlatButton(
                                child: new Text("CONFIRMER",
                                    style: TextStyle(color: Colors.blue)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    loading = true;
                                  });
                                  //AppSharedPreferences().setBienvenue(false);
                                  AppSharedPreferences()
                                      .getToken()
                                      .then((String token) {
                                    if (token != '') {
                                      Future.delayed(Duration(seconds: 2),
                                          () async {
                                        final response1 = await http.post(
                                          Uri.encodeFull(
                                              "http://www.api.e-takesh.com:26525/api/Users/logout?access_token=" +
                                                  token),
                                        );
                                        if (response1.statusCode == 204) {
                                          AppSharedPreferences()
                                              .setAppLoggedIn(false);
                                          AppSharedPreferences()
                                              .setUserToken('');
                                         //DatabaseHelper().clearUser();
                                         //DatabaseHelper().clearClient();
                                          Navigator.of(_mScaffoldState
                                                  .currentContext)
                                              .pushAndRemoveUntil(
                                                  new MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginPage()),
                                                  ModalRoute.withName(Navigator
                                                      .defaultRouteName));
                                          setState(() {
                                            loading = false;
                                          });
                                        } else {
                                          setState(() {
                                            loading = false;
                                          });
                                          _showErrSnackBar("Erreur : Impossible de se deconnecter");
                                          // If that call was not successful, throw an error.
                                          throw Exception(
                                              'Erreur de connexion du client' +
                                                  response1.body.toString());
                                        }
                                      });
                                    } else {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        loading = false;
                                      });
                                      _showErrSnackBar("Erreur : Impossible de se deconnecter");
                                    }
                                  }).catchError((error) {
                                    setState(() {
                                      loading = false;
                                    });
                                    _showErrSnackBar("Erreur : Impossible de se deconnecter");
                                    print("Not get Token " + error.toString());
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            )));
    }
  }

  ///relance le service en cas d'echec de connexion internet
  void _onRetryClick() {
    setState(() {
      stateIndex = 0;
      _presenter.datasClient();
    });
  }

  ///en cas de soucis
  @override
  void onLoginError() {
    setState(() {
      stateIndex = 1;
    });
  }

  @override
  void onLoardSuccess(Client1 datas) async {
    if (datas != null) {
      setState(() {
        client = datas;
        // _profileUrl = api.getProfileImgURL(client.code, client.image, _token);
        stateIndex = 3;
      });
    }
  }
}
