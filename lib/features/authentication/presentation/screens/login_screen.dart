import 'package:causeries_client/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(body: Center(child: Text(l10n!.signIn)));
  }
}
