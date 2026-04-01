import 'package:causeries_client/core/network/api_client.dart';
import 'package:causeries_client/core/network/realtime_client.dart';
import 'package:causeries_client/core/storage/token_storage.dart';
import 'package:causeries_client/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:causeries_client/features/authentication/data/services/auth_api_service.dart';
import 'package:causeries_client/features/authentication/presentation/viewmodels/login_view_model.dart';
import 'package:causeries_client/features/authentication/presentation/viewmodels/register_view_model.dart';
import 'package:causeries_client/features/authentication/domain/repositories/auth_repository.dart';
import 'package:causeries_client/features/guilds/data/repositories/channels_repository_impl.dart';
import 'package:causeries_client/features/guilds/data/repositories/guilds_repository_impl.dart';
import 'package:causeries_client/features/guilds/data/services/channels_api_service.dart';
import 'package:causeries_client/features/guilds/data/services/guilds_api_service.dart';
import 'package:causeries_client/features/guilds/domain/repositories/channels_repository.dart';
import 'package:causeries_client/features/guilds/domain/repositories/guilds_repository.dart';
import 'package:causeries_client/features/guilds/presentation/viewmodels/guild_home_view_model.dart';
import 'package:causeries_client/features/users/data/repositories/users_repository_impl.dart';
import 'package:causeries_client/features/users/data/services/users_api_service.dart';
import 'package:causeries_client/features/users/domain/repositories/users_repository.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

const String _defaultApiBaseUrl = String.fromEnvironment('API_BASE_URL');

final List<SingleChildWidget> appProviders = [
  Provider<http.Client>(
    create: (_) => http.Client(),
    dispose: (_, client) => client.close(),
  ),

  Provider<TokenStorage>(create: (_) => TokenStorage.instance),

  ProxyProvider2<http.Client, TokenStorage, ApiClient>(
    update: (_, httpClient, tokenStorage, __) => ApiClient(
      httpClient: httpClient,
      tokenStorage: tokenStorage,
      baseUrl: _defaultApiBaseUrl,
    ),
  ),

  Provider<RealtimeClient>(
    create: (context) => RealtimeClient(
      tokenStorage: context.read<TokenStorage>(),
      apiBaseUrl: _defaultApiBaseUrl,
    ),
    dispose: (_, client) => client.dispose(),
  ),

  ProxyProvider<ApiClient, AuthApiService>(
    update: (_, apiClient, __) => AuthApiService(apiClient),
  ),

  ProxyProvider2<AuthApiService, TokenStorage, AuthRepository>(
    update: (_, apiService, tokenStorage, __) =>
        AuthRepositoryImpl(apiService: apiService, tokenStorage: tokenStorage),
  ),

  ProxyProvider<ApiClient, GuildsApiService>(
    update: (_, apiClient, __) => GuildsApiService(apiClient),
  ),

  ProxyProvider<ApiClient, ChannelsApiService>(
    update: (_, apiClient, __) => ChannelsApiService(apiClient),
  ),

  ProxyProvider<ApiClient, UsersApiService>(
    update: (_, apiClient, __) => UsersApiService(apiClient),
  ),

  ProxyProvider<GuildsApiService, GuildsRepository>(
    update: (_, api, __) => GuildsRepositoryImpl(api),
  ),

  ProxyProvider<ChannelsApiService, ChannelsRepository>(
    update: (_, api, __) => ChannelsRepositoryImpl(api),
  ),

  ProxyProvider<UsersApiService, UsersRepository>(
    update: (_, api, __) => UsersRepositoryImpl(api),
  ),

  ChangeNotifierProxyProvider<GuildsRepository, GuildHomeViewModel>(
    create: (context) => GuildHomeViewModel(context.read<GuildsRepository>()),
    update: (_, guildsRepo, vm) => vm ?? GuildHomeViewModel(guildsRepo),
  ),

  ChangeNotifierProxyProvider<AuthRepository, LoginViewModel>(
    create: (context) => LoginViewModel(context.read<AuthRepository>()),
    update: (_, authRepository, viewModel) =>
        viewModel ?? LoginViewModel(authRepository),
  ),

  ChangeNotifierProxyProvider<AuthRepository, RegisterViewModel>(
    create: (context) => RegisterViewModel(context.read<AuthRepository>()),
    update: (_, authRepository, viewModel) =>
        viewModel ?? RegisterViewModel(authRepository),
  ),
];

extension ProviderContext on BuildContext {
  ApiClient get apiClient => read<ApiClient>();
  AuthApiService get authApiService => read<AuthApiService>();
  AuthRepository get authRepository => read<AuthRepository>();
  GuildsRepository get guildsRepository => read<GuildsRepository>();
  ChannelsRepository get channelsRepository => read<ChannelsRepository>();
  UsersRepository get usersRepository => read<UsersRepository>();
  GuildHomeViewModel get guildHomeViewModel => read<GuildHomeViewModel>();
  LoginViewModel get loginViewModel => read<LoginViewModel>();
  RegisterViewModel get registerViewModel => read<RegisterViewModel>();
}
