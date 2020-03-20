import 'package:etakesh_client/Presentation/presentation.dart';
import 'package:etakesh_client/Utils/AppSharedPreferences.dart';
import 'package:etakesh_client/pages/FirstLaunch/main_page.dart';
import 'package:etakesh_client/pages/home_page.dart';
import 'package:etakesh_client/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';


import 'theme.dart';

//
void main() async {
	// always have portrait orientation 
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Takesh Client',
      theme: buildThemeData(),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
   //  _getCurrentposition();
    
    AppSharedPreferences().isAppFirstLaunch().then((bool1) {
      if (bool1 == true) {
        // on presente l'appli
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (BuildContext context) {
        // return Presentation();
       return MainLaunchPage();
        }));
      } else {
        AppSharedPreferences().isAccountCreate().then((bool2) {
          if (bool2 == false) {
            Navigator.pushReplacement(context,
                new MaterialPageRoute(builder: (BuildContext context) {
              return MainLaunchPage();
            }));
          } else {
            AppSharedPreferences().isAppLoggedIn().then((bool3) {
              if (bool3 == false) {
                Navigator.pushReplacement(context,
                    new MaterialPageRoute(builder: (BuildContext context) {
                  return LoginPage();
                }));
              } else {
                Navigator.pushReplacement(context,
                    new MaterialPageRoute(builder: (BuildContext context) {
                  return HomePage();
                }));
              }
            }, onError: (e) {});
          }
        }, onError: (e) {});
      }
    }, onError: (e) {
      AppSharedPreferences().setAppFirstLaunch(true);
    });
    super.initState();
  }
  /*
 _getCurrentposition() async{
 await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((pos){
  if(pos!=null){
    AppSharedPreferences().setMylat(pos.latitude.toString());
    AppSharedPreferences().setMylng(pos.longitude.toString());
    
  }
 });
 }*/
  @override
  Widget build(BuildContext context) {
//    return new AnimatedBuilder(builder: (context, _) {
    return Material(
      color: Colors.white,
    );
//    });
  }
}
