import 'dart:convert';
import 'dart:io';

import 'package:etakesh_client/Database/DatabaseHelper.dart';
import 'package:etakesh_client/Models/clients.dart';
import 'package:etakesh_client/Utils/AppSharedPreferences.dart';
import 'package:etakesh_client/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class EnterGooglePhoneCodePage extends StatefulWidget {
  final String phone_n;
  final String ververId;
  final GoogleSignInAccount user;
  EnterGooglePhoneCodePage({Key key, this.phone_n, this.ververId, this.user})
      : super(key: key);

  @override
  _EnterGooglePhoneCodePageState createState() =>
      _EnterGooglePhoneCodePageState();
}

class _EnterGooglePhoneCodePageState extends State<EnterGooglePhoneCodePage> {
  Color backColor = Colors.white;
  var _codeController = new TextEditingController();
  final String pwd = "123456789";
  bool error;
  bool loading;
  bool existemail;
  double lat = 4.0923523;
  double lng = 9.7487852;
  List<String> nomPrenom = [] ;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  @override
  void initState() {
    super.initState();
    existemail = false;
    loading = false;
    error = false;
    if(this.widget.user!=null)
    nomPrenom = this.widget.user.displayName.split(' ');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xFF0C60A8),
            foregroundColor: Colors.white,
            child: Icon(Icons.arrow_forward),
            tooltip: "Donnees personnelles",
            onPressed: () {
              FirebaseAuth.instance.currentUser().then((user) {
                if (user != null) {
                  GoogleSignInAccount user1 = googleSignIn.currentUser;
                  print('FirebaseUser ' + user.toString());
                  print('GoogleUser2 ' + user1.toString());
                  print('GoogleUser1 ' + this.widget.user.toString());
                  print('PhoneNumber ' + this.widget.phone_n);
                  createUser();
//                  Navigator.push(
//                    context,
//                    new MaterialPageRoute(
//                        builder: (context) =>
//                            EnterEmailPage(phone_n: widget.phone_n)),
//                  );
                } else {
                  signIn(context);
                }
              });
            }),
        appBar: new AppBar(
          title: new Text(
            'Code de validation',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Container(
          decoration: BoxDecoration(color: backColor),
          child: Column(
            children: [
              new Expanded(
                flex: 1,
                child: new Container(
                  width: double
                      .infinity, // this will give you flexible width not fixed width
                  color: backColor, // variable
                  child: new Column(
                    children: <Widget>[
                      new Expanded(
                        flex: 1,
                        child: new Container(
                            alignment: Alignment.center,
//                        padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
                            child: Text(
                              "Saisissez le code a 6 chiffres recu au numero " +
                                  widget.phone_n,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.w300),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              loading
                  ? Container(
                      height: 40.0,
                      width: 40.0,
//                    padding: const EdgeInsets.only(
//                        left: 20, right: 20, top: 30.0, bottom: 15.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container(),
              existemail
                  ? Container(
//              padding: const EdgeInsets.only(left: 20, right: 20, top: 30.0, bottom: 15.0),
                      child: Center(
                      child: new RichText(
                          text: new TextSpan(
                        text: 'Désolé ce numéro : ',
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
                                  ' \na déjà été utilisée, veuillez utiliser un autre numéro',
                              style: TextStyle(color: Colors.red)),
                        ],
                      )),
                    ))
                  : Container(),
              new Expanded(
                flex: 1,
                child: new Container(
                  width: double
                      .infinity, // this will give you flexible width not fixed width
                  color: Colors.white,
                  child: new Column(
                    children: <Widget>[
                      new Expanded(
                        flex: 1,
                        child: new Container(
                            padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: SizedBox(
                                      height: 50.0,
                                      child: Container(
                                          padding: EdgeInsets.only(
                                              left: 10.0, right: 10.0),
//                                softWrap: true,
                                          child: TextField(
                                              controller: _codeController,
                                              autofocus: true,
                                              maxLength: 6,
                                              keyboardType: TextInputType.phone,
                                              inputFormatters: [
                                                WhitelistingTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              style: TextStyle(
                                                  fontSize: 23.0,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black87),
                                              decoration: InputDecoration(
                                                  hintText: '- - - - - -',
                                                  hintStyle: TextStyle(
                                                      fontSize: 30.0,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color:
                                                          Colors.black87))))),
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                  //variable
                ),
              ),
              error
                  ? Container(
//              padding: const EdgeInsets.only(left: 20, right: 20, top: 30.0, bottom: 15.0),
                      child: Center(
                        child: Text(
                          'Code invalide , veillez reessayer.',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ));
  }

  signIn(BuildContext context) async {
    setState(() {
      loading = true;
      error = false;
    });
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: this.widget.ververId,
      smsCode: _codeController.text,
    );
    final FirebaseUser user =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    assert(user.uid == currentUser.uid);
   
      if (user != null) {
        print('FirebaseUser ' + user.toString());

        ///        Start registration
        setState(() {
          loading = true;
          existemail = false;
          error = false;
        });
//    on creer le User
        createUser();
      } else {
        print('Bad code' + user.toString());
        setState(() {
          loading = false;
          error = true;
        });
      }
   
//    FirebaseAuth.instance
//        .signInWithPhoneNumber(
//            verificationId: widget.ververId, smsCode: _codeController.text)
//        .then((user) {
//      if (user != null) {
//        ///        Start registration
//        setState(() {
//          loading = true;
//          existemail = false;
//          error = false;
//        });
////    on creer le User
//        createUser();
//      } else {
//        print('Bad code' + user.toString());
//        setState(() {
//          loading = false;
//          error = true;
//        });
//      }
//    }).catchError((e) {
//      setState(() {
//        loading = false;
//        error = true;
//      });
//      print('Bad code' + e.toString());
//    });
  }

   createUser() async {
    setState(() {
      loading = true;
      existemail = false;
      error = false;
    });
//    on creer le User
    final response1 = await http.post(
      Uri.encodeFull("http://www.api.e-takesh.com:26525/api/Users"),
      body: {"username":this.widget.phone_n,"email": this.widget.user.email, "password": pwd},
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
        body: {"username":this.widget.phone_n, "password": pwd},
        headers: {HttpHeaders.acceptHeader: "application/json"},
      );

      if (response2.statusCode == 200) {
//        on utilise le token pour creer le client en question

        var convertDataToJson2 = json.decode(response2.body);
        print("Token");
        print(convertDataToJson2["id"]);
// create the position of the customer
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
          Uri.encodeFull("http://www.api.e-takesh.com:26525/api/clients?access_token=" +
              convertDataToJson2["id"]),
          body: {
            "UserId": convertDataToJson1["id"].toString(),
            "email": this.widget.user.email,
            "password": pwd,
            "nom": nomPrenom[0],
            "prenom": nomPrenom[1],
            "telephone": this.widget.phone_n,
            "adresse": "RAS",
            "date_creation": DateTime.now().toString(),
            "image": "http://www.api.e-takesh.com:26525/api/containers/Clients/download/no_profile.png",
            "code": "ET" +
                DateTime.now().month.toString() +
                DateTime.now().day.toString() +
                DateTime.now().hour.toString() +
                DateTime.now().second.toString() +
                "CLT" +
                DateTime.now().year.toString(),
            "positionId": convertDataToJson3["positionid"].toString(),
            "ville": "Douala",
            "date_naissance": "1990-01-01",
            "status": "CREATED",
            "pays": "Cameroun"
          },
          headers: {HttpHeaders.acceptHeader: "application/json"},
        );
        if (response4.statusCode == 200) {
          //connecte le user 10 ans (token)
          final response5 = await http.post(
            Uri.encodeFull("http://www.api.e-takesh.com:26525/api/Users/login"),
            body: {
              "email": this.widget.user.email,
              "password": pwd,
              "ttl": "315360000"
            },
            headers: {HttpHeaders.acceptHeader: "application/json"},
          );
          if (response5.statusCode == 200) {
            Login2 login;
            login = Login2.fromJson(json.decode(response5.body));

//                var convertDataToJson1 = json.decode(response1.body);
            AppSharedPreferences().setAccountCreate(true);
            AppSharedPreferences().setAppLoggedIn(true);
            
            setState(() {
              loading = false;
            });
            print("User" + login.token);
            AppSharedPreferences().setUserToken(login.token);
            Navigator.of(context).pushAndRemoveUntil(
                new MaterialPageRoute(builder: (context) => HomePage()),
                ModalRoute.withName(Navigator.defaultRouteName));
            new DatabaseHelper().saveUser(login);
          }
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
    } else {
      setState(() {
        loading = false;
        existemail = false;
        error = true;
      });
      // If that call was not successful, throw an error.
      throw Exception(
          'Erreur de creation du User' + response1.statusCode.toString());
    }
  }
}
