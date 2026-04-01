import 'package:causeries_client/features/guilds/domain/entities/channel.dart';

abstract class ChannelsRepository {
  Future<Channel> createChannel({
    required String name,
    required String description,
    required String guildId,
  });

  Future<void> deleteChannel(String channelId);

  Future<void> sendMessage({
    required String channelId,
    required String content,
  });

  Future<Map<String, dynamic>> sendMessageRaw({
    required String channelId,
    required String content,
  });

  Future<List<Map<String, dynamic>>> listMessages(String channelId);
}
