import 'dart:async';

import 'package:connectme_app/components/ui/etc/tab_page_header.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/config/settings.dart';
import 'package:connectme_app/models/messeging/user_message_thread.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/requests/messeging/block_report.dart';
import 'package:connectme_app/requests/messeging/mark_thread_read.dart';
import 'package:connectme_app/requests/urls.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'chat_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


Future<List<UserMessageThread>> fetchMessageThreads(
    String userToken,
    String userId,
    String userName,

    ) async {
  final uri = Uri.parse(get_message_threads_url);
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'userId': userId,
      'authToken': userToken,
      'userName': userName,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to load threads');
  }

  final List<dynamic> data = jsonDecode(response.body);
  return data.map((e) => UserMessageThread.fromJson(e)).toList();
}

class ThreadListWidget extends ConsumerStatefulWidget {
  const ThreadListWidget({super.key, required this.tabIndex});
  final int tabIndex;
  @override
  ConsumerState<ThreadListWidget> createState() => _ThreadListWidgetState();
}

class _ThreadListWidgetState extends ConsumerState<ThreadListWidget> {

  bool loading = false;
  List<UserMessageThread> threads = [];


  @override
  initState() {
    super.initState();
    lg.t("ThreadListWidget initState");
    scheduleMicrotask(() async {
      setState(() {
        loading = true;
      });
      if (appConfig.simulateNetworkLatency) {
        await Future.delayed(Duration(milliseconds: 1000), () {});
      }
      try {
        threads = await fetchMessageThreads(
            ref.read(userAuthProv)!.userToken,
            ref.read(userAuthProv)!.userId,
            ref.read(userAuthProv)!.userName
        );
      }catch(e){
        lg.e("error fetching threads ~ " + e.toString());
      }

       setState(() {loading = false;});
    });


  }

  @override
  Widget build(BuildContext context) {
    lg.t("[ThreadListWidget] build threads widget");
    if (loading){
      return  Center(child: CircularProgressIndicator());
    }

    if (threads.isEmpty) {
      lg.t("[ThreadListWidget] build threads emptry");
      return
        Scaffold(
        body:Column(children:[
          TabPageHeader(titleString:"Messages"),
          Expanded(child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[Text("No messages yet")]))]));
    }

    lg.t("[ThreadListWidget] build threads not empty");
    return
      Scaffold(
          // appBar: AppBar(title:  Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Padding(padding: EdgeInsets.symmetric(vertical: 14.sr),
          //           child:Text("Messages",
          //             style: tabTitleTextStyle,
          //           ))
          //     ]),),
          body:
          Column(children:[
              TabPageHeader(titleString:"Messages"),
          Expanded(
          child:ListView.builder(
      itemCount: threads.length,
      itemBuilder: (context, index) {
        final thread = threads[index];

        lg.t("build thread ~ " + thread.toString());

        if (thread.wantBlock != null && thread.wantBlock!.isNotEmpty){
          if (thread.wantBlock!.contains(ref.read(userAuthProv)!.userId)) {
            return
              PopupMenuButton<int>(
                  onSelected: (value) async {
                    if (value == 1) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const Center(child: CircularProgressIndicator()),
                      );
                      await blockUser(
                          ref.read(userAuthProv)!.userToken,
                          ref.read(userAuthProv)!.userId,
                          thread.threadId,
                          thread.otherUserId,
                          "unblock"
                      );
                      Navigator.of(gNavigatorKey.currentContext!).pop();

                      //TODO optimize this probably with optimistic update
                      try {
                        threads = await fetchMessageThreads(
                            ref.read(userAuthProv)!.userToken,
                            ref.read(userAuthProv)!.userId,
                            ref.read(userAuthProv)!.userName
                        );
                      }
                      catch(e){
                        lg.e("error fetching threads ~ " + e.toString());
                      }
                      setState(() {

                      });

                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 1, child: Text('Unblock')),
                  ],
                  child:
              ListTile(
              leading: Icon(Icons.block),
              title: Text(thread.otherUserName),
              subtitle: Text("Blocked"),
              // trailing: Text(
              //   "${thread.lastUpdated.hour}:${thread.lastUpdated.minute.toString().padLeft(2, '0')}",
              //   style: const TextStyle(fontSize: 12),
              // ),
              // onTap: () {
              //
              // },
            ));
          }
        }
        return ListTile(

          leading: CircleAvatar(
            backgroundColor: appPrimarySwatch[600],
            child: Text(thread.otherUserName[0].toUpperCase(),
            style: TextStyle(color: Colors.white),
            ),
          ),
          title: Text(thread.otherUserName
          + (thread.unread?.contains(ref.watch(userAuthProv)!.userId) ?? false ? " (unread)" : "")
          ),
          subtitle: Text(thread.lastMessage),
          trailing:
          // Text(
          //   "${thread.lastUpdated.hour}:${thread.lastUpdated.minute.toString().padLeft(2, '0')}",
          //   style: const TextStyle(fontSize: 12),
          // ),
          Text(
            DateFormat.jm().format(thread.lastUpdated),
            style: const TextStyle(fontSize: 12),
          ),
          onTap: () async {

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
            try{
              await markThreadRead(ref, threadId: thread.threadId);
              Navigator.of(gNavigatorKey.currentContext!).pop();
              Navigator.of(gNavigatorKey.currentContext!).push(
                MaterialPageRoute(
                  builder: (context) => ChatPage(thread: thread),
                ),
              );
            }catch(e){
              Navigator.of(gNavigatorKey.currentContext!).pop();
              lg.e("error marking thread read ~ " + e.toString());
            }


          },
        );
      },
    ))
    ])
      );
  }
}