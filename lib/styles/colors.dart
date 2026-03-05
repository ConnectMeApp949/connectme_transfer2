import 'package:flutter/material.dart';
import 'dart:math' as math;


const MaterialColor appPrimarySwatch = MaterialColor(
  0xFF40C4FF, // Primary value (e.g., Colors.blueAccent[200])
  <int, Color>{
    50: Color(0xFFE1F5FE), // Lighter shade
    100: Color(0xFFBBDEFB),
    200: Color(0xFF90CAF9),
    300: Color(0xFF64B5F6),
    400: Color(0xFF42A5F5),
    500: Color(0xFF2196F3), // Base color
    600: Color(0xFF1E88E5),
    700: Color(0xFF1976D2),
    800: Color(0xFF1565C0),
    900: Color(0xFF0D47A1), // Darker shade
  },
);

const Color appPrimaryDarkColorDark = Color(0xFF20216b);
const Color appPrimaryDarkColorLight = Color(0xFF20216b);

const Color highlightBG0 = Color(0xFF2d1ce8);

Color chipPrimaryLightBG = appPrimarySwatch[200]!;
Color chipPrimaryLightBG_1 = appPrimarySwatch[300]!;
Color chipPrimaryLightBG_2 = appPrimarySwatch[400]!;

Color primaryAccentColor_0 = appPrimarySwatch[900]!;

Color primaryAccentColor0Light = Color(0xFF4379e6);

// Color primaryAccentColor0Dark = Color(0xFF3f45d4);

Color appCanvasColorLight = Colors.white;
Color appScaffoldBGLight = Colors.white;



randomColor() {
  return   Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withValues(alpha:1.0);
}