import 'package:causeries_client/l10n/app_localizations.dart';
import 'package:causeries_client/app/routes.dart';
import 'package:causeries_client/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class Causeries extends StatelessWidget {
  const Causeries({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Causeries',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: Routes.login,
      routes: Routes.routes,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
