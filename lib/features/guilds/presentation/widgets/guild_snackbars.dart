import 'package:flutter/material.dart';

class GuildSnackbars {
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  static void showErrorMessenger(
    ScaffoldMessengerState messenger,
    String message,
  ) {
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}
