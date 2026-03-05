

import 'dart:async';

import 'package:connectme_app/components/ui/buttons/rounded_outline_button.dart';
import 'package:connectme_app/components/ui/modals/error_dialog.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/config/settings.dart';
import 'package:connectme_app/models/messeging/user_message_thread.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/providers/messaging.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/requests/messeging/block_report.dart';
import 'package:connectme_app/requests/messeging/get_messages.dart';
import 'package:connectme_app/requests/urls.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/util/etc.dart';
import 'package:connectme_app/util/navigation.dart';
import 'package:connectme_app/views/etc/success_screen.dart';
import 'package:connectme_app/views/strings/ui_message_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


// DisplayMessage model
class DisplayMessage {
  final String id;
  final String text;
  final DateTime timestamp;
  final String senderName;
  DisplayMessage(this.id,this.text, this.timestamp, this.senderName);
}



Future<void> sendMessage({
  required String userId,
  required String userToken,
  required String messageId,
  required String receiverId,
  required String senderName,
  required String threadId,
  required String senderId,
  required String msgText,
}) async {
  final uri = Uri.parse(send_message_url);
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'userId': userId,
      "authToken": userToken,
      'messageId': messageId,
      'receiverId': receiverId,
      'userName': senderName,
      'threadId': threadId,
      'senderId': senderId,
      'text': msgText,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to send message');
  }
}





class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key,
  required this.thread
  });

  final UserMessageThread thread;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  bool loading = false;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool canFetch = true;
  Timer? _debounceTimer;

  bool usePolling = true;
  Timer? _pollingTimer;
  void startPolling() {
    _pollingTimer?.cancel(); // cancel if already running
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (ref.read(messagesProvider).isEmpty) return;
      await pollMessagesForThread(ref,
        threadId: widget.thread.threadId,
        limit: 20,
        startBefore: ref
            .read(messagesProvider)[0]
            .timestamp,
      );
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
  }

  @override
  void initState() {
    super.initState();

    if (usePolling) {
      startPolling();
    }

    scheduleMicrotask(() async {
      ref.read(messagesProvider.notifier).clearMessages();
      setState(() {
        loading = true;
        canFetch = false;
      });

      try {
        await fetchMessagesForThread(ref,
          threadId: widget.thread.threadId,
          limit: 20,
        );
      }catch (e){
        lg.e("Exp caught in [fetchMessagesForThread] " + e.toString());
      }
      setState(() {
        loading = false;
        canFetch = true;
      });
      // _scrollController.jumpTo(0);
    });

    _scrollController.addListener(() async{
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {

        if (!canFetch) return;

        setState(() {
          loading = true;
          canFetch = false;
        });

          if (appConfig.simulateNetworkLatency) {
            await Future.delayed(Duration(milliseconds: 1000), () {});
          }

          try {
            await fetchMessagesForThread(ref,
              threadId: widget.thread.threadId,
              limit: 20,
              startAfter: ref
                  .read(messagesProvider)
                  .last
                  .timestamp,
            );
          }
          catch(e){
            lg.e("Exp caught in chatPage fetchMessages initState");
            showErrorDialog(gNavigatorKey.currentContext!, default_error_message);
          }

          setState(() {
            loading = false;
          });
          scheduleMicrotask(() async {
            if (_scrollController.hasClients) {
              _scrollController.jumpTo(
                  _scrollController.position.maxScrollExtent - 10);
            }
          });

          _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 8888), () async{
          setState(() {canFetch = true;});
        });
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    _controller.dispose();
    _debounceTimer?.cancel();
    _scrollController.dispose();
    if (usePolling) {
      stopPolling();
    }
  }


  void _sendMessage() async {
    final text = _controller.text;
    String messageId = generateRandomAlphanumeric(15);

    ref.read(messagesProvider.notifier).addNewMessages([
      DisplayMessage(
        messageId,
        text,
        DateTime.now().toUtc(),
        ref.read(userAuthProv)!.userName,
      ),
    ]);

    _controller.clear();
    try {
      await sendMessage(
          userId: ref.read(userAuthProv)!.userId,
          userToken: ref.read(userAuthProv)!.userToken,
          messageId: messageId,
          receiverId: widget.thread.otherUserId,
          senderName: ref.read(userAuthProv)!.userName,
          threadId: widget.thread.threadId,
          senderId: ref.read(userAuthProv)!.userId,
          msgText: text);
    }catch(e){
      lg.e("error sending message ~ " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messagesProvider);

    /// messagesProvider defaults to empty list []
    if (messages.isEmpty && loading){
      return  SafeArea(child:Scaffold(
          appBar: AppBar(title:
          Text(widget.thread.otherUserName)),
            body: Center(child: CircularProgressIndicator(),)
          ));
    }

    return SafeArea(child:Scaffold(
        appBar: AppBar(title:
          Text(widget.thread.otherUserName),
        actions:[PopupMenuButton<String>(
          onSelected: (value) async{
            if (value == 'Block'){

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(child: CircularProgressIndicator()),
              );
              await blockUser(
                ref.read(userAuthProv)!.userToken,
                ref.read(userAuthProv)!.userId,
                widget.thread.threadId,
                widget.thread.otherUserId,
                "block",
              );


              pushToUserTypeHome(gNavigatorKey.currentContext!, ref, ref.read(userTypeProv)!);

            }
            if (value == 'Report'){
              // BuildContext pageContext = context;
              showReportDialog(gNavigatorKey.currentContext!, ref,  widget.thread.threadId, widget.thread.otherUserId);

            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'Block',
              child: Text('Block'),
            ),
            const PopupMenuItem<String>(
              value: 'Report',
              child: Text('Report'),
            ),
          ],
          child: IconButton(
              onPressed: null, // Use the PopupMenuButton's own tap
              icon: const Icon(Icons.more_vert)
          ),
        )]
        ),
        body:Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              if (loading){
               if (index == messages.length - 1) {
                     return ListTile(title:
                     Center(child: CircularProgressIndicator()));
                }
                }
              final msg = messages[index];
              if (msg.senderName == ref.read(userAuthProv)!.userName){
                return SentMessage(
                  text: msg.text,
                  timestamp: msg.timestamp,
                );
              }
              else if  (msg.senderName != ref.read(userAuthProv)!.userName){
                return ReceivedMessage(
                  text: msg.text,
                  timestamp: msg.timestamp,
                );
              }
              lg.e("message not able to build");
              return Container();
              // return ListTile(
              //   title: Text(msg.text),
              //   subtitle: Text(
              //     msg.timestamp.toIso8601String().substring(11, 16),
              //     style: const TextStyle(fontSize: 12),
              //   ),
              // );
            },
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: const InputDecoration(
                    hintText: 'Type a message',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send,
                size:Theme.of(context).textTheme.titleLarge!.fontSize,
                  color: appPrimarySwatch[700],
                ),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    )));
  }
}

