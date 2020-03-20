import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:etakesh_client/DAO/Presenters/LoginPresenter.dart';
import 'package:etakesh_client/Database/DatabaseHelper.dart';
import 'package:etakesh_client/Models/clients.dart';
import 'package:etakesh_client/Utils/AppSharedPreferences.dart';
import 'package:etakesh_client/pages/Mycolor.dart';
import 'package:etakesh_client/pages/fluttertoast.dart';
import 'package:etakesh_client/pages/login_page.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;

class ResetPasswordPage extends StatefulWidget {
  final String token;
  ResetPasswordPage({
    Key key,
    this.token,
  }) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage>
    implements LoginContract {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool loading = false;
  var _passwordController = TextEditingController();
  var _passwordController1 = TextEditingController();
  FocusNode passawordNode;
  FocusNode passawordNode1;
  LoginPresenter _presenter;

  LoginState() {
    _presenter = new LoginPresenter(this);
  }

  Login2 login;
  String token1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    passawordNode1 = FocusNode();
    passawordNode = FocusNode();
    loading = false;
    DatabaseHelper().getUser().then((Login2 l) {
      if (l != null) {
        login = l;
        print("voici le token " + login.token.toString());
      }
    });
    AppSharedPreferences().getToken().then((tok) {
      if (tok != null) {
        token1 = tok;
        print("on a la token");
      } else {
        print("pas de token");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          ' CHANGER LE MOT DE PASSE',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 3.0,
        backgroundColor: Color(0xFF0C60A8),
        iconTheme: IconThemeData(color: Colors.white, size: 25),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF0C60A8),
          foregroundColor: Color(0xFFDEA807),
          child: Icon(Icons.arrow_forward),
          tooltip: "Adresse email",
          onPressed: _submit),
      backgroundColor: Colors.white,
      body: LoginUi(),
    );
  }

  BoxDecoration decoration = BoxDecoration(
      border: Border(bottom: BorderSide(color: Color(0xEEFFFFFF), width: 1.0)));

  TextStyle CustomTextStyle() {
    return TextStyle(color: Colors.black, fontSize: 15.0);
  }

  InputDecoration CustomTextDecoration({String text, IconData icon}) {
    return InputDecoration(
      labelStyle: TextStyle(color: Colors.black87),
      labelText: text,
      prefixIcon: Icon(icon, color: Colors.black),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey[700])),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      errorBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
    );
  }

  Widget CustomSizeBox({double height}) {
    return SizedBox(
      height: height,
    );
  }

  Widget LoginUi() {
    return Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: new Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                color: Color(0xFF0C60A8),
                child: Column(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Image.asset("assets/images/key.png",
                            fit: BoxFit.contain))
                  ],
                )),
          ),
          Expanded(
            flex: 0,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: new Column(
                children: <Widget>[
                  new Expanded(
                    flex: 0,
                    child: new Container(
                      padding: EdgeInsets.only(
                          left: 20.0, bottom: 5.0, right: 20.0, top: 15.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Changer votre Mot de passe?",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          /*  Expanded(
          flex: 0,
          child: new Container(
             padding: EdgeInsets.only(left: 20.0, bottom: 10.0,right: 20.0,),
             margin: EdgeInsets.only(left: 10.0,right: 10.0),
         child: Text(
          "veillez saisir a nouveau le mot de passe ",
          style:TextStyle(color: Colors.black) 
          ),
          )
          
        ),*/
          Expanded(
              flex: 4,
              child: new Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: <Widget>[
                    Container(decoration: decoration),

                    TextFormField(
                      controller: _passwordController,
                      enabled: true,
                      enableInteractiveSelection: true,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      style: CustomTextStyle(),
                      focusNode: passawordNode1,
                      keyboardType: TextInputType.text,
                      validator: validatePassword,
                      decoration: CustomTextDecoration(
                          icon: Icons.lock, text: "Nouveau Mot de Passe"),
                    ),
                    TextFormField(
                      controller: _passwordController1,
                      enabled: true,
                      enableInteractiveSelection: true,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      style: CustomTextStyle(),
                      focusNode: passawordNode,
                      validator: validatePasswordMatching,
                      decoration: CustomTextDecoration(
                          icon: Icons.lock, text: "Confirmer le Mot de Passe"),
                    ),
                    //CustomSizeBox(height: 10.0),
                    loading
                        ? Container(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 40.0, bottom: 15.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Container(),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _loadingIndicator() {
    return Positioned(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[700],
        child: Center(
          child: SizedBox(
            height: 50.0,
            width: 50.0,
            child: CircularProgressIndicator(
              strokeWidth: 0.7,
              backgroundColor: Color(0xFF0C60A8),
            ),
          ),
        ),
      ),
    );
  }

  void update() {
    setState(() {
      loading = true;
    });
    print("alons y");
    Future.delayed(Duration(seconds: 2), () async {
      print("1");
      print(token1);
      print(widget.token);
      print(_passwordController.text);
      Map<String, dynamic> data = {
        'newPassword': _passwordController.text.toString(),
      };
    // String tok=widget.token;
    String url= "http://www.api.e-takesh.com:26525/api/Users/reset-password?access_token=" +
                widget.token;
      final response1 = await http.post(
           url,
        body: data,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        encoding: Encoding.getByName("utf-8"),
      );
      print("2");
      print(response1.statusCode);
      if (response1.statusCode == 204) {
        print("3");

        Fluttertoast.showToast(
            msg: 'Vous venez de changer votre mot de passe',
            backgroundColor: MyColors.colorBlue,
            textColor: Colors.white,
            timeInSecForIos: 8);
             Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => LoginPage()),
          );
      } else {
        print("4");
        setState(() {
          loading = false;
        });
           Fluttertoast.showToast(
            msg: 'Cette opération à echouer veillez essaiyer a nouveau.. ',
            backgroundColor: MyColors.colorRouge,
            textColor: Colors.white,
            timeInSecForIos: 10);
        print("echouer");
       
      }
    });
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      Timer(Duration(milliseconds: 800), () {
        update();
      });
      FocusScope.of(context).requestFocus(new FocusNode());

      print("nous voulons executer la requette");
    }
  }

  String validatePassword(String value) {
    if (value.length == 0) {
      return "Mot de passe obligatoire";
    } else if (value.length < 6) {
      return "Le Mot de passe doit comporter au moins 6 caractères";
    } else {
      if (value.length > 8)
        return "Le Mot de passe doit être comprise entre 6 et 8 caractères";
    }
    return null;
  }

  String validatePasswordMatching(String value) {
    if (value.length == 0) {
      return "Confirmation vide";
    } else if (value != _passwordController.text) {
      return 'Ne correspond pas avec le mot de passe entré précdement';
    }
    return null;
  }

  @override
  void onLoginError() {
    setState(() {
      loading = false;
    });
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(
        "Indentifiants non valides",
        style: TextStyle(color: Colors.red),
      ),
    ));
  }

  @override
  void onConnectionError() {
    setState(() {
      loading = false;
    });
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(
        "Verifiez votre connexion internet",
        style: TextStyle(color: Colors.orange),
      ),
    ));
  }

  @override
  void onLoginSuccess(Client1 datas) async {
    setState(() => loading = false);
    if (datas != null) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(
          "Connexion reussite",
          style: TextStyle(color: Colors.green),
        ),
      ));
      print("sucess login " + datas.toString());
    }
  }
}
