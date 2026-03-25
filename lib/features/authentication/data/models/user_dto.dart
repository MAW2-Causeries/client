import 'package:causeries_client/features/authentication/domain/entities/user.dart';

class UserDto {
  final String id;
  final String email;
  final String name;
  final String avatarUrl;

  UserDto({
    required this.id,
    required this.email,
    required this.name,
    required this.avatarUrl,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatar_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name, 'avatar_url': avatarUrl};
  }

  User toDomain() {
    return User(id: id, email: email, username: name, avatarUrl: avatarUrl);
  }
}
