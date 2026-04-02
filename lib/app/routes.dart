import 'package:causeries_client/features/authentication/presentation/views/login_screen.dart';
import 'package:causeries_client/features/authentication/presentation/views/register_screen.dart';
import 'package:causeries_client/features/authentication/presentation/views/auth_boot_screen.dart';
import 'package:causeries_client/features/guilds/presentation/views/guild_home_screen.dart';
import 'package:causeries_client/features/guilds/presentation/viewmodels/channel_messages_controller.dart';
import 'package:causeries_client/features/authentication/domain/repositories/auth_repository.dart';
import 'package:causeries_client/features/guilds/domain/repositories/channels_repository.dart';
import 'package:causeries_client/features/users/domain/repositories/users_repository.dart';
import 'package:causeries_client/core/network/realtime_client.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

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

    guildHome: (context) => ChangeNotifierProvider<ChannelMessagesController>(
      create: (context) => ChannelMessagesController(
        channelsRepository: context.read<ChannelsRepository>(),
        usersRepository: context.read<UsersRepository>(),
        authRepository: context.read<AuthRepository>(),
        realtimeClient: context.read<RealtimeClient>(),
      )..init(),
      child: const GuildHomeScreen(),
    ),
  };
}
