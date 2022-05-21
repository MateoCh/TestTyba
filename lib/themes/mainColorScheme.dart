import 'package:flutter/material.dart';

const Color darkTybaGreen = Color(0xFF007662);
const Color lightTybaGreen = Color(0xFF089978);
const Color lowOpacityDarkTybaGreen = Color(0x7E007662);
const Color lowOpacityLightTybaGreen = Color(0x7E089978);
const Color tybaRed = Color(0xFFFF6C6C);

const ColorScheme mainColorScheme = ColorScheme(
  primary: darkTybaGreen,
  primaryVariant: darkTybaGreen,
  secondary: lightTybaGreen,
  secondaryVariant: lightTybaGreen,
  surface: lightTybaGreen,
  background: Colors.white,
  error: tybaRed,
  onPrimary: tybaRed,
  onSecondary: tybaRed,
  onSurface: lowOpacityLightTybaGreen,
  onBackground: lowOpacityDarkTybaGreen,
  onError: tybaRed,
  brightness: Brightness.light,
);

const AppBarTheme mainAppBarTheme = AppBarTheme(
  backgroundColor: darkTybaGreen,
  iconTheme: IconThemeData(color: Colors.white),
);
