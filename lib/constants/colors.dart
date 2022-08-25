import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // this basically makes it so you can't instantiate this class

  static const Map<int, Color> grey = <int, Color>{
    800: Color(0xFF303030),
    900: Color(0xFF252525)
  };

  static const black = Color(0xFF181818);
  static const white = Color(0xFFFFFFFF);
  static const blue = Color(0xFF0191F7);
  static const maroon = Color(0xFFBF2043);
  static const green = Color(0xFF56A052);
  static const red = Color(0xFFC34848);
  static const orange = Color(0xFFFF7D2E);

  static const primaryText = Color.fromRGBO(255, 255, 255, .9);
  static const primaryBgr = AppColors.black;
  static const highlight = AppColors.orange;
}
