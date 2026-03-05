

import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/views/messaging/chat_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messagesProvider = StateNotifierProvider<MessagesNotifier,
    List<DisplayMessage>>((ref) {
  return MessagesNotifier();
});

class MessagesNotifier extends StateNotifier<List<DisplayMessage>> {
  MessagesNotifier() : super([]);


  // void addNewMessage(String id, String text, String senderName) {
  //   state = [ DisplayMessage(
  //   id,
  //        text.trim(), DateTime.now().toUtc(),
  //         senderName
  //   ), ...state,];
  // }

  void addOldMessages(List<DisplayMessage> messages) {
    lg.t("[addOldMessages] called");
    state = [...state, ...messages];
  }

  void addNewMessages(List<DisplayMessage> messages) {

    int last_check_length = 10;
    List<DisplayMessage> new_messages_to_add = [];
    for (var new_message in messages) {
      bool is_new = true;
      if (state.isNotEmpty) {
        if (state.length < last_check_length) {
          last_check_length = state.length ;
        }
        for (var old_message in state
            .sublist( 0, last_check_length)
        ) { // check if last 10 messages are same
          if (old_message.id == new_message.id) {
            is_new = false;
            break;
          }
        }
        if (is_new) {
          new_messages_to_add.add(new_message);
        }
      }else{
        new_messages_to_add.add(messages[0]);
      }
    }

    List nm_timestamps = [];
    for (var new_message in new_messages_to_add) {
      nm_timestamps.add(new_message.timestamp);
    }
    // print("pre sort timestamps ~ " + nm_timestamps.toString());

    new_messages_to_add.sort((a, b) =>
        b.timestamp.compareTo(a.timestamp));

    List snm_timestamps = [];
    for (var new_message in new_messages_to_add) {
      snm_timestamps.add(new_message.timestamp);
    }
    // print("post sort timestamps ~ " + snm_timestamps.toString());
    state = [...new_messages_to_add, ...state,];
  }


  void clearMessages(){
    state = [];
  }
}