import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:etakesh_client/DAO/Rest_dt.dart';
import 'package:etakesh_client/Database/DatabaseHelper.dart';
import 'package:etakesh_client/Models/clients.dart';
import 'package:etakesh_client/Models/prestataires.dart';
import 'package:etakesh_client/Utils/AppSharedPreferences.dart';
import 'package:etakesh_client/pages/FirstLaunch/condition_utilisation.dart';
import 'package:etakesh_client/pages/FirstLaunch/create_password.dart';
import 'package:etakesh_client/pages/Mycolor.dart';
import 'package:etakesh_client/pages/fluttertoast.dart';
import 'package:etakesh_client/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class EnterEmailPage extends StatefulWidget {
  final String phone_n;

  EnterEmailPage({Key key, this.phone_n}) : super(key: key);
  @override
  _EnterEmailPageState createState() => _EnterEmailPageState();
}

class _EnterEmailPageState extends State<EnterEmailPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _agreedToTOS = true;
  var _emailController = new TextEditingController();
  var _nomController = new TextEditingController();
  var _prenomController = new TextEditingController();
  var _villeController = new TextEditingController();
  var _naissanceController = new TextEditingController();
  Position position;
  double mylat, mylng;
  double lat = 4.0923523;
  double lng = 9.7487852;
  bool existemail;
  bool error;
  RestDatasource api = new RestDatasource();
  bool loading=false;
  String emailto;
  @override
  void initState() {
    mylat = 4.0922421;
    mylng = 9.748265;
   existemail = false;
    loading = false;
    error = false;
    _maPossiton();
  }

  Future<void> _maPossiton() async {
    await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((p) {
      if (p.latitude != null && p.longitude != null) position = p;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF0C60A8),
          foregroundColor: Colors.white,
          child: Icon(Icons.arrow_forward),
          tooltip: "Adresse email",
          onPressed: _submittable() ? _submit : null),
      appBar: new AppBar(
        title: new Text(
          'Données personnelles',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: Form(
          key: _formKey,
          child: new ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Informations complémentaires pour votre compte",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.w300),
                    )),
              ),
             /* new TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email (optionnel)',
                  icon: Icon(Icons.email, color: Colors.black),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (String value) {
                  if (value.trim().isEmpty) {

                   /* _emailController.text="T" +
                  DateTime.now().month.toString() +
                  DateTime.now().day.toString() +
                  DateTime.now().hour.toString() +
                  DateTime.now().second.toString() +
                  "CL" +
                  DateTime.now().year.toString()+"@takesh.com";*/
                   // return 'Adresse email obligatoire';
                  } else if (!new RegExp(
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                      .hasMatch(value)) {
                    return "Email non valide";
                  }
                },
              ),*/
              new TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom *',
                  icon: Icon(Icons.person, color: Colors.black),
                ),
                validator: (String value) {
                  if (value.trim().isEmpty) {
                    return 'Nom obligatoire';
                  }
                },
              ),
              new TextFormField(
                controller: _prenomController,
                decoration: const InputDecoration(
                  labelText: 'Prénom *',
                  icon: Icon(Icons.person, color: Colors.black),
                ),
                validator: (String value) {
                  if (value.trim().isEmpty) {
                    return 'Prénom obligatoire';
                  }
                },
              ),
