

import 'package:flutter/material.dart';

showWelcomeNewVendorDialog(BuildContext context) async {
  await showDialog(
      barrierDismissible: false,
      context: context, builder: (context) {
    return AlertDialog(
      title: Row(children:[Flexible(child:Center(child: Text('✨ Welcome to ConnectMe ✨')))]),
      content:
      // Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children:[
      SingleChildScrollView(
        child: ListBody(
            children: <Widget>[
            Center(child: Text('Thanks for joining the platform! Ready to start using ConnectMe as a Vendor? We\'re here to help you grow your business! ',
              style: Theme.of(context).textTheme.titleMedium,
            ))])),
      actions: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child:  Text('Let\'s go!',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )]),
      ],
    );
  });
}