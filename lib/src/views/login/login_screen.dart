import 'dart:io';

import 'package:causeries_client/l10n/app_localizations.dart';
import 'package:causeries_client/src/components/base_layout.dart';
import 'package:causeries_client/src/components/button.dart';
import 'package:causeries_client/src/components/login/login_form.dart';
import 'package:causeries_client/src/themes/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BaseLayout(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacing * 2),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth:
                  kIsWeb ||
                      Platform.isWindows ||
                      Platform.isLinux ||
                      Platform.isMacOS
                  ? AppTheme.maxDesktopWidth
                  : double.infinity,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n!.signIn, style: theme.textTheme.titleLarge),
                const SizedBox(height: AppTheme.spacing * 2),

                const LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
