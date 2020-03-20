import 'package:etakesh_client/pages/FirstLaunch/email_adresse.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EnterPhoneCodePage extends StatefulWidget {
  final String phone_n;
  final String ververId;
  EnterPhoneCodePage({Key key, this.phone_n, this.ververId}) : super(key: key);

  @override
  _EnterPhoneNumberPageState createState() => _EnterPhoneNumberPageState();
}

class _EnterPhoneNumberPageState extends State<EnterPhoneCodePage> {
  Color backColor = Colors.white;
  var _codeController = new TextEditingController();
  bool error;
  bool loading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = false;
    error = false;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xFF0C60A8),
            foregroundColor: Colors.white,
            child: Icon(Icons.arrow_forward),
            tooltip: "Données personnelles",
            onPressed: () {
              FirebaseAuth.instance.currentUser().then((user) {
                if (user != null) {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                            EnterEmailPage(phone_n: widget.phone_n)),
                  );
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
                              "Saisissez le code a 6 chiffres reçu au numéro " +
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
                      height: 25.0,
                      width: 20.0,
//                    padding: const EdgeInsets.only(
//                        left: 20, right: 20, top: 30.0, bottom: 15.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
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
                          'Code invalide , veillez réessayer.',
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
      verificationId: widget.ververId,
      smsCode: _codeController.text,
    );
    print("sms code entre par le client:"+_codeController.text);
    final FirebaseUser user =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        print('FirebaseUser ' + user.toString());
        setState(() {
          loading = false;
          error = false;
        });
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => EnterEmailPage(phone_n: widget.phone_n)),
        );
      } else {
        print('Bad code' + user.toString());
        setState(() {
          loading = false;
          error = true;
        });
      }
    });
  }
//    FirebaseAuth.instance
//        . signInWithPhoneNumber(
//            verificationId: widget.ververId, smsCode: _codeController.text)
//        .then((user) {
//      if (user != null) {
//        print('FirebaseUser ' + user.toString());
//        setState(() {
//          loading = false;
//          error = false;
//        });
//        Navigator.push(
//          context,
//          new MaterialPageRoute(
//              builder: (context) => EnterEmailPage(phone_n: widget.phone_n)),
//        );
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
//      print('Bad code' + e);
//    });
}
