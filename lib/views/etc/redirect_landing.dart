
import 'package:connectme_app/config/globals.dart';
import 'package:flutter/material.dart';

class RedirectLanding extends StatelessWidget {
  const RedirectLanding({super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child:Column(mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_outlined, size: Gss.width * .3,
                  color: Colors.green,
                ),
                Text("Success!",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: Gss.height * .08,),
                Text("You can close this page",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ]
          )
      ),
    );
  }
}