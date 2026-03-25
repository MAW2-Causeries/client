import 'package:causeries_client/features/authentication/domain/entities/user.dart';
import 'package:causeries_client/features/authentication/domain/errors/auth_exceptions.dart';
import 'package:causeries_client/features/authentication/domain/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  LoginViewModel(this._authRepository);

  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  bool get canSubmit =>
      !_isLoading && _email.trim().isNotEmpty && _password.isNotEmpty;

  void setEmail(String value) {
    _email = value;
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

  Future<bool> login() async {
    if (!canSubmit) {
      _errorMessage = 'Email and password are required.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authRepository.login(_email.trim(), _password);
      return true;
    } on InvalidCredentialsException {
      _errorMessage = 'Invalid email or password.';
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
