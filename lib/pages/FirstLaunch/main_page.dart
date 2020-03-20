import 'package:etakesh_client/pages/FirstLaunch/google_phone_number.dart';
import 'package:etakesh_client/pages/FirstLaunch/phone_number.dart';
import 'package:etakesh_client/pages/FirstLaunch/social_media_page.dart';
import 'package:etakesh_client/pages/Mycolor.dart';
import 'package:etakesh_client/pages/fluttertoast.dart';
import 'package:etakesh_client/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainLaunchPage extends StatelessWidget {
  final backColor = Color(0xFF11577C);
  final GoogleSignIn googleSignIn = GoogleSignIn();
  //  FacebookLogin facebookLogin = new FacebookLogin();
  GoogleSignInAccount googleAccount;
//  final GoogleSignIn googleSignIn = new GoogleSignIn();
  FirebaseUser fUser;
  Future<Null> signInWithGoogle(BuildContext context) async {
    
    GoogleSignInAccount user = googleSignIn.currentUser;

    if (user == null) {
      await googleSignIn.signIn().then((account) {
        user = account;
        print(user);
        if(user!=null){

        print('create user ' + account.toString());
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => EnterGooglePhoneNumberPage(
                    user: user,
                  )),
        );
        }
      }, onError: (error) {
        print("Nous ne parvenons pas a vous enrgistrer avec cette Email" +
            error.toString());
              Fluttertoast.showToast(
                          msg: 'Nous ne parvenons pas a vous enrgistrer avec cette Email',
                          backgroundColor: MyColors.colorRouge,
                          textColor: Colors.white,
                          timeInSecForIos: 5);
      });
    }
//    FirebaseUser firebaseUser = await signIntoFirebase(user);
//    fUser = firebaseUser;
//    print('Fuser' + fUser.toString());
//    if (user != null) {
//      googleAccount = user;
//      print('exist user ' + googleAccount.toString());
//      return null;
//    }

    return null;
  }

/*
  Future<FirebaseUser> _startFacebookLogin()async{

    var facebookLogin= new FacebookLogin();
     await facebookLogin.logInWithReadPermissions(['email','public_profile']).then((result) {

    switch(result.status){
      case FacebookLoginStatus.loggedIn:
      //FirebaseAuth.instance.
      break;
      case FacebookLoginStatus.cancelledByUser:
      print("Facebook sign in cancelled by user");
      break;
      case FacebookLoginStatus.error:
      print("facebook sign in failed");
      break;
    }
  
     });
    
  }
*/
  Widget LoginButton(BuildContext context) {
    return new SizedBox(
      height: 45.0,
      width: double.infinity,
      child: new RaisedButton(
        color: backColor,
        child: Text(
          "CONNECTEZ-VOUS",
          style: TextStyle(color: Colors.white,),
        ),
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
      ),
    );
  }

  Widget LoginGoogle(BuildContext context) {
    return new SizedBox(
      height: 45.0,
      width: double.infinity,
      child: new RaisedButton(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
         
            SizedBox(
              width: 2.0,
            ),
            Container(
              child: Text(
                "CONNECTEZ-VOUS VIA GOOGLE",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        onPressed: () {
          signInWithGoogle(context);
        },
      ),
    );
  }

  Widget Inscription(BuildContext context) {
    return new SizedBox(
      height: 45.0,
      width: double.infinity,
      child: new RaisedButton(
        color: backColor,
        child: Text(
          "INSCRIVEZ-VOUS",
          style: TextStyle(color: Colors.white,),
        ),
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => EnterPhoneNumberPage()),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double heigt = MediaQuery.of(context).size.height;
    double large = MediaQuery.of(context).size.width;
    return new Scaffold(
        body: Container(
      decoration: BoxDecoration(
        color: backColor,
      ),
      child: OverflowBox(
        maxHeight: MediaQuery.of(context).size.height,
        maxWidth: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            new Expanded(
              flex: 2,
              child: new Container(
                width: double
                    .infinity, // this will give you flexible width not fixed width
                height: heigt * 0.5,
                color: backColor, // variable
                child: new Column(
                  children: <Widget>[
                    new Expanded(
                      flex: 1,
                      child: new Container(
                        alignment: Alignment.center,
//                        padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
                        child: Image.asset('assets/images/Takesh_2.png',
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            new Expanded(
              flex: 2,
              child: new Container(
                width: double
                    .infinity, // this will give you flexible width not fixed width
                color: Colors.white,
                child: new Column(
                  children: <Widget>[
                    /* new Expanded(
                    flex: 0,
                    child: new Container(
                      padding: EdgeInsets.only(left: 20.0, bottom: 15.0,right: 20.0,top: 15.0),
                        alignment: Alignment.center,
                       
                       child: Text("Espace Connexion et Inscription",
                    style: TextStyle(fontSize: 20),),
                       ),
                  ),
                  */
                    new Expanded(
                      flex: 0,
                      child: new Container(
                        width: large * 0.85,
                        height: 45,
                        padding: EdgeInsets.only(
                            left: 10.0, bottom: 0.0, right: 10.0),
                        margin: EdgeInsets.only(
                            bottom: 10.0, left: 20.0, right: 20.0, top: 15.0),
                        child: LoginButton(context),
                      ),
                    ),
                    new Expanded(
                      flex: 0,
                      child: Container(
                        child: Text(
                          "OU ",
                          style: TextStyle(color: Colors.black),
                        ),
                        margin: EdgeInsets.only(bottom: 10.0),
                      ),
                    ),
                    // Divider(),

                    new Expanded(
                      flex: 0,
                      child: new Container(
                        width: large * 0.85,
                        height: 45,
                        padding: EdgeInsets.only(
                            left: 10.0, bottom: 0.0, right: 10.0),
                        margin: EdgeInsets.only(bottom: 20.0),
                        child: LoginGoogle(context),
                      ),
                    ),
                    
                    Divider(),
                    new Expanded(
                      flex: 0,
                      child: new Container(
                        padding: EdgeInsets.only(
                            left: 20.0, bottom: 5.0, right: 20.0, top: 15.0),
                        alignment: Alignment.center,
                        child: Text(
                          "NOUVEAU CHEZ TAKESH?",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color:Colors.black),
                        ),
                      ),
                    ),
                    new Expanded(
                      flex: 0,
                      child: Container(
                        width: large * 0.85,
                        height: 45,
                        // margin: EdgeInsets.only(top: 40.0),
                        padding: EdgeInsets.only(
                            left: 10.0, bottom: 0.0, right: 10.0),
                        margin: EdgeInsets.only(bottom: 20.0),
                        child: Inscription(context),
                      ),
                    ),
                  ],
                ),
                //variable
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
