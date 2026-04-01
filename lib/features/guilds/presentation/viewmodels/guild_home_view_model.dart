import 'package:causeries_client/features/guilds/domain/entities/channel.dart';
import 'package:causeries_client/features/guilds/domain/entities/guild.dart';
import 'package:causeries_client/features/guilds/domain/entities/guild_member.dart';
import 'package:causeries_client/features/guilds/domain/repositories/guilds_repository.dart';
import 'package:causeries_client/core/network/api_client.dart';
import 'package:flutter/foundation.dart';

class GuildHomeViewModel extends ChangeNotifier {
  final GuildsRepository _guildsRepository;

  GuildHomeViewModel(this._guildsRepository);

  bool _initialized = false;
  bool _isLoadingGuilds = false;
  bool _isLoadingDetails = false;
  String? _errorMessage;

  List<Guild> _guilds = const [];
  Guild? _selectedGuild;
  List<Channel> _channels = const [];
  List<GuildMember> _members = const [];
  Channel? _selectedChannel;

  bool get isLoadingGuilds => _isLoadingGuilds;
  bool get isLoadingDetails => _isLoadingDetails;
  String? get errorMessage => _errorMessage;

  List<Guild> get guilds => _guilds;
  Guild? get selectedGuild => _selectedGuild;
  List<Channel> get channels => _channels;
  List<GuildMember> get members => _members;
  Channel? get selectedChannel => _selectedChannel;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    await refreshGuilds();
  }

  Future<void> refreshGuilds() async {
    _isLoadingGuilds = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _guilds = await _guildsRepository.listGuilds();

      if (_guilds.isEmpty) {
        _selectedGuild = null;
        _channels = const [];
        _members = const [];
        _selectedChannel = null;
        return;
      }

      final currentId = _selectedGuild?.id;
      final next = currentId == null
          ? _guilds.first
          : _guilds.firstWhere(
              (g) => g.id == currentId,
              orElse: () => _guilds.first,
            );

      await selectGuild(next);
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Failed to load guilds.';
      }
    } finally {
      _isLoadingGuilds = false;
      notifyListeners();
    }
  }

  Future<void> selectGuild(Guild guild) async {
    _selectedGuild = guild;
    _selectedChannel = null;
    _channels = const [];
    _members = const [];
    _isLoadingDetails = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _guildsRepository.listChannels(guild.id),
        _guildsRepository.listMembers(guild.id),
      ]);
      _channels = (results[0] as List<Channel>);
      _members = (results[1] as List<GuildMember>);

      _selectedChannel = _channels.isEmpty ? null : _channels.first;
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Failed to load guild details.';
      }
    } finally {
      _isLoadingDetails = false;
      notifyListeners();
    }
  }

  void selectChannel(Channel channel) {
    _selectedChannel = channel;
    notifyListeners();
  }

  void onGuildCreated(Guild guild) {
    _guilds = [..._guilds, guild];
    notifyListeners();
    selectGuild(guild);
  }

  void onChannelCreated(Channel channel) {
    if (_selectedGuild == null) return;
    _channels = [..._channels, channel];
    _selectedChannel = channel;
    notifyListeners();
  }

  void onChannelDeleted(String channelId) {
    _channels = _channels.where((c) => c.id != channelId).toList();
    if (_selectedChannel?.id == channelId) {
      _selectedChannel = _channels.isEmpty ? null : _channels.first;
    }
    notifyListeners();
  }
}
