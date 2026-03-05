import 'package:flutter/material.dart';
import 'package:connectme_app/util/screen_util.dart';

// tone down error widget so it doesn't give us ptsd
class CustomError extends StatelessWidget {
  const CustomError({super.key, required this.errorDetails});

  final FlutterErrorDetails errorDetails;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.blueGrey[100],
            child: ListView(children: [
              Center(
                  child: Text(errorDetails.toString(),
                      style:
                      const TextStyle(color: Colors.black, fontSize: 15)))
            ])));
  }
}

class PoppableProductionError extends StatelessWidget {
  const PoppableProductionError({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                int tryPopLimit = 3;
                int hasPopped = 0;
                while (hasPopped < tryPopLimit) {
                  if (Navigator.of(context).canPop()) {
                    Navigator.pop(context);
                  }
                  hasPopped += 1;
                }
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
        ),
        body: ListView(children: [
          Container(
              color: Colors.blueGrey[700],
              width: context.sw,
              height: context.sh,
              child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Something went wrong, please try again later.",
                      style: TextStyle(color: Colors.white),
                    )
                  ]))
        ]));
  }
}
