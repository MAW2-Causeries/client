import 'package:causeries_client/features/authentication/presentation/screens/login_screen.dart';
import 'package:flutter/widgets.dart';

class Routes {
  static const String login = '/login';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
  };
}
