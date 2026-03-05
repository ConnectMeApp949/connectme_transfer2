
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:flutter/material.dart';

showUseSuggestedAddressDialog(BuildContext context, Map<String, dynamic> resp, Function okCallback, Function cancelCallback) async {
  return await showDialog(context: context, builder: (context) =>
      AlertDialog(
        title: Text("Use Suggested Address?"),
        content:
        SingleChildScrollView(
          child: ListBody(
              children: <Widget>[
        Text(resp["display_name"] ?? "Not Found",
        style: TextTheme.of(context).headlineMedium,
        )])),
        actions: [



      Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          Padding(
              padding: EdgeInsets.symmetric(vertical: Gss.width * .03),
              child:TextButton(onPressed: ()async{
                await cancelCallback();
              },
                  child:Text( "Cancel",
                      style:TextStyle(fontSize:  13.sr,
                          color: Theme.of(context).colorScheme.onSurface
                      ))
                // width: Gss.width * .45,
                // paddingVertical: Gss.height * .01,
              )),
          Padding(
              padding: EdgeInsets.symmetric(vertical: Gss.width * .03),
              child:TextButton(onPressed: ()async{
                await okCallback();
              },
                  child:Text( "Ok",
                      style:TextStyle(fontSize:  13.sr,
                          color: appPrimarySwatch[800]
                      ))
                // width: Gss.width * .45,
                // paddingVertical: Gss.height * .01,
              )),
      ])


      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //     children:[RoundedOutlineButton(
      //         onTap: () async {
      //           await cancelCallback();
      //         },
      //         label: "Cancel")]),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children:[
      //     Padding(
      //         padding: EdgeInsets.symmetric(vertical: 12.sr),
      //         child: RoundedOutlineButton(
      //             onTap: () async {
      //              await okCallback();
      //             },
      //             label: "Ok"))]),
        ],
      ));
}