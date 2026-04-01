import 'package:causeries_client/features/guilds/domain/entities/guild.dart';

class GuildDto {
  final String id;
  final String name;
  final String? description;

  GuildDto({required this.id, required this.name, this.description});

  factory GuildDto.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? json['_id'] ?? '').toString();
    final name = (json['name'] ?? json['title'] ?? '').toString();
    final description = json['description']?.toString();
    return GuildDto(id: id, name: name, description: description);
  }

  Guild toDomain() => Guild(id: id, name: name, description: description);
}
