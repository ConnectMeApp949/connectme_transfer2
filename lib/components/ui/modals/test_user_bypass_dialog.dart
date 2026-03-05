import 'dart:convert';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/settings.dart';
import 'package:connectme_app/models/user/etc.dart';
import 'package:connectme_app/requests/login/login.dart';
import 'package:connectme_app/requests/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;


Future<void> showTestUserBypassDialog(BuildContext context) async {
  final result = await showDialog<UserType>(
    context: context,
    builder: (context) => const RolePasswordDialog(),
  );

  if (result != null) {
    // Do something with the selected role
    debugPrint("Selected role: $result");
  } else {
    debugPrint("Dialog cancelled or failed");
  }
}


class RolePasswordDialog extends ConsumerStatefulWidget {
  const RolePasswordDialog({super.key});

  @override
  ConsumerState<RolePasswordDialog> createState() => _RolePasswordDialogState();
}

class _RolePasswordDialogState extends ConsumerState<RolePasswordDialog> {
  UserType? _selectedType = UserType.vendor;
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  Future<bool> _checkPassword(String password) async {
    // Example: replace with your own API endpoint
    final url = Uri.parse(test_user_password_url);

    final response = await http.post(
      url,
      body: jsonEncode({"password": password}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["success"] == true;
    } else {
      throw Exception("Failed to check password");
    }
  }

  void _onConfirm() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final isValid = await _checkPassword(_passwordController.text);
      if (isValid) {
        if (_selectedType == UserType.client) {
          await initializeLoginUserHome(
              ref, clientTestUser.uid, clientTestUser.un,
              clientTestUser.ut, clientTestUser.ue, clientTestUser.utype.name,
          "free",
            false,
            appConfig.sConfigOptions
          );
          Navigator.pushNamedAndRemoveUntil(
              gNavigatorKey.currentContext!, "/client_home", (route) => false);
        }
        if (_selectedType == UserType.vendor) {
          await initializeLoginUserHome(
              ref, vendorTestUser.uid, vendorTestUser.un,
              vendorTestUser.ut, vendorTestUser.ue, vendorTestUser.utype.name,
          "vendor_basic",
            true,
              appConfig.sConfigOptions
          );

          Navigator.pushNamedAndRemoveUntil(gNavigatorKey.currentContext!, "/vendor_home", (route) => false);
        }
      } else {
        setState(() {
          _errorMessage = "Incorrect password";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Network error: $e";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select Role & Enter Password"),
      content:
      // Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              RadioListTile<UserType>(
                title: const Text("Vendor"),
                value: UserType.vendor,
                groupValue: _selectedType,
                onChanged: _isLoading
                    ? null
                    : (UserType? value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
              ),
              RadioListTile<UserType>(
                title: const Text("Client"),
                value: UserType.client,
                groupValue: _selectedType,
                onChanged: _isLoading
                    ? null
                    : (UserType? value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
              ),
              TextField(
                controller: _passwordController,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  labelText: "Password",
                  errorText: _errorMessage,
                ),
                obscureText: true,
                onSubmitted: (_) => !_isLoading ? _onConfirm() : null,
              ),
            ],
          )),
      actions: [

        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              TextButton(
                onPressed: _isLoading ? null : () => Navigator.of(context).pop(null),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _onConfirm,
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text("Confirm"),
              )]),
      ],
    );
  }
}