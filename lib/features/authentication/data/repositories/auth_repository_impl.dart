import 'package:causeries_client/core/storage/token_storage.dart';
import 'package:causeries_client/features/authentication/data/models/user_dto.dart';
import 'package:causeries_client/features/authentication/data/services/auth_api_service.dart';
import 'package:causeries_client/features/authentication/domain/entities/user.dart';
import 'package:causeries_client/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthApiService apiService;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({required this.apiService, required this.tokenStorage});

  @override
  Future<User> login(String email, String password) async {
    final response = await apiService.login(email, password);
    final userDto = UserDto.fromJson(response);
    final token = response['token'] as String;

    await tokenStorage.save(token);

    return userDto.toDomain();
  }

  @override
  Future<void> register(String email, String username, String password) {
    return apiService.register(email, username, password);
  }

  @override
  Future<void> logout() async {
    await apiService.logout();

    await tokenStorage.clear();
  }

  @override
  Future<User?> getCurrentUser() async {
    final response = await apiService.getCurrentUser();
    final userDto = UserDto.fromJson(response);

    return userDto.toDomain();
  }
}
