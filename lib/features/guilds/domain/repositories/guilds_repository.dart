import 'package:causeries_client/features/guilds/domain/entities/channel.dart';
import 'package:causeries_client/features/guilds/domain/entities/guild.dart';
import 'package:causeries_client/features/guilds/domain/entities/guild_member.dart';

abstract class GuildsRepository {
  Future<List<Guild>> listGuilds();
  Future<Guild> getGuild(String id);
  Future<Guild> createGuild({
    required String name,
    required String description,
  });
  Future<void> deleteGuild(String id);
  Future<List<Channel>> listChannels(String guildId);
  Future<List<GuildMember>> listMembers(String guildId);
}