//              new TextFormField(
//                controller: _naissanceController,
//                decoration: const InputDecoration(
//                    labelText: 'Date de naissance',
//                    icon: Icon(Icons.calendar_today, color: Colors.black)),
//                keyboardType: TextInputType.datetime,
//                validator: (String value) {
//                  if (value.trim().isEmpty) {
//                    return 'Date de naissance obligatoire';
//                  }
//                },
//              ),
              new TextFormField(
                controller: _villeController,
                decoration: const InputDecoration(
                    labelText: 'Ville de résidence *',
                    icon: Icon(Icons.location_city, color: Colors.black)),
                validator: (String value) {
                  if (value.trim().isEmpty) {
                    return 'Ville obligatoire';
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      activeColor: Color(0xFF0C60A8),
                      value: _agreedToTOS,
                      onChanged: _setAgreedToTOS,
                    ),
                    GestureDetector(
                      //   onTap: () => _setAgreedToTOS(!_agreedToTOS),
                      onTap: () {
                        _setAgreedToTOS(!_agreedToTOS);
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => ConditionUtilisation()),
                        );
                      },
                      child: Text(
                        "Je certifie avoir écris , lus \n et validé ces informations et \n J'accèpte les conditions d'utilisation \n de l'application Takesh ",
                        maxLines: 4,
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w300,
                            color: _agreedToTOS ? Colors.black87 : Colors.red),
                      ),
                    ),
                    
                   loading? Container(
                    
                      child: CircularProgressIndicator(),
                    ):
                    Container(),
                     error
                  ? Container(
//              padding: const EdgeInsets.only(left: 20, right: 20, top: 30.0, bottom: 15.0),
                      child: Center(
                        child: Text(
                          'Problème survenue , veillez réessayer.',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    )
                  : Container(),
                  ],
                ),
              ),
              Padding(padding: const EdgeInsets.symmetric(vertical: 16.0),
              child:Row(
                children: <Widget>[
                  existemail
                  ? Container(
//              padding: const EdgeInsets.only(left: 20, right: 20, top: 30.0, bottom: 15.0),
                      child: Center(
                      child: new RichText(
                          text: new TextSpan(
                        text: 'Désole ce numéro  : ',
                        style: TextStyle(color: Colors.red),
                        children: <TextSpan>[
                          new TextSpan(
                            text: this.widget.phone_n,
                            style: new TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          new TextSpan(
                              text:
                                  ' \na deja été utiliser veuillez utiliser un autre numéro',
                              style: TextStyle(color: Colors.red)),
                        ],
                      )),
                    ))
                  : Container(),
                ],
                
              ) ,
              
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _submittable() {
    return _agreedToTOS;
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      /*Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => CreatePassWordPage(
                  post: position,
                  phone_n: widget.phone_n,
                  email: _emailController.text,
                  nom: _nomController.text,
                  prenom: _prenomController.text,
                  ville: _villeController.text,
                  d_naissance: _naissanceController.text,
                )),
      );**/
      createUser();
      /*const SnackBar snackBar = SnackBar(content: Text('formulaire envoyer'));

      Scaffold.of(context).showSnackBar(snackBar);*/
    }
  }

  Future createUser() async {
      setState(() {
      loading = true;
      existemail = false;
      error = false;
    }); 
    var random;
String phone = this.widget.phone_n.substring(1);
    random=Random(1000);
//if(_emailController.text.isEmpty){
    emailto="FA"+
                  DateTime.now().month.toString() +
                  DateTime.now().day.toString() +
                  DateTime.now().hour.toString() +
                  DateTime.now().second.toString() +
                  "BIOL" +DateTime.now().millisecond.toString()+
                  DateTime.now().year.toString()+"@takesh.com";
//}else{
  //emailto=_emailController.text;
//}
//    on creer le User
    final response1 = await http.post(
      Uri.encodeFull("http://www.api.e-takesh.com:26525/api/Users"),
      body: {"username":this.widget.phone_n,"email": emailto, "password": "123456789"},
      headers: {HttpHeaders.acceptHeader: "application/json"},
    );

    if (response1.statusCode == 200) {
      
      // If the call to the server was successful, parse the JSON
      var convertDataToJson1 = json.decode(response1.body);
      print(convertDataToJson1["email"]);
      print(convertDataToJson1["id"]);
//    on connecte le User pour avoir le Token
      final response2 = await http.post(
        Uri.encodeFull("http://www.api.e-takesh.com:26525/api/Users/login"),
        body: {"username":this.widget.phone_n, "password": "123456789"},
        headers: {HttpHeaders.acceptHeader: "application/json"},
      );

      if (response2.statusCode == 200) {
//        on utilise le token pour creer le client en question

        var convertDataToJson2 = json.decode(response2.body);
        print("Token");
        print(convertDataToJson2["id"]);

        final response3 = await http.post(
          Uri.encodeFull(
              "http://www.api.e-takesh.com:26525/api/positions?access_token=" +
                  convertDataToJson2["id"]),
          body: {
            "latitude": lat.toString(),
            "longitude": lng.toString(),
            "libelle": "Ma position"
          },
          headers: {HttpHeaders.acceptHeader: "application/json"},
        );
        if (response3.statusCode == 200) {
          var convertDataToJson3 = json.decode(response3.body);
          final response4 = await http.post(
            Uri.encodeFull(
                "http://www.api.e-takesh.com:26525/api/clients?access_token=" +
                    convertDataToJson2["id"]),
            body: {
              "UserId": convertDataToJson1["id"].toString(),
              "email": emailto,
              "password": "123456789",
              "nom": _nomController.text,
              "prenom": _prenomController.text,
              "adresse": "RAS",
              "image":
                  "http://www.api.e-takesh.com:26525/api/containers/Clients/download/no_profile.png",
              "date_creation": DateTime.now().toString(),
              "code": "ET" +
                  DateTime.now().month.toString() +
                  DateTime.now().day.toString() +
                  DateTime.now().hour.toString() +
                  DateTime.now().second.toString() +
                  "CLT" +
                  DateTime.now().year.toString(),
              "telephone": this.widget.phone_n,
              "ville": _villeController.text,
              "positionId": convertDataToJson3["positionid"].toString(),
              "date_naissance": "1990-01-01",
              "status": "CREATED",
              "pays": "Cameroun"
            },
            headers: {HttpHeaders.acceptHeader: "application/json"},
          );

          if (response4.statusCode == 200) {
            api
                .getClient1(convertDataToJson1["id"],
                    convertDataToJson2["id"].toString())
                .then((Client1 n) {
              print("mon client");
              print(n.email);
              if (n != null) {
                DatabaseHelper().saveClient(n);

                Login2 login = new Login2();
                login.userid(n.user_id);
                login.tokenUser(convertDataToJson2["id"].toString());
                login.dateUser(n.date_creation);
                login.ttlUser(32122332552);
                print(login);
                DatabaseHelper().saveUser(login);

                print("client sauvé dans la base de donnée local");
              }
            });

             setState(() {
            loading = false;
            existemail = false;
            error = false;
          }); 
//          redirige a la page de connexion
            AppSharedPreferences().setAccountCreate(true);

            Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => LoginPage()),
            );
          } else {
             setState(() {
            loading = false;
            existemail = false;
            error = true;
          });
            // If that call was not successful, throw an error.
            throw Exception(
                'Erreur de creation du client' + response4.body.toString());
          }
        }
      } else {
        setState(() {
          loading = false;
          existemail = false;
          error = true;
        });
          Fluttertoast.showToast(
                          msg: 'erreur de creation de compte! essayer a nouveau svp..',
                          backgroundColor: MyColors.colorRouge,
                          textColor: Colors.white,
                          timeInSecForIos: 5);
        // If that call was not successful, throw an error.
        throw Exception(
            'Erreur de connexion du User' + response2.body.toString());
      }
    } else if (response1.statusCode == 422) {
       setState(() {
        loading = false;
        existemail = true;
        error = false;
      });
      Fluttertoast.showToast(
                          msg: 'Ce numéro existe déja  ..',
                          backgroundColor: MyColors.colorRouge,
                          textColor: Colors.white,
                          timeInSecForIos: 5);
    } else {
        setState(() {
        loading = false;
        existemail = false;
        error = true;
      });
      Fluttertoast.showToast(
                          msg: 'Problème survenue , veillez réessayer.',
                          backgroundColor: MyColors.colorRouge,
                          textColor: Colors.white,
                          timeInSecForIos: 5);
      // If that call was not successful, throw an error.
      throw Exception(
          'Erreur de creation du User' + response1.statusCode.toString());
    }
  }

  void _setAgreedToTOS(bool newValue) {
    setState(() {
      _agreedToTOS = newValue;
    });
  }
}