class SentMessage extends StatelessWidget {
  final String text;
  final DateTime timestamp;

  const SentMessage({
    super.key,
    required this.text,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    // final time = timestamp.toIso8601String().substring(11, 16);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.67,
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(4),
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  text,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat.jm().format(timestamp),
                  style: const TextStyle(fontSize: 10, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ReceivedMessage extends StatelessWidget {
  final String text;
  final DateTime timestamp;

  const ReceivedMessage({
    super.key,
    required this.text,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    // final time = timestamp.toIso8601String().substring(11, 16);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.67,
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(14),
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat.jm().format(timestamp),
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


showReportDialog(BuildContext pageContext, WidgetRef ref, String threadId, String otherUserId) async {
  TextEditingController controller = TextEditingController();
  return showDialog(
    context: pageContext,
    builder: (context) {
      return AlertDialog(
        title: Text('Report User'),
        content:
        // Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
        Text('Please give a reason for reporting this user',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Reason',
              ),

            ),
            SizedBox(height: 16),

          ],
        )),
        actions: [

          RoundedOutlineButton(onTap: (){
            Navigator.of(context).pop();
          },
            label: "Cancel",
            // width: Gss.width * .7,
            // paddingVertical: Gss.height * .01,
          ),

          RoundedOutlineButton(onTap: ()async{
            Navigator.of(context).pop();
            await reportUser(
                ref.read(userAuthProv)!.userToken,
                ref.read(userAuthProv)!.userId,
                threadId,
                otherUserId,
                controller.text);
            Navigator.of(gNavigatorKey.currentContext!, rootNavigator: true).push(MaterialPageRoute(builder: (context)
            {
              return SuccessScreen(
                message: "Report Submitted",
                continueCallback: () {
                  pushToUserTypeHome(context, ref, ref.read(userTypeProv)!);
            },
              );
            }));
          },
            label: "Submit",
            // width: Gss.width * .7,
            // paddingVertical: Gss.height * .01,
          ),
        ],
      );
    },
  );
}