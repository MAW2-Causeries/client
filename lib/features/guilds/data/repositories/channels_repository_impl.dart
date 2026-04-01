import 'package:causeries_client/features/guilds/data/models/channel_dto.dart';
import 'package:causeries_client/features/guilds/data/services/channels_api_service.dart';
import 'package:causeries_client/features/guilds/domain/entities/channel.dart';
import 'package:causeries_client/features/guilds/domain/repositories/channels_repository.dart';

class ChannelsRepositoryImpl implements ChannelsRepository {
  final ChannelsApiService api;

  ChannelsRepositoryImpl(this.api);

  @override
  Future<Channel> createChannel({
    required String name,
    required String description,
    required String guildId,
  }) async {
    final res = await api.createChannel(
      name: name,
      description: description,
      guildId: guildId,
    );

    return ChannelDto.fromJson(res).toDomain();
  }

  @override
  Future<void> deleteChannel(String channelId) {
    return api.deleteChannel(channelId);
  }
}
