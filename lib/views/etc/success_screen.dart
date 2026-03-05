
import 'package:connectme_app/components/ui/buttons/rounded_outline_button.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key,
  required this.message,
    required this.continueCallback
  });
  final String message;
  final VoidCallback continueCallback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:ListView(
            // mainAxisSize: MainAxisSize.min,
        shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
         Icon(Icons.check_circle_outlined, size: Gss.width * .3,
         color: Colors.green,
         ),
          SizedBox(height: Gss.height * .02,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Gss.width*.02),
              child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
              Flexible(child:Text(message,
          style: Theme.of(context).textTheme.headlineSmall,
          ))])),
          SizedBox(height: Gss.height * .08,),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: Gss.width * .03),
              child:RoundedOutlineButton(onTap: (){
            continueCallback();
          },
            label: "Continue",
            width: Gss.width * .88,
            paddingVertical: Gss.height * .01,
          )),
        // Container(
        //   color: Colors.red,
        //   height: Gss.height * .7,)
        ]
        )
      ),
    );
  }
}