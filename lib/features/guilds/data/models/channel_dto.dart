import 'package:causeries_client/features/guilds/domain/entities/channel.dart';

class ChannelDto {
  final String id;
  final String name;
  final String? description;
  final String type;

  ChannelDto({
    required this.id,
    required this.name,
    this.description,
    required this.type,
  });

  factory ChannelDto.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? '').toString();
    final name = (json['name'] ?? '').toString();
    final description = json['description']?.toString();
    final type = (json['type'] ?? 'text').toString().trim().toLowerCase();

    return ChannelDto(id: id, name: name, description: description, type: type);
  }

  Channel toDomain() =>
      Channel(id: id, name: name, description: description, type: type);
}
