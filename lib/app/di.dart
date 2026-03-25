import 'package:causeries_client/core/network/api_client.dart';
import 'package:causeries_client/core/storage/token_storage.dart';
import 'package:causeries_client/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:causeries_client/features/authentication/data/services/auth_api_service.dart';
import 'package:causeries_client/features/authentication/presentation/viewmodels/login_view_model.dart';
import 'package:causeries_client/features/authentication/domain/repositories/auth_repository.dart';
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

  ProxyProvider<ApiClient, AuthApiService>(
    update: (_, apiClient, __) => AuthApiService(apiClient),
  ),

  Provider<TokenStorage>(create: (_) => TokenStorage.instance),

  ProxyProvider2<http.Client, TokenStorage, ApiClient>(
    update: (_, httpClient, tokenStorage, __) => ApiClient(
      httpClient: httpClient,
      tokenStorage: tokenStorage,
      baseUrl: _defaultApiBaseUrl,
    ),
  ),

  ProxyProvider2<AuthApiService, TokenStorage, AuthRepository>(
    update: (_, apiService, tokenStorage, __) =>
        AuthRepositoryImpl(apiService: apiService, tokenStorage: tokenStorage),
  ),

  ChangeNotifierProxyProvider<AuthRepository, LoginViewModel>(
    create: (context) => LoginViewModel(context.read<AuthRepository>()),
    update: (_, authRepository, viewModel) =>
        viewModel ?? LoginViewModel(authRepository),
  ),
];

extension ProviderContext on BuildContext {
  ApiClient get apiClient => read<ApiClient>();
  AuthApiService get authApiService => read<AuthApiService>();
  AuthRepository get authRepository => read<AuthRepository>();
  LoginViewModel get loginViewModel => read<LoginViewModel>();
}
