import 'package:causeries_client/features/users/domain/entities/public_user.dart';

class PublicUserDto {
  final String id;
  final String email;
  final String username;

  const PublicUserDto({
    required this.id,
    required this.email,
    required this.username,
  });

  factory PublicUserDto.fromJson(Map<String, dynamic> json) {
    return PublicUserDto(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      username: (json['username'] ?? json['name'] ?? '').toString(),
    );
  }

  PublicUser toDomain() => PublicUser(id: id, email: email, username: username);
}
