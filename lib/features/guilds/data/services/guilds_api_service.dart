import 'package:causeries_client/core/network/api_client.dart';

class GuildsApiService {
  final ApiClient client;

  GuildsApiService(this.client);

  Future<Map<String, dynamic>> createGuild({
    required String name,
    required String description,
  }) {
    return client.post(
      '/guilds',
      body: {'name': name, 'description': description},
    );
  }

  Future<Map<String, dynamic>> listGuilds() async {
    final res = await client.get('/guilds');
    return res;
  }

  Future<Map<String, dynamic>> getGuild(String id) {
    return client.get('/guilds/$id');
  }

  Future<void> deleteGuild(String id) {
    return client.delete('/guilds/$id');
  }

  Future<Map<String, dynamic>> listChannels(String guildId) async {
    final res = await client.get('/guilds/$guildId/channels');
    return res;
  }

  Future<Map<String, dynamic>> listMembers(String guildId) async {
    final res = await client.get('/guilds/$guildId/members');
    return res;
  }
}
