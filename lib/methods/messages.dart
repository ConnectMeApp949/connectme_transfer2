
import 'package:connectme_app/config/settings.dart';
import 'package:connectme_app/models/messeging/user_message_thread.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/requests/messeging/get_or_create_thread.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/logger.dart';

Future getThreadForChatPage(BuildContext context, WidgetRef ref, String callingUserId, String otherUserId, String otherUserName )async {
  lg.t("[getThreadAndPushToChatPage] called");
  try {
    UserMessageThread getThread =
    await getOrCreateThread(
      ref,
      ref.read(userAuthProv)!.userId,
      ref.read(userAuthProv)!.userName,
      ref.read(userAuthProv)!.userId,
      otherUserId,
      ref.read(userAuthProv)!.userName,
      otherUserName,
    );

    if (appConfig.simulateNetworkLatency) {
      await Future.delayed(const Duration(milliseconds: 1000));
    }

    return getThread;

  } catch (e) {
    lg.e("error getting thread ~ " + e.toString());
  }
}