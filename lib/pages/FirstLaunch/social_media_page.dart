import 'package:etakesh_client/pages/FirstLaunch/google_phone_number.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
//Google provider

// Facebook provide

class SocialMediaPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> mScaffoldState =
      new GlobalKey<ScaffoldState>();
  final GoogleSignIn googleSignIn = GoogleSignIn();
//  FacebookLogin facebookLogin = new FacebookLogin();
  GoogleSignInAccount googleAccount;
//  final GoogleSignIn googleSignIn = new GoogleSignIn();
  FirebaseUser fUser;

//  Future<Null> initUser() async {
//    googleAccount = await getSignedInAccount(googleSignIn);
//    if (googleAccount == null) {
//    } else {
//      await signInWithGoogle();
//    }
//  }

  Future<Null> signInWithGoogle(BuildContext context) async {
    GoogleSignInAccount user = googleSignIn.currentUser;

    if (user == null) {
      await googleSignIn.signIn().then((account) {
        user = account;
        print('create user ' + account.toString());
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => EnterGooglePhoneNumberPage(
                    user: account,
                  )),
        );
      }, onError: (error) {
        print("Nous ne parvenons pas a vous enrgistrer avec cette Email" +
            error.toString());
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

//  Future<Null> signInWithGoogle2() async {
//    if (googleAccount == null) {
//      // Start the sign-in process:
//      googleAccount = await googleSignIn.signIn();
//    }
//    FirebaseUser firebaseUser = await signIntoFirebase(googleAccount);
//    user = firebaseUser;
//    print('Google SignIn' + user.toString());
//  }

//  Future<GoogleSignInAccount> getSignedInAccount(
//      GoogleSignIn googleSignIn) async {
//    GoogleSignInAccount account = googleSignIn.currentUser;
//    if (account == null) {
//      account = await googleSignIn.signInSilently();
//    }
//    return account;
//  }

//  Future<FirebaseUser> signIntoFirebase(
//      GoogleSignInAccount googleSignInAccount) async {
//    FirebaseAuth _auth = FirebaseAuth.instance;
//    GoogleSignInAuthentication googleAuth =
//        await googleSignInAccount.authentication;
//    print('Google token' + googleAuth.accessToken);
//    return await _auth.signInWithGoogle(
//      accessToken: googleAuth.accessToken,
//      idToken: googleAuth.idToken,
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: mScaffoldState,
      appBar: new AppBar(
        title: new Text(
          'Nouveau chez Takesh ?',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 50.0, top: 40),
              child: new Text(
                "Choisissez un compte",
                style: TextStyle(fontSize: 24),
              ),
            ),
            new ListTile(
              title: new Text(
                'Google',
                style: TextStyle(fontSize: 18.0),
              ),
              leading: Image.asset('assets/images/google.png',
                  height: 20.0, width: 60.0),
              onTap: () {
                signInWithGoogle(context);
              },
            ),
            new ListTile(
              title: new Text(
                'Facebook',
                style: TextStyle(fontSize: 18.0),
              ),
              leading: Image.asset('assets/images/facebook.png',
                  height: 20.0, width: 60.0),
              onTap: () {
                showSnackBar();
//                facebookLogin.loginWithPublishPermissions(
//                    ['email', 'public_profile']).then((result) {
//                  print(" UserFacebook " + result.toString());
//                  switch (result.status) {
//                    case FacebookLoginStatus.loggedIn:
//                      FirebaseAuth.instance
//                          .signInWithFacebook(
//                              accessToken: result.accessToken.token)
//                          .then((signedInUser) {
//                        print(" UserFirebase " + signedInUser.toString());
//                      }).catchError((err2) {
//                        print(" Probleme1 Firebase" + err2.toString());
//                      });
//                      break;
//                    case FacebookLoginStatus.cancelledByUser:
//                      print("Annuler par le User");
//                      break;
//                    case FacebookLoginStatus.error:
//                      print(" Probleme2 " + result.errorMessage);
//                      break;
//                  }
//                }).catchError((err) {
//                  print(" Probleme1 " + err.toString());
//                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void showSnackBar() {
    var snackBar = SnackBar(
      content: Text("Module en developpement"),
      backgroundColor: Color(0xFF0C60A8),
      action: SnackBarAction(label: "OK", onPressed: () {}),
    );
    mScaffoldState.currentState.showSnackBar(snackBar);
  }
}
