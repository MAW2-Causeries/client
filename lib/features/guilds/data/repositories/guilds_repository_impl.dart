import 'package:causeries_client/features/guilds/data/models/channel_dto.dart';
import 'package:causeries_client/features/guilds/data/models/guild_dto.dart';
import 'package:causeries_client/features/guilds/data/models/guild_member_dto.dart';
import 'package:causeries_client/features/guilds/data/services/guilds_api_service.dart';
import 'package:causeries_client/features/guilds/domain/entities/channel.dart';
import 'package:causeries_client/features/guilds/domain/entities/guild.dart';
import 'package:causeries_client/features/guilds/domain/entities/guild_member.dart';
import 'package:causeries_client/features/guilds/domain/repositories/guilds_repository.dart';

class GuildsRepositoryImpl implements GuildsRepository {
  final GuildsApiService api;

  GuildsRepositoryImpl(this.api);

  @override
  Future<List<Guild>> listGuilds() async {
    final res = await api.listGuilds();
    final data = res['data'];

    return (data as List).map((e) {
      return GuildDto.fromJson((e as Map).cast<String, dynamic>()).toDomain();
    }).toList();
  }

  @override
  Future<Guild> getGuild(String id) async {
    final res = await api.getGuild(id);
    return GuildDto.fromJson(res).toDomain();
  }

  @override
  Future<Guild> createGuild({
    required String name,
    required String description,
  }) async {
    final res = await api.createGuild(name: name, description: description);
    return GuildDto.fromJson(res).toDomain();
  }

  @override
  Future<void> deleteGuild(String id) {
    return api.deleteGuild(id);
  }

  @override
  Future<List<Channel>> listChannels(String guildId) async {
    final res = await api.listChannels(guildId);
    final data = res['data'];

    return (data as List).map((e) {
      return ChannelDto.fromJson((e as Map).cast<String, dynamic>()).toDomain();
    }).toList();
  }

  @override
  Future<List<GuildMember>> listMembers(String guildId) async {
    final res = await api.listMembers(guildId);
    final data = res['data'];

    return (data as List).map((e) {
      return GuildMemberDto.fromJson(
        (e as Map).cast<String, dynamic>(),
      ).toDomain();
    }).toList();
  }
}
