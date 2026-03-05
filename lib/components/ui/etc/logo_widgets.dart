import 'package:flutter/material.dart';


class ReversibleBrightnessImage extends StatelessWidget{
  const ReversibleBrightnessImage({super.key,
    required this.imagePath,
    required this.size
  });
  final String imagePath;
  final Size size;
  @override
  Widget build(BuildContext context) {
    return
      ColorFiltered(
          colorFilter: Theme.of(context).brightness == Brightness.dark
              ? const ColorFilter.matrix(<double>[
            -1.0, 0.0, 0.0, 0.0, 255.0, //
            0.0, -1.0, 0.0, 0.0, 255.0, //
            0.0, 0.0, -1.0, 0.0, 255.0, //
            0.0, 0.0, 0.0, 1.0, 0.0, //
          ])
              : const ColorFilter.matrix(<double>[
            1.0, 0.0, 0.0, 0.0, 0.0, //
            0.0, 1.0, 0.0, 0.0, 0.0, //
            0.0, 0.0, 1.0, 0.0, 0.0, //
            0.0, 0.0, 0.0, 1.0, 0.0, //
          ]),
          child:
          // Image.asset("assets/images/netra_logo_trans_bg.png")),
          Image.asset(
              height: size.height,
              width: size.width,
              imagePath));

  }
}