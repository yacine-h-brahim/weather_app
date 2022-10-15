import 'package:flutter/material.dart';

class AllThemes {
  static ThemeData dark = ThemeData(
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    backgroundColor: const Color.fromRGBO(32, 29, 29, 1),
    primaryColor: const Color.fromRGBO(79, 128, 250, 1),
  );
  static ThemeData light = ThemeData(
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
    primaryColor: const Color.fromRGBO(79, 128, 250, 1),
  );
  TextStyle get headline1w {
    return const TextStyle(
        fontWeight: FontWeight.w500, color: Colors.white, fontSize: 20);
  }

  TextStyle get headline1b {
    return const TextStyle(
        fontWeight: FontWeight.w500, color: Colors.black, fontSize: 20);
  }

  TextStyle get headline2b {
    return const TextStyle(
        fontWeight: FontWeight.w500, color: Colors.black, fontSize: 14);
  }

  TextStyle get headline2w {
    return const TextStyle(
        fontWeight: FontWeight.w500, color: Colors.white, fontSize: 14);
  }

  TextStyle get headline2White {
    return const TextStyle(
        fontWeight: FontWeight.w500, color: Colors.white, fontSize: 14);
  }

  TextStyle get subtitle1White20 {
    return const TextStyle(
        fontWeight: FontWeight.w600, color: Colors.white, fontSize: 20);
  }

  TextStyle get subtitle2White14 {
    return const TextStyle(
        fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14);
  }

  TextStyle get subtitle2black14 {
    return const TextStyle(
        fontWeight: FontWeight.w600, color: Colors.black, fontSize: 14);
  }

  TextStyle get bodyText1 {
    return const TextStyle(
        fontWeight: FontWeight.w400, color: Colors.white, fontSize: 20);
  }

  TextStyle get bodyText2 {
    return const TextStyle(
        fontWeight: FontWeight.w400, color: Colors.white, fontSize: 14);
  }

  TextStyle get bodyText3Brown {
    return const TextStyle(
        fontWeight: FontWeight.w400,
        color: Color.fromRGBO(73, 67, 67, 1),
        fontSize: 13);
  }

  TextStyle get bodyText3White {
    return const TextStyle(
        fontWeight: FontWeight.w400,
        color: Color.fromRGBO(238, 235, 235, 1),
        fontSize: 13);
  }

  TextStyle get bodyTextWhite {
    return const TextStyle(
        fontWeight: FontWeight.w400,
        color: Color.fromRGBO(238, 235, 235, 1),
        fontSize: 12);
  }

  TextStyle get bodyTextBrown {
    return const TextStyle(
        fontWeight: FontWeight.w400,
        color: Color.fromRGBO(73, 67, 67, 1),
        fontSize: 12);
  }
}
