import 'dart:async';

import 'package:causeries_client/core/network/api_client.dart';
import 'package:causeries_client/core/network/realtime_connection.dart';
import 'package:causeries_client/features/authentication/domain/entities/user.dart';
import 'package:causeries_client/features/authentication/domain/repositories/auth_repository.dart';
import 'package:causeries_client/features/guilds/domain/entities/channel.dart';
import 'package:causeries_client/features/guilds/domain/repositories/channels_repository.dart';
import 'package:causeries_client/features/guilds/presentation/viewmodels/channel_messages_controller.dart';
import 'package:causeries_client/features/users/domain/entities/public_user.dart';
import 'package:causeries_client/features/users/domain/repositories/users_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'channel_messages_controller_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ChannelsRepository>(),
  MockSpec<UsersRepository>(),
  MockSpec<AuthRepository>(),
  MockSpec<RealtimeConnection>(),
])
void main() {
  group('ChannelMessagesController', () {
    late MockChannelsRepository channelsRepository;
    late MockUsersRepository usersRepository;
    late MockAuthRepository authRepository;
    late MockRealtimeConnection realtimeClient;
    late ChannelMessagesController controller;

    const channel = Channel(
      id: 'c1',
      name: 'general',
      description: null,
      type: 'text',
    );

    setUp(() {
      channelsRepository = MockChannelsRepository();
      usersRepository = MockUsersRepository();
      authRepository = MockAuthRepository();
      realtimeClient = MockRealtimeConnection();

      controller = ChannelMessagesController(
        channelsRepository: channelsRepository,
        usersRepository: usersRepository,
        authRepository: authRepository,
        realtimeClient: realtimeClient,
      );
    });

    test(
      'loadChannelMessages sorts by createdAt and ignores deleted messages',
      () async {
        when(channelsRepository.listMessages('c1')).thenAnswer(
          (_) async => [
            {
              'id': 'm2',
              'author_id': 'u2',
              'content': 'second',
              'created_at': '2026-04-01T10:00:02Z',
              'deleted_at': null,
            },
            {
              'id': 'm1',
              'author_id': 'u1',
              'content': 'first',
              'created_at': '2026-04-01T10:00:01Z',
              'deleted_at': null,
            },
            {
              'id': 'm_deleted',
              'author_id': 'u1',
              'content': 'gone',
              'created_at': '2026-04-01T10:00:03Z',
              'deleted_at': '2026-04-01T10:00:04Z',
            },
          ],
        );

        when(usersRepository.getUser(any)).thenAnswer(
          (inv) async => PublicUser(
            id: inv.positionalArguments.first as String,
            email: 'x@example.com',
            username: 'user',
          ),
        );

        final err = await controller.loadChannelMessages(channel);
        expect(err, isNull);

        final list = controller.messagesFor(channel);
        expect(list.map((m) => m.id).toList(), ['m1', 'm2']);
        expect(list.first.content, 'first');
        expect(list.last.content, 'second');
      },
    );

    test('sendMessage replaces optimistic message with server id', () async {
      when(
        channelsRepository.sendMessageRaw(channelId: 'c1', content: 'hi'),
      ).thenAnswer(
        (_) async => {
          'id': 'srv1',
          'author_id': 'u1',
          'content': 'hi',
          'created_at': '2026-04-01T10:01:00Z',
        },
      );

      when(usersRepository.getUser('u1')).thenAnswer(
        (_) async => const PublicUser(
          id: 'u1',
          email: 'u1@example.com',
          username: 'alice',
        ),
      );

      final err = await controller.sendMessage(channel: channel, content: 'hi');
      expect(err, isNull);

      final list = controller.messagesFor(channel);
      expect(list.any((m) => m.id == 'srv1'), isTrue);
      expect(list.where((m) => m.id == 'srv1').single.content, 'hi');

      await pumpEventQueue();
      expect(controller.authorLabel('u1'), 'alice');
    });

    test('sendMessage returns error and removes optimistic message', () async {
      when(
        channelsRepository.sendMessageRaw(channelId: 'c1', content: 'hi'),
      ).thenThrow(ApiException(statusCode: 500, message: 'boom'));

      final before = controller.messagesFor(channel).length;
      final err = await controller.sendMessage(channel: channel, content: 'hi');
      expect(err, 'boom');

      final after = controller.messagesFor(channel).length;
      expect(after, before);
    });

    test('init subscribes to realtime and appends incoming messages', () async {
      final streamController = StreamController<Map<String, dynamic>>();
      when(realtimeClient.connect()).thenAnswer((_) async {});
      when(realtimeClient.stream).thenAnswer((_) => streamController.stream);
      when(authRepository.getCurrentUser()).thenAnswer(
        (_) async => User(id: 'me', email: 'me@example.com', username: 'me'),
      );

      await controller.init();
      await pumpEventQueue();

      streamController.add({
        'id': 'm_ws',
        'author_id': 'u2',
        'channel_id': 'c1',
        'content': 'from ws',
        'created_at': '2026-04-01T10:02:00Z',
        'deleted_at': null,
      });

      await pumpEventQueue();

      final list = controller.messagesFor(channel);
      expect(list.any((m) => m.id == 'm_ws'), isTrue);

      await streamController.close();
    });
  });
}
