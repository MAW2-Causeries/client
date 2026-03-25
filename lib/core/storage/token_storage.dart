import 'package:causeries_client/core/storage/secure_storage.dart';

class TokenStorage {
	TokenStorage._();

	static final TokenStorage instance = TokenStorage._();

	static const String _tokenKey = 'auth_token';

	Future<void> save(String token) {
		return SecureStorage.instance.write(key: _tokenKey, value: token);
	}

	Future<String?> read() {
		return SecureStorage.instance.read(_tokenKey);
	}

	Future<bool> hasToken() {
		return SecureStorage.instance.contains(_tokenKey);
	}

	Future<void> clear() {
		return SecureStorage.instance.delete(_tokenKey);
	}
}