import 'package:causeries_client/l10n/app_localizations.dart';
import 'package:causeries_client/src/components/button.dart';
import 'package:causeries_client/src/components/inputs/email_input.dart';
import 'package:causeries_client/src/components/inputs/password_input.dart';
import 'package:causeries_client/src/themes/app_theme.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          EmailInput(label: l10n.email, controller: emailController),

          const SizedBox(height: AppTheme.spacing),

          PasswordInput(
            label: l10n.password,
            controller: passwordController,
            validate: false,
          ),

          const SizedBox(height: AppTheme.spacing * 2),

          Button(
            label: l10n.signIn,
            onPressed: () {
              _formKey.currentState!.validate();
            },
          ),
        ],
      ),
    );
  }
}
