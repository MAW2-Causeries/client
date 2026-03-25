import 'package:causeries_client/features/authentication/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<void> register(String email, String username, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
}
