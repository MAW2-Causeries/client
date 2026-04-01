abstract class RealtimeConnection {
  Stream<Map<String, dynamic>> get stream;
  Future<void> connect();
  Future<void> disconnect();
}
