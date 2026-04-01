import 'package:causeries_client/features/authentication/presentation/views/login_screen.dart';
import 'package:causeries_client/features/authentication/presentation/views/register_screen.dart';
import 'package:causeries_client/features/authentication/presentation/views/auth_boot_screen.dart';
import 'package:causeries_client/features/guilds/presentation/views/channel_create_screen.dart';
import 'package:causeries_client/features/guilds/presentation/views/guild_create_screen.dart';
import 'package:causeries_client/features/guilds/presentation/views/guild_home_screen.dart';
import 'package:flutter/widgets.dart';

class Routes {
  static const String boot = '/';
  static const String login = '/login';
  static const String register = '/register';

  static const String guildHome = '/guild';
  static const String guildCreate = '/guild/create';
  static const String channelCreate = '/channel/create';

  static final Map<String, WidgetBuilder> routes = {
    boot: (context) => const AuthBootScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),

    guildHome: (context) => const GuildHomeScreen(),
    guildCreate: (context) => const GuildCreateScreen(),
    channelCreate: (context) => const ChannelCreateScreen(),
  };
}
