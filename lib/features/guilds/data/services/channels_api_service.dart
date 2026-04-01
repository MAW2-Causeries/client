import 'package:causeries_client/core/network/api_client.dart';

class ChannelsApiService {
  final ApiClient client;

  ChannelsApiService(this.client);

  Future<Map<String, dynamic>> createChannel({
    required String name,
    required String description,
    required String guildId,
  }) {
    return client.post(
      '/channels',
      body: {
        'name': name,
        'description': description,
        'type': 'text',
        'guild_id': guildId,
      },
    );
  }

  Future<void> deleteChannel(String channelId) {
    return client.delete('/channels/$channelId');
  }
}
