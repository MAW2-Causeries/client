import 'package:causeries_client/features/authentication/presentation/views/login_screen.dart';
import 'package:causeries_client/features/authentication/presentation/views/register_screen.dart';
import 'package:flutter/widgets.dart';

class Routes {
  static const String login = '/login';
  static const String register = '/register';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
  };
}
