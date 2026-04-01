import 'package:causeries_client/features/guilds/domain/entities/channel.dart';

abstract class ChannelsRepository {
  Future<Channel> createChannel({
    required String name,
    required String description,
    required String guildId,
  });

  Future<void> deleteChannel(String channelId);
}
