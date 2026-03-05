import 'package:connectme_app/styles/text.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:flutter/material.dart';


class TabPageHeader extends StatelessWidget {
  const TabPageHeader({super.key,
  required this.titleString
  });

  final String titleString;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 22),
                  child:Text(titleString,
                    style: tabTitleTextStyle,
                  ))
            ]));
  }
}


class PageHeaderWithBack extends StatelessWidget {
  const PageHeaderWithBack({super.key,
    required this.titleString
  });

  final String titleString;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child:
        Stack(children:[
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 22),
                  child:Text(titleString,
                    style: tabTitleTextStyle,
                  ))
            ]),

          Positioned(
            top:0,
          child:Row(
            crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.fromLTRB(4.sr, 0, 0,0),
                    child:IconButton(onPressed: (){
                      Navigator.of(context).pop();
                    },
                        icon: Icon(Icons.arrow_back_ios)
                    )
                ),
              ]))
        ])

    );
  }
}