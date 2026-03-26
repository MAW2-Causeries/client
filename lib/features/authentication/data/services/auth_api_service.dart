import 'package:causeries_client/core/network/api_client.dart';
import 'package:causeries_client/features/authentication/domain/errors/auth_exceptions.dart';

class AuthApiService {
  final ApiClient client;

  AuthApiService(this.client);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await client.post(
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

  Future<void> register(String email, String username, String password) async {
    try {
      await client.post(
        '/users',
        body: {
          'user': {'email': email, 'username': username, 'password': password},
        },
      );
    } on ApiException catch (e) {
      switch (e.statusCode) {
        case 403:
          throw UserAlreadyExistsException();
        default:
          rethrow;
      }
    } catch (e) {
      print(e); // Log the error for debugging
      throw e; // Rethrow the error to be handled by the caller
    }
  }

  Future<void> logout() {
    return client.delete('/sessions');
  }

  Future<Map<String, dynamic>> getCurrentUser() {
    return client.get('/sessions');
  }
}
