import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData buildThemeData() {
  return ThemeData(
//    brightness: Brightness.light,
//    primaryColor: Colors.white,
//    accentColor: Colors.white,
//    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Roboto',
    textSelectionHandleColor: Colors.black,
    textSelectionColor: Colors.black12,
    cursorColor: Colors.black,
    toggleableActiveColor: Colors.black,
    inputDecorationTheme: InputDecorationTheme(
      errorStyle: TextStyle(color: Colors.red),
      hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.black87),
      labelStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
  );
}

const SystemUiOverlayStyle lightSystemUiOverlayStyle = SystemUiOverlayStyle(
//  statusBarColor: Colors.white,
//  systemNavigationBarColor: Colors.white,
  systemNavigationBarDividerColor: Colors.black,
  systemNavigationBarIconBrightness: Brightness.dark,
);
