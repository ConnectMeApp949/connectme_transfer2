import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoundedOutlineButton extends ConsumerWidget {
  const RoundedOutlineButton(
      {super.key,
        required this.onTap,
        required this.label,
        this.width,
        this.paddingVertical,
        this.fontSize,
        this.color
      });

  final VoidCallback onTap;
  final String label;
  final double? width;
  final double? paddingVertical;
  final double? fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double addRadius = 0;
    if (paddingVertical != null) {
      addRadius = 2 * paddingVertical!;
    }

    return InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color:color??
                  (
                  Theme.of(context).textTheme.bodyLarge!.color!
                  ),
               width: 1.sr),
              borderRadius: BorderRadius.circular(10.sr + addRadius)),
          padding: EdgeInsets.symmetric(
            vertical: paddingVertical ?? 4.sr,
          ),
          width: width ?? Gss.width * .7,
          child: Center(
              child: Text(label,
                  style: TextStyle(
                    fontSize: fontSize ?? 12.sr,
                    color: color??
                        (
                            Theme.of(context).textTheme.bodyLarge!.color!
                        ),
                  ))),
        ));
  }
}
