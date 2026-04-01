import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:causeries_client/core/storage/token_storage.dart';

import 'realtime_connection.dart';

class RealtimeClient implements RealtimeConnection {
  final TokenStorage tokenStorage;
  final String apiBaseUrl;

  final StreamController<Map<String, dynamic>> _controller =
      StreamController<Map<String, dynamic>>.broadcast();

  WebSocket? _socket;
  StreamSubscription? _socketSub;

  RealtimeClient({required this.tokenStorage, required this.apiBaseUrl});

  @override
  Stream<Map<String, dynamic>> get stream => _controller.stream;

  bool get isConnected => _socket != null;

  @override
  Future<void> connect() async {
    if (_socket != null) return;
    if (apiBaseUrl.trim().isEmpty) return;

    final hasToken = await tokenStorage.hasToken();
    if (!hasToken) return;
    final token = await tokenStorage.read();
    if (token == null || token.trim().isEmpty) return;

    final apiUri = Uri.parse(apiBaseUrl);
    final wsScheme = apiUri.scheme == 'https' ? 'wss' : 'ws';
    final basePath = apiUri.path.endsWith('/')
        ? apiUri.path.substring(0, apiUri.path.length - 1)
        : apiUri.path;
    final wsUri = apiUri.replace(scheme: wsScheme, path: '$basePath/ws');

    final ws = await WebSocket.connect(
      wsUri.toString(),
      headers: {'Authorization': 'Bearer $token'},
    );

    _socket = ws;
    _socketSub = ws.listen(
      (event) {
        try {
          final raw = event is String ? event : event.toString();
          final decoded = jsonDecode(raw);
          if (decoded is! Map) return;
          _controller.add(decoded.cast<String, dynamic>());
        } catch (_) {
          return;
        }
      },
      onDone: () {
        _socketSub?.cancel();
        _socketSub = null;
        _socket = null;
      },
      onError: (_) {
        _socketSub?.cancel();
        _socketSub = null;
        _socket = null;
      },
      cancelOnError: true,
    );
  }

  @override
  Future<void> disconnect() async {
    try {
      await _socketSub?.cancel();
    } catch (_) {}
    _socketSub = null;

    try {
      await _socket?.close();
    } catch (_) {}
    _socket = null;
  }

  void dispose() {
    unawaited(disconnect());
    _controller.close();
  }
}
