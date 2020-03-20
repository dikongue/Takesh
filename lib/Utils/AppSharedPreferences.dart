import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  ///
  /// Instantiation of the SharedPreferences library
  ///
  final String _IsFirstLaunch = "isFirstLaunch";
  final String _IsLoggedIn = "isLoggedIn";
  final String _IsUserCreateAccount = "isUserCreateAccount";
  final String _Token = "token";
  final String _IsOrder = "isOrder";
  final String _IsOrderCreated = "isOrderCreated";
  final String _IsOfficeSave = "isOfficeSave";
  final String _IsHomeSave = "isHomeSave";
  final String _IsProfileUpd = "isProfileUpd";
  final String  _IsState="isState";
  final String  _PossitionCmdPrecedent="positionCmdprecedent";
  final String  _DestinationCmdPrecedent="DestinationCmdprecedent";
  final String  _DateCmdPrecedent="DateCmdPrecedent";
  final double  _mylat=0.0;
  final double  _mylng=0.0;
  final String  _Bienvenu="isBv";
    final String  _Arriver="arriver";
  final String  _Accept="accept";

  /// ------------------------------------------------------------
  /// Method that determineted is prestataires is come
  /// ------------------------------------------------------------
  Future<bool> isArrive() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_Arriver) ?? true;
  }

  /// ----------------------------------------------------------
  /// Method that saves the the first connection to app status
  /// ----------------------------------------------------------
  Future<bool> setArriver(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(_Arriver, value);
  }

  /// ------------------------------------------------------------
  /// Method that determine if the app is launched for the first time
  /// ------------------------------------------------------------
  Future<bool> isAppFirstLaunch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_IsFirstLaunch) ?? true;
  }

  /// ----------------------------------------------------------
  /// Method that saves the the first connection to app status
  /// ----------------------------------------------------------
  Future<bool> setAppFirstLaunch(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(_IsFirstLaunch, value);
  }

  /// ------------------------------------------------------------
  /// Method that determine is the app if an already an account logged
  /// ------------------------------------------------------------
  Future<bool> isAppLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_IsLoggedIn) ?? false;
  }

  /// ----------------------------------------------------------
  /// Method that saves the app logged In status
  /// ----------------------------------------------------------
  Future<bool> setAppLoggedIn(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(_IsLoggedIn, value);
  }

  /// ------------------------------------------------------------
  /// Method to get the token of user
  /// ------------------------------------------------------------
  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_Token) ?? '';
  }

  /// ----------------------------------------------------------
  /// Method that saves the token of user when logged
  /// ----------------------------------------------------------
  Future<bool> setUserToken(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_Token, value);
  }

  /// ------------------------------------------------------------
  /// Method that determine if user have create account
  /// ------------------------------------------------------------
  Future<bool> isAccountCreate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_IsUserCreateAccount) ?? false;
  }

  /// ----------------------------------------------------------
  /// Method that saves the app account create
  /// ----------------------------------------------------------
  Future<bool> setAccountCreate(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(_IsUserCreateAccount, value);
  }

  /// ------------------------------------------------------------
  /// Method that determine if user have an order in pending
  /// ------------------------------------------------------------
  Future<bool> isOrder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_IsOrder) ?? false;
  }

  /// ----------------------------------------------------------
  /// Method that saves the accepted order of costumer
  /// ----------------------------------------------------------
  Future<bool> setOrderCreate(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(_IsOrder, value);
  }

  /// ------------------------------------------------------------
  /// Method that determine if user created an order
  /// ------------------------------------------------------------
  Future<bool> isOrderCreated() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_IsOrderCreated) ?? false;
  }

  /// ----------------------------------------------------------
  /// Method that saves the order of costumer
  /// ----------------------------------------------------------
  Future<bool> setOrderCreatedTrue(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(_IsOrderCreated, value);
  }

  /// ------------------------------------------------------------
  /// Method that determine if user saved is home adress
  /// ------------------------------------------------------------
  Future<bool> isHomeSave() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_IsHomeSave) ?? false;
  }

  /// ----------------------------------------------------------
  /// Method that saves user home adress
  /// ----------------------------------------------------------
  Future<bool> setHomeSave(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(_IsHomeSave, value);
  }

  /// ------------------------------------------------------------
  /// Method that determine if user saved is office adress
  /// ------------------------------------------------------------
  Future<bool> isOfficeSave() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_IsOfficeSave) ?? false;
  }

  /// ----------------------------------------------------------
  /// Method that saves user office adress
  /// ----------------------------------------------------------
  Future<bool> setOfficeSave(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(_IsOfficeSave, value);
  }

    /// ------------------------------------------------------------
  /// Method that determine if user saved is office adress
  /// ------------------------------------------------------------
  Future<bool> isProfileUpd() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_IsProfileUpd) ?? false;
  }

 /// ------------------------------------------------------------
  Future<bool> isBienvenu() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_Bienvenu) ?? true;
  }

 Future<bool> setBienvenue(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(_Bienvenu, value);
  }

  /// ----------------------------------------------------------
  /// Method that saves user office adress
  /// ----------------------------------------------------------
  Future<bool> setProfileUpd(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(_IsProfileUpd, value);
  }

////
  Future<bool> isState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_IsState) ?? true;
  }

  /// ----------------------------------------------------------
  /// Method that saves the the first connection to app status
  /// ----------------------------------------------------------
  Future<bool> setIsState(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(_IsState, value);
  }
///
  ///
  ///
  Future<bool> isPositionCmdPrecedent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_PossitionCmdPrecedent) ?? true;
  }

  /// ----------------------------------------------------------
  /// Method that saves the the first connection to app status
  /// ----------------------------------------------------------
  Future<bool> setPositionCmdPrecedent(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_PossitionCmdPrecedent, value);
  }
  Future<bool> isDestinationCmdPrecedent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_DestinationCmdPrecedent) ?? true;
  }

  /// ----------------------------------------------------------
  /// Method that saves the the first connection to app status
  /// ----------------------------------------------------------
  Future<bool> setDestinationCmdPrecedent(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_DestinationCmdPrecedent, value);
  }

  Future<bool> isDateCmdPrecedent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_DateCmdPrecedent) ?? true;
  }

  /// ----------------------------------------------------------
  /// Method that saves the the first connection to app status
  /// ----------------------------------------------------------
  Future<bool> setDateCmdprecedent(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_DateCmdPrecedent, value);
  }
  
  /*Future<double> isMylat() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getDouble(_mylat) ?? true;
  }

  /// ----------------------------------------------------------
  /// Method that saves the the first connection to app status
  /// ----------------------------------------------------------
  Future<double> setMylat(double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setDouble(_mylat, value);
  }
    
  Future<double> isMylng() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getDouble(_mylng) ?? true;
  }

  /// ----------------------------------------------------------
  /// Method that saves the the first connection to app status
  /// ----------------------------------------------------------
  Future<double> setMylng(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setDouble(_mylng, value);
  }*/
  
  /// ------------------------------------------------------------
  /// Method that determineted is prestataires is come
  /// ------------------------------------------------------------
  Future<bool> isAccept() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_Accept) ?? true;
  }

  /// ----------------------------------------------------------
  /// Method that saves the the first connection to app status
  /// ----------------------------------------------------------
  Future<bool> setAccept(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(_Accept, value);
  }

}
