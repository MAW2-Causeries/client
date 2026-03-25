class AuthExceptions implements Exception {}

class InvalidCredentialsException extends AuthExceptions {
  @override
  String toString() => 'Invalid email or password.';
}

class UserAlreadyExistsException extends AuthExceptions {
  @override
  String toString() => 'Email or username already in use.';
}

class NetworkException extends AuthExceptions {
  @override
  String toString() => 'Network error. Please check your connection.';
}

class ServerException extends AuthExceptions {
  @override
  String toString() => 'Server error. Please try again later.';
}
