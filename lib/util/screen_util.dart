import 'package:connectme_app/config/globals.dart';
import 'package:flutter/material.dart';


extension BuildContextExtension on BuildContext {
  double get sw => MediaQuery.of(this).size.width;
  double get sh => MediaQuery.of(this).size.height;
  Orientation get sOrient => MediaQuery.of(this).orientation;
}



/// I.E. Pixel 8 Dims ~ Size(411.4, 890.3)


extension ScreenSizeExtension on num {
  static double baseScreenWidth = 350;
  static double baseScreenHeight = 800;

  double get sr {
    // standard screen size to adapt by

    // make the screen height difference more important than width so tablet doesn't
    // look overly enlarged using this adaptive screen size
    double heightRatioBoost = 1.3;
    return this *
        (((Gss.width / baseScreenWidth) * (1 / heightRatioBoost) ) +
            ((heightRatioBoost) * (Gss.height / baseScreenHeight)) )
        / 2;
  }

  double get sw {
    return this * Gss.width;
  }

  double get sh {
    return this * Gss.height;
  }

  double get w {
    return this * (Gss.width / baseScreenWidth);
  }

  double get h {
    return this * (Gss.height / baseScreenHeight);
  }
}
