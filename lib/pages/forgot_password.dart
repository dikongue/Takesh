import 'package:etakesh_client/DAO/Presenters/LoginPresenter.dart';
import 'package:etakesh_client/DAO/Rest_dt.dart';
import 'package:etakesh_client/Database/DatabaseHelper.dart';
import 'package:etakesh_client/Models/clients.dart';
import 'package:etakesh_client/Utils/AppSharedPreferences.dart';
import 'package:etakesh_client/pages/reset_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  final backColor = Color(0xFF0C60A8);
  BoxDecoration decoration = BoxDecoration(
      border: Border(bottom: BorderSide(color: Color(0xEEFFFFFF), width: 1.0)));
  TextStyle CustomTextStyle() {
    return TextStyle(color: Colors.white30, fontSize: 15.0);
  }

  Widget CustomSizeBox({double height}) {
    return SizedBox(
      height: height,
    );
  }

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    implements LoginContract {
  LoginPresenter _presenter;
  _ForgotPasswordPageState() {
    _presenter = new LoginPresenter(this);
  }
  TextStyle style = TextStyle(fontFamily: 'Montserrat');
  var _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  RestDatasource api = new RestDatasource();
  TextStyle CustomTextStyle() {
    return TextStyle(
      color: Colors.black,
      fontSize: 23.0,
    );
  }

  FocusNode emailNode;
  bool _iSloading, _error, _emaiExist;
  DatabaseHelper data = new DatabaseHelper();
  String token;
 GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  BoxDecoration decoration = BoxDecoration(
      border: Border(bottom: BorderSide(color: Color(0xEEFFFFFF), width: 1.0)));

  InputDecoration CustomTextDecoration({String text, IconData icon}) {
    return InputDecoration(
      labelStyle: TextStyle(color: Colors.black87),
      labelText: text,
      hintText: 'Email',
      prefixIcon: Icon(icon, color: Colors.black),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey[700])),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      errorBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
    );
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    _iSloading = false;
    _error = false;
    emailNode = FocusNode();
    _autoValidate = false;
    _emaiExist = false;
       AppSharedPreferences().getToken().then((tok){
       if(tok!=null){
        token=tok;
        print("on a la token");
       }else{
         print("pas de token");
       }
        

    });
    //token="";
  }

  @override
  Widget build(BuildContext context) {
    
    final email = TextFormField(
      // autovalidate: _autoValidate,
      controller: _emailController,
      enabled: true,
      enableInteractiveSelection: true,
      focusNode: emailNode,
      style: CustomTextStyle(),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,

      decoration: CustomTextDecoration(
        icon: Icons.email,
      ),

      textCapitalization: TextCapitalization.none,
      onFieldSubmitted: (term) {
        emailNode.unfocus();
        //FocusScope.of(context).requestFocus(pass);
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Veillez saisir votre email';
        } else if (!new RegExp(
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(value)) {
          return "Email non valide";
        }
      },
    );

    return Scaffold(
      key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(
            ' MOT DE PASSE OUBLIER',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          elevation: 3.0,
          backgroundColor: Color(0xFF0C60A8),
          iconTheme: IconThemeData(color: Colors.white, size: 25),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xFF0C60A8),
            foregroundColor: Colors.white,
            child: Icon(Icons.arrow_forward),
            tooltip: "Adresse email",
            onPressed: _submit
            ),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: new Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.5,
                  color: Color(0xFF0C60A8),
                  child: new Column(
                    children: <Widget>[
                      new Expanded(
                        flex: 1,
                        child: Image.asset(
                          "assets/images/lock.png",
                          fit: BoxFit.contain,
                        ),
                      )
                    ],
                  ),
                ),
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
                              left: 20.0, bottom: 15.0, right: 20.0, top: 15.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Mot de passe oublier?",
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 0,
                  child: new Container(
                    padding: EdgeInsets.only(
                        left: 20.0, bottom: 15.0, right: 20.0, top: 15.0),
                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text(
                        "veillez saisir votre adresse email de connexion",
                        style: TextStyle(color: Colors.black)),
                  )),
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: email,
                ),
              ),
              _iSloading?
                Container(
                  //padding: EdgeInsets.only(top: 15.0),
                  margin: EdgeInsets.only(bottom: 20.0),
                  //width: 150.0,
                  //height: 40.0,
                  child: CircularProgressIndicator(),
                )
              
              :Container(),
            ],
          ),
        ));
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      FocusScope.of(context).requestFocus(new FocusNode());
      setState(() {
        _iSloading=true;
      });
      DatabaseHelper().getUser().then((Login2 l) {
      if (l != null) {
      
   if(l.token!=''){
     print("le tok "+l.token);
     api.getOneClient(_emailController.text, l.token).then((data){
        print("1kjbhjhvjhh");
        print(data);
       if(data!=null){
         setState(() {
        _iSloading=false;
      });

      print("voci mon token"+l.token);
            Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => ResetPasswordPage(
                                  token:l.token,
                                )),
                          );
           }else{
            _scaffoldKey.currentState.showSnackBar(new SnackBar(
                  content: new Text(
                    "adresse non valide",
                    style: TextStyle(color: Colors.deepOrange),
                  ),
                ));
                setState(() {
        _iSloading=false;
      });
           }

         });
        }else{
          print("object");
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
                  content: new Text(
                    "impossible de retrouver votre compte veillez utiliser votre téléphone de connection",
                    style: TextStyle(color: Colors.deepOrange),
                  ),
                ));
                setState(() {
        _iSloading=false;
      });
        }
      }
    });
    }
  }

  @override
  void onLoginError() {
    setState(() {
      _iSloading = false;
    });
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        "Indentifiants non valides",
        style: TextStyle(color: Colors.red),
      ),
    ));
  }

  @override
  void onConnectionError() {
    setState(() {
      _iSloading = false;
    });
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        "Verifiez votre connexion internet",
        style: TextStyle(color: Colors.orange),
      ),
    ));
  }

  @override
  void onLoginSuccess(Client1 datas) async {
    setState(() => _iSloading = false);
    if (datas != null) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(
          "Connexion reussite",
          style: TextStyle(color: Colors.green),
        ),
      ));
      print("sucess login " + datas.toString());
    }
  }
}
