import 'package:causeries_client/core/storage/secure_storage.dart';

class TokenStorage {
  TokenStorage._();

  static final TokenStorage instance = TokenStorage._();

  static const String _tokenKey = 'auth_token';

  Future<void> save(String token) async {
    return await SecureStorage.instance.write(key: _tokenKey, value: token);
  }

  Future<String?> read() async {
    return await SecureStorage.instance.read(_tokenKey);
  }

  Future<bool> hasToken() async {
    final test = await SecureStorage.instance.contains(_tokenKey);
    return test;
  }

  Future<void> clear() async {
    return SecureStorage.instance.delete(_tokenKey);
  }
}
