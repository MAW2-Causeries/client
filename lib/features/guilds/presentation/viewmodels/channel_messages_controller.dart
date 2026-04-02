import 'dart:async';

import 'package:causeries_client/core/network/api_client.dart';
import 'package:causeries_client/core/network/realtime_connection.dart';
import 'package:causeries_client/features/authentication/domain/repositories/auth_repository.dart';
import 'package:causeries_client/features/guilds/domain/entities/channel.dart';
import 'package:causeries_client/features/guilds/domain/repositories/channels_repository.dart';
import 'package:causeries_client/features/guilds/presentation/models/chat_message.dart';
import 'package:causeries_client/features/users/domain/repositories/users_repository.dart';
import 'package:flutter/foundation.dart';

class ChannelMessagesController extends ChangeNotifier {
  final ChannelsRepository channelsRepository;
  final UsersRepository usersRepository;
  final AuthRepository authRepository;
  final RealtimeConnection realtimeClient;

  final Map<String, List<ChatMessage>> _messagesByChannelId = {};
  final Set<String> _loadingMessageChannelIds = {};

  final Map<String, String> _usernameByUserId = {'system': 'System'};
  final Set<String> _loadingUserIds = {};

  StreamSubscription<Map<String, dynamic>>? _realtimeSub;
  String? _currentUserId;

  bool _initialized = false;

  ChannelMessagesController({
    required this.channelsRepository,
    required this.usersRepository,
    required this.authRepository,
    required this.realtimeClient,
  });

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    unawaited(_loadCurrentUserId());
    unawaited(_subscribeRealtime());
  }

  @override
  void dispose() {
    final sub = _realtimeSub;
    _realtimeSub = null;
    if (sub != null) {
      unawaited(sub.cancel());
    }
    super.dispose();
  }

  bool isLoadingMessages(Channel channel) {
    return _loadingMessageChannelIds.contains(channel.id);
  }

  List<ChatMessage> messagesFor(Channel channel) {
    return _messagesByChannelId.putIfAbsent(channel.id, () {
      return [
        ChatMessage(
          id: 'm1_${channel.id}',
          authorId: 'system',
          content: 'Welcome to #${channel.name}',
          createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
        ),
      ];
    });
  }

  String authorLabel(String authorId) {
    if (authorId == 'system') return 'System';
    if (_currentUserId != null && authorId == _currentUserId) return 'You';
    final cached = _usernameByUserId[authorId];
    if (cached != null && cached.isNotEmpty) return cached;
    if (_loadingUserIds.contains(authorId)) return '...';
    return 'Unknown';
  }

  void removeChannel(String channelId) {
    _messagesByChannelId.remove(channelId);
    _loadingMessageChannelIds.remove(channelId);
    notifyListeners();
  }

  Future<String?> loadChannelMessages(Channel channel) async {
    if (_loadingMessageChannelIds.contains(channel.id)) return null;

    _loadingMessageChannelIds.add(channel.id);
    notifyListeners();

    try {
      final rows = await channelsRepository.listMessages(channel.id);
      final parsed = <ChatMessage>[];
      for (final r in rows) {
        final msg = _tryParseMessage(r);
        if (msg == null) continue;
        unawaited(_prefetchUser(msg.authorId));
        parsed.add(msg);
      }

      parsed.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      _messagesByChannelId[channel.id] = parsed;
      notifyListeners();
      return null;
    } catch (e) {
      if (e is ApiException) return e.message;
      return 'Failed to load messages.';
    } finally {
      _loadingMessageChannelIds.remove(channel.id);
      notifyListeners();
    }
  }

  Future<String?> sendMessage({
    required Channel channel,
    required String content,
  }) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return null;

    final tempId = 'm_${DateTime.now().microsecondsSinceEpoch}';
    final optimistic = ChatMessage(
      id: tempId,
      authorId: _currentUserId ?? 'you',
      content: trimmed,
      createdAt: DateTime.now(),
    );

    messagesFor(channel).add(optimistic);
    notifyListeners();

    try {
      final created = await channelsRepository.sendMessageRaw(
        channelId: channel.id,
        content: trimmed,
      );
      final id = created['id']?.toString();
      final authorId = created['author_id']?.toString();
      final createdAtRaw = created['created_at']?.toString();

      final createdAt =
          DateTime.tryParse(createdAtRaw ?? '') ?? optimistic.createdAt;
      if (authorId != null) {
        unawaited(_prefetchUser(authorId));
      }

      if (id != null && id.isNotEmpty) {
        final list = messagesFor(channel);
        _messagesByChannelId[channel.id] = list
            .map(
              (m) => m.id == tempId
                  ? ChatMessage(
                      id: id,
                      authorId: (authorId == null || authorId.isEmpty)
                          ? optimistic.authorId
                          : authorId,
                      content: optimistic.content,
                      createdAt: createdAt,
                    )
                  : m,
            )
            .toList();
        notifyListeners();
      }

      return null;
    } catch (e) {
      final list = messagesFor(channel);
      _messagesByChannelId[channel.id] = list
          .where((m) => m.id != tempId)
          .toList(growable: false);
      notifyListeners();

      if (e is ApiException) return e.message;
      return 'Failed to send message.';
    }
  }

  Future<void> _loadCurrentUserId() async {
    try {
      final user = await authRepository.getCurrentUser();
      _currentUserId = user?.id;
    } catch (_) {
      return;
    }
  }

  Future<void> _subscribeRealtime() async {
    if (kIsWeb) return;
    try {
      await realtimeClient.connect();
    } catch (_) {
      return;
    }

    await _realtimeSub?.cancel();
    _realtimeSub = realtimeClient.stream.listen(_onRealtimeMessage);
  }

  void _onRealtimeMessage(Map<String, dynamic> json) {
    final channelId = json['channel_id']?.toString();
    final id = json['id']?.toString();
    final authorId = json['author_id']?.toString();
    if (channelId == null || channelId.isEmpty) return;
    if (id == null || id.isEmpty) return;
    if (_currentUserId != null && authorId == _currentUserId) return;

    final msg = _tryParseMessage(json);
    if (msg == null) return;

    unawaited(_prefetchUser(msg.authorId));

    final existing = _messagesByChannelId[channelId] ?? const [];
    _messagesByChannelId[channelId] = [...existing, msg];
    notifyListeners();
  }

  ChatMessage? _tryParseMessage(Map<String, dynamic> json) {
    if (json['deleted_at'] != null) return null;

    final id = json['id']?.toString();
    final authorId = json['author_id']?.toString();
    final content = json['content']?.toString();
    final createdAtRaw = json['created_at']?.toString();

    if (id == null || id.isEmpty) return null;
    if (content == null) return null;
    if (createdAtRaw == null || createdAtRaw.isEmpty) return null;

    final createdAt = DateTime.tryParse(createdAtRaw) ?? DateTime.now();
    return ChatMessage(
      id: id,
      authorId: (authorId == null || authorId.isEmpty) ? 'unknown' : authorId,
      content: content,
      createdAt: createdAt,
    );
  }

  Future<void> _prefetchUser(String id) async {
    if (id.isEmpty) return;
    if (id == 'system' || id == 'unknown') return;
    if (_usernameByUserId.containsKey(id)) return;
    if (_loadingUserIds.contains(id)) return;
    if (_currentUserId != null && id == _currentUserId) return;

    _loadingUserIds.add(id);
    notifyListeners();

    try {
      final user = await usersRepository.getUser(id);
      _usernameByUserId[id] = user.username;
    } catch (_) {
      return;
    } finally {
      _loadingUserIds.remove(id);
      notifyListeners();
    }
  }
}
