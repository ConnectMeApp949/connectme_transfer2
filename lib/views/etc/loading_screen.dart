
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class LoadingScreen extends ConsumerWidget {
  const LoadingScreen(
      {super.key,
        required this.descriptionMain,
        required this.descriptionSub,
        this.noUseItemUploadCounter});

  final String descriptionMain;
  final String descriptionSub;
  final bool? noUseItemUploadCounter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          body: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.sr),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      SizedBox(
                        height: 8.sr,
                      ),
                      Text(
                        descriptionMain,
                        style: TextStyle(fontSize: 12.sr),
                      ),
                      SizedBox(
                        height: 2.sr,
                      ),
                      Text(
                        descriptionSub,
                        style: TextStyle(fontSize: 11.sr),
                      ),
                      SizedBox(
                        height: 12.sr,
                      ),
                      noUseItemUploadCounter == null
                          ? Text(
                        ref.watch(  uploadItemCounterProv).toString() +
                            " Files Uploaded",
                        style: TextStyle(fontSize: 10.sr),
                      )
                          : Container(),
                    ],
                  ))),
        ));
  }
}


