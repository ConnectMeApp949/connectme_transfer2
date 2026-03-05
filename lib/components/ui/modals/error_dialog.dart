import 'package:connectme_app/components/ui/buttons/action_button.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:flutter/material.dart';

showErrorDialog(BuildContext context, String errorMessage, {tag}) {
  lg.d("[showErrorDialog] called tag: ${tag.toString()}");
  showDialog(
      context: context,
      builder: (context) {
        return Center(
            child: ListView(shrinkWrap: true, children: [
              AlertDialog(
                content: Text(errorMessage,
                // style: Theme.of(context).textTheme.bodyLarge,
                ),
                actions: [
                  ActionButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      label: "Ok"),
                ],
              )
            ]));
      });
}

