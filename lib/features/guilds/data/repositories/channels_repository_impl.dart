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

  @override
  Future<void> sendMessage({
    required String channelId,
    required String content,
  }) async {
    await api.sendMessage(channelId: channelId, content: content);
  }

  @override
  Future<Map<String, dynamic>> sendMessageRaw({
    required String channelId,
    required String content,
  }) {
    return api.sendMessage(channelId: channelId, content: content);
  }

  @override
  Future<List<Map<String, dynamic>>> listMessages(String channelId) async {
    final res = await api.listMessages(channelId);
    final data = res['data'];
    if (data is! List) return const [];

    return data
        .whereType<Map>()
        .map((e) => e.cast<String, dynamic>())
        .toList(growable: false);
  }
}
