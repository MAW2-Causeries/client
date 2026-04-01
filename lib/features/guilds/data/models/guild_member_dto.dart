import 'package:causeries_client/features/guilds/domain/entities/guild_member.dart';

class GuildMemberDto {
  final String id;
  final String username;

  GuildMemberDto({required this.id, required this.username});

  factory GuildMemberDto.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? json['_id'] ?? '').toString();
    final username = (json['username'] ?? json['name'] ?? '').toString();

    return GuildMemberDto(id: id, username: username);
  }

  GuildMember toDomain() => GuildMember(id: id, username: username);
}
