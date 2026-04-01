import 'dart:async';

import 'package:causeries_client/core/storage/token_storage.dart';

class RealtimeClient {
  final TokenStorage tokenStorage;
  final String apiBaseUrl;

  final StreamController<Map<String, dynamic>> _controller =
      StreamController<Map<String, dynamic>>.broadcast();

  RealtimeClient({required this.tokenStorage, required this.apiBaseUrl});

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  bool get isConnected => false;

  Future<void> connect() async {
    return;
  }

  Future<void> disconnect() async {
    return;
  }

  void dispose() {
    _controller.close();
  }
}
