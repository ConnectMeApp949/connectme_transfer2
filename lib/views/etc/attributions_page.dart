
  import 'package:connectme_app/styles/text.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:flutter/material.dart';



  class AttributionsPage extends ConsumerWidget {
    const AttributionsPage({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
      return Scaffold(
          appBar: AppBar(title: Text('Attributions',
            style: tabTitleTextStyle,
          )),
          body: Column(
              children: [
                const SizedBox(height: 24),
                Expanded(
                    child: ListView(
                        children: [


                          ListTile(

                            title: Text("Location API: OpenStreetMap"),
                            subtitle: Text("Data is available under the Open Database License"),
                          ),
                          // ListTile(
                          //   title: Text("Developer: SigInfinite"),
                          // ),
                        ]))
              ]));
    }
  }