import 'package:causeries_client/features/authentication/domain/entities/user.dart';

class UserDto {
  final String id;
  final String email;
  final String name;

  UserDto({required this.id, required this.email, required this.name});

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['user']?['id'] as String,
      email: json['user']?['email'] as String,
      name: json['user']?['username'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {'id': id, 'email': email, 'username': name},
    };
  }

  User toDomain() {
    return User(id: id, email: email, username: name);
  }
}
