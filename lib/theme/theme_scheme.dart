// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class Themes {
  static final lightTheme = ThemeData(
      colorScheme: const ColorScheme.light(
          //background:  Color.fromARGB(255, 247, 0, 0),
          primary: Color.fromARGB(255, 250, 250, 250),
          
          onPrimary: Color.fromARGB(255, 90, 88, 88),
          ));
  static final darkTheme = ThemeData(
      colorScheme: const ColorScheme.dark(
       // primary: Color.fromARGB(255, 59, 59, 59),
       //background: Color.fromARGB(255, 255, 0, 0),
       surface : Color.fromARGB(255, 48, 48, 48)
      ));
    
}

class Pallet {
  static const blue = Color.fromARGB(255, 81, 57, 203);
  static const red = Colors.red;
  static const yellow = Colors.yellow;
  static const black = Colors.black;
  static const white = Colors.white;
}
