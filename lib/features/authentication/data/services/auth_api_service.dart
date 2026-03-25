import 'package:causeries_client/core/network/api_client.dart';
import 'package:causeries_client/features/authentication/domain/errors/auth_exceptions.dart';

class AuthApiService {
  final ApiClient client;

  AuthApiService(this.client);

  Future<Map<String, dynamic>> login(String email, String password) {
    try {
      final response = client.post(
        '/sessions',
        body: {'email': email, 'password': password},
      );

      return response;
    } on ApiException catch (e) {
      switch (e.statusCode) {
        case 401:
          throw InvalidCredentialsException();
        default:
          rethrow;
      }
    }
  }

  Future<void> logout() {
    return client.delete('/sessions');
  }

  Future<Map<String, dynamic>> getCurrentUser() {
    return client.get('/sessions');
  }
}
