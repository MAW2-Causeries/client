import 'package:causeries_client/features/authentication/domain/errors/auth_exceptions.dart';
import 'package:causeries_client/features/authentication/domain/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  RegisterViewModel(this._authRepository);

  String _email = '';
  String _username = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;

  String get email => _email;
  String get username => _username;
  String get password => _password;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get canSubmit =>
      !_isLoading &&
      _email.trim().isNotEmpty &&
      _username.trim().isNotEmpty &&
      _password.isNotEmpty;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setUsername(String value) {
    _username = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> register() async {
    if (!canSubmit) {
      _errorMessage = 'Username, email, and password are required.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.register(
        _email.trim(),
        _username.trim(),
        _password,
      );
      return true;
    } on UserAlreadyExistsException {
      _errorMessage = 'Email or username already in use.';
      return false;
    } on NetworkException {
      _errorMessage = 'Network error. Please check your connection.';
      return false;
    } on ServerException {
      _errorMessage = 'Server error. Please try again later.';
      return false;
    } catch (_) {
      _errorMessage = 'Unexpected error. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
