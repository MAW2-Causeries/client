import 'package:causeries_client/core/network/api_client.dart';

class UsersApiService {
  final ApiClient client;

  UsersApiService(this.client);

  Future<Map<String, dynamic>> getUser(String id) {
    return client.get('/users/$id');
  }
}
