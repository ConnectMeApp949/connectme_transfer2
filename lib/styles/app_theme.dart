import 'package:flutter/material.dart';
import 'package:connectme_app/styles/transitions.dart';
import 'package:connectme_app/styles/colors.dart';



ThemeData primaryThemeData = ThemeData.light().copyWith(
    platform: TargetPlatform.iOS,
    pageTransitionsTheme: iosTransitions(),
    //removeTransitions(),
    // colorScheme: ColorScheme.fromSeed(seedColor: appPrimarySwatch),
    // primarySwatch: appPrimarySwatch,
    primaryColor: appPrimarySwatch,
    primaryColorDark: appPrimaryDarkColorLight,
    canvasColor: appCanvasColorLight,
    chipTheme: ChipThemeData(backgroundColor: chipPrimaryLightBG),
    listTileTheme:
    ListTileThemeData(selectedTileColor: primaryAccentColor0Light),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor:
            WidgetStateProperty.all<Color>(chipPrimaryLightBG),
        foregroundColor:     WidgetStateProperty.all<Color>(Colors.blueGrey[900]!),
        ),

    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return appPrimarySwatch[800]!; // Active color
        }
        return Colors.grey; // Inactive color
      })
    ),
      // overlayColor:  WidgetStateProperty.all<Color>(Colors.yellow),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryAccentColor_0,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor:
      WidgetStateProperty.resolveWith((states) {
        if (!states.contains(WidgetState.selected)) {
          return Colors.transparent;
        }
        return appPrimarySwatch[700];
      }),),
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
              (states) {
            // if (states.contains(MaterialState.pressed)) {
            //   return Colors.blue; // Text color when pressed
            // }
            // if (states.contains(MaterialState.hovered)) {
            //   return Colors.blueAccent; // Text color when hovered
            // }
            // if (states.contains(MaterialState.focused)) {
            //   return Colors.red; // Text color when focused
            // }
            return appPrimarySwatch[800]!; // Default text color
          },
        ),
        overlayColor: WidgetStateProperty.all(primaryAccentColor_0.withValues(alpha:0.1)),
        // textStyle: WidgetStateProperty.all(
        //   TextStyle(
        //     fontSize: 16,
        //     fontWeight: FontWeight.w600,
        //     decoration: TextDecoration.underline, // underline if you want
        //   ),
        // ),
      ),
    ),
  inputDecorationTheme: InputDecorationTheme(
      // labelStyle: TextStyle(
      //   color: primaryAccentColor_0, // Default label color
      // ),
    floatingLabelStyle: TextStyle(color: appPrimarySwatch[700]),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: appPrimarySwatch[700]!, // Underline color when focused
        width: 2.0,
      ),
    ),
      // enabledBorder: UnderlineInputBorder(
      //   borderSide: BorderSide(
      //     color: primaryAccentColor_0, // Underline color when not focused
      //     width: 1.0,
      //   ),
      // ),
    ),
    // progressIndicatorTheme: ProgressIndicatorThemeData(
    //
    // ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: appPrimarySwatch[700], circularTrackColor: appPrimarySwatch[700]),
    appBarTheme: AppBarTheme(backgroundColor: appScaffoldBGLight,
    ),
    // / appBarTheme doesn't fucking work without setting explicitly still  -> "/// All [AppBarTheme] properties are `null` by default. When null, the [AppBar]
    // /// compute its own default values, typically based on the overall theme's
    // /// [ThemeData.colorScheme], [ThemeData.textTheme], and [ThemeData.iconTheme].

    scaffoldBackgroundColor: appScaffoldBGLight,
    brightness: Brightness.light);

/// default scaffoldBackgroundColor: Color(0xFF121212),
ThemeData darkThemeData = ThemeData.dark().copyWith(
  platform: TargetPlatform.iOS,
  pageTransitionsTheme: iosTransitions(),
  //removeTransitions(),
  // colorScheme: ColorScheme.fromSeed(seedColor: appPrimarySwatch),
  // primarySwatch: appPrimarySwatch,
  primaryColor: appPrimarySwatch,
  primaryColorDark: appPrimaryDarkColorDark,
  chipTheme: ChipThemeData(backgroundColor: chipPrimaryLightBG_2),
  listTileTheme: ListTileThemeData(selectedTileColor: primaryAccentColor_0),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor:
      WidgetStateProperty.all<Color>(chipPrimaryLightBG),
      foregroundColor:     WidgetStateProperty.all<Color>(Colors.blueGrey[900]!),
    ),

  ),
  radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return appPrimarySwatch[800]!; // Active color
        }
        return Colors.grey; // Inactive color
      })
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: primaryAccentColor_0,
    ),
  ),
  checkboxTheme: CheckboxThemeData(
      fillColor:
      WidgetStateProperty.resolveWith((states) {
        if (!states.contains(WidgetState.selected)) {
          return Colors.transparent;
        }
        return appPrimarySwatch[700];
      }),),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
          // if (states.contains(MaterialState.pressed)) {
          //   return Colors.blue; // Text color when pressed
          // }
          // if (states.contains(MaterialState.hovered)) {
          //   return Colors.blueAccent; // Text color when hovered
          // }
          // if (states.contains(MaterialState.focused)) {
          //   return Colors.red; // Text color when focused
          // }
          return appPrimarySwatch[700]!; // Default text color
        },
      ),
      overlayColor: WidgetStateProperty.all(primaryAccentColor_0.withValues(alpha:0.1)),
      // textStyle: WidgetStateProperty.all(
      //   TextStyle(
      //     fontSize: 16,
      //     fontWeight: FontWeight.w600,
      //     decoration: TextDecoration.underline, // underline if you want
      //   ),
      // ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    // labelStyle: TextStyle(
    //   color: primaryAccentColor_0, // Default label color
    // ),
    floatingLabelStyle: TextStyle(color: appPrimarySwatch[700]),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: appPrimarySwatch[700]!, // Underline color when focused
        width: 2.0,
      ),
    ),
    // enabledBorder: UnderlineInputBorder(
    //   borderSide: BorderSide(
    //     color: appPrimarySwatch[700]!, // Underline color when not focused
    //     width: 1.0,
    //   ),
    // ),
  ),

  progressIndicatorTheme: ProgressIndicatorThemeData(color: appPrimarySwatch[700], circularTrackColor: appPrimarySwatch[700]),
  appBarTheme: AppBarTheme(backgroundColor: Color(0xFF121212) ,
  ),
  brightness: Brightness.dark,
);


