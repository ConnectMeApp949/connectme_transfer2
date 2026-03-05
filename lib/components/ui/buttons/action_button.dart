import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:flutter/material.dart';


class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.onTap, required this.label});

  final VoidCallback onTap;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.sr, horizontal: 12.sr),
        child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      width: Gss.width * .004),
                  borderRadius: BorderRadius.circular(6.sr)),
              padding: EdgeInsets.symmetric(vertical: Gss.width * .02),
              child: Center(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge,
                  )),
            )));
  }
}