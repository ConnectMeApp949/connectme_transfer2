import 'package:flutter/material.dart';

class _NoTransitionsBuilder extends PageTransitionsBuilder {
  const _NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
      PageRoute<T>? route,
      BuildContext? context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget? child,
      ) {
    return child!;
  }
}

PageTransitionsTheme removeTransitions() {
  return PageTransitionsTheme(
    builders: {
      for (final platform in TargetPlatform.values)
        platform: const _NoTransitionsBuilder(),
    },
  );
}

PageTransitionsTheme iosTransitions() {
  return PageTransitionsTheme(
    builders: {
      for (final platform in TargetPlatform.values)
        platform: const CupertinoPageTransitionsBuilder()
    },
  );
}