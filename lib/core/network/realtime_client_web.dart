import 'dart:async';

import 'package:causeries_client/core/storage/token_storage.dart';

import 'realtime_connection.dart';

class RealtimeClient implements RealtimeConnection {
  final TokenStorage tokenStorage;
  final String apiBaseUrl;

  final StreamController<Map<String, dynamic>> _controller =
      StreamController<Map<String, dynamic>>.broadcast();

  RealtimeClient({required this.tokenStorage, required this.apiBaseUrl});

  @override
  Stream<Map<String, dynamic>> get stream => _controller.stream;

  bool get isConnected => false;

  @override
  Future<void> connect() async {
    return;
  }

  @override
  Future<void> disconnect() async {
    return;
  }

  void dispose() {
    _controller.close();
  }
}
