import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';


final ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: kPrimaryColor,
  fontFamily: 'Ubuntu',
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: kPrimaryColor,
  ),
  splashColor: kSecondaryColor.withOpacity(0.05),
  highlightColor: kSecondaryColor.withOpacity(0.10),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: kTertiaryColor.withOpacity(0.1),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: kTextColor,
  ),
);
