


import 'dart:io';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/models/user/etc.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ValueListenableBuilder2<A, B> extends StatelessWidget {
  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget Function(BuildContext, A, B, Widget?) builder;

  const ValueListenableBuilder2({
    super.key,
    required this.first,
    required this.second,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (context, valueA, _) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, valueB, child) {
            return builder(context, valueA, valueB, child);
          },
        );
      },
    );
  }
}


Future<void> showConfirmDeleteAccountDialog(
    BuildContext context,
    WidgetRef ref,
    {
      required String username,
      required Future<void> Function() onConfirm,
    }) {
  final TextEditingController controller = TextEditingController();
  final ValueNotifier<bool> isMatch = ValueNotifier(false);
  final isLoading = ValueNotifier(false);

  return showDialog(
    context: context,
    barrierDismissible: !isLoading.value,
    builder: (context) {
      return AlertDialog(
        title: Text('Confirm Delete Account'),
        content:
        SingleChildScrollView(
            child: ListBody(
                children: <Widget>[

             Text(

               (kIsWeb && ref.watch(userTypeProv) == UserType.vendor)?
              'IMPORTANT: You will still need to cancel your subscription separately. This can be done via the management URL found by tapping "Manage Subscription" or the customer portal that was emailed to you. \n\n You will not be able to recover this account once deleted, this action is permanent. Are you sure you wish to do this?':
               (Platform.isAndroid && ref.watch(userTypeProv) == UserType.vendor)?
                'IMPORTANT: You will still need to cancel your subscription separately. This can be done via the management URL found by tapping "Manage Subscription" or through Google Play. \n\n You will not be able to recover this account once deleted, this action is permanent. Are you sure you wish to do this?':
               (Platform.isIOS && ref.watch(userTypeProv) == UserType.vendor)?
              'IMPORTANT: You will still need to cancel your subscription separately. This can be done via the management URL found by tapping "Manage Subscription" or through your device settings. \n\n You will not be able to recover this account once deleted, this action is permanent. Are you sure you wish to do this?':
                (kIsWeb && ref.watch(userTypeProv) == UserType.client)?
              'IMPORTANT: You will not be able to recover this account once deleted, this action is permanent. Are you sure you wish to do this?':
              (Platform.isAndroid && ref.watch(userTypeProv) == UserType.client)?
              'IMPORTANT:  You will not be able to recover this account once deleted, this action is permanent. Are you sure you wish to do this?':
              (Platform.isIOS && ref.watch(userTypeProv) == UserType.client)?
              'IMPORTANT: You will not be able to recover this account once deleted, this action is permanent. Are you sure you wish to do this?':
              "You will not be able to recover this account once deleted, this action is permanent. Are you sure you wish to do this?",


              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Text('Type your username $username to confirm account deletion:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Username',
              ),
              onChanged: (value) {
                isMatch.value = value.trim() == username.trim();
              },
            ),
            SizedBox(height: 16),
            ValueListenableBuilder<bool>(
              valueListenable: isLoading,
              builder: (context, loading, _) {
                if (loading) {
                  return Column(
                    children: [
                      SizedBox(height: 8),
                      CircularProgressIndicator(),
                    ],
                  );
                }
                return SizedBox.shrink();
              },
            ),

                          ])

        ),

        actions: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (context, loading, _) {
              return TextButton(
                onPressed: loading ? null : () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              );
            },
          ),
          ValueListenableBuilder2<bool, bool>(
            first: isMatch,
            second: isLoading,
            builder: (context, match, loading, _) {
              return ElevatedButton(
                onPressed: (match && !loading)
                    ? () async {
                  isLoading.value = true;
                  try {
                    await onConfirm();
                    Navigator.of(gNavigatorKey.currentContext!).pop();
                  } catch (e) {
                    isLoading.value = false;
                    Navigator.of(gNavigatorKey.currentContext!).pop();
                    ScaffoldMessenger.of(gNavigatorKey.currentContext!).showSnackBar(
                      SnackBar(content: Text('Failed to delete: $e')),
                    );
                  }
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: Text('Delete',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          )]),
        ],
      );
    },
  );
}