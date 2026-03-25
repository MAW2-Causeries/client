import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:causeries_client/core/storage/token_storage.dart';

class ApiClient {
  final http.Client httpClient;
  final TokenStorage tokenStorage;
  final String baseUrl;

  ApiClient({
    required this.httpClient,
    required this.tokenStorage,
    required this.baseUrl,
  });

  Future<Map<String, dynamic>> get(String path) async {
    Map<String, String> headers = {};

    if (await tokenStorage.hasToken()) {
      headers['Authorization'] = 'Bearer ${await tokenStorage.read()}';
    }

    final response = await httpClient.get(
      Uri.parse('$baseUrl$path'),
      headers: headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};

    if (await tokenStorage.hasToken()) {
      headers['Authorization'] = 'Bearer ${await tokenStorage.read()}';
    }

    final response = await httpClient.post(
      Uri.parse('$baseUrl$path'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};

    if (await tokenStorage.hasToken()) {
      headers['Authorization'] = 'Bearer ${await tokenStorage.read()}';
    }

    final response = await httpClient.put(
      Uri.parse('$baseUrl$path'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }
  }

  Future<void> delete(String path) async {
    Map<String, String> headers = {};

    if (await tokenStorage.hasToken()) {
      headers['Authorization'] = 'Bearer ${await tokenStorage.read()}';
    }

    final response = await httpClient.delete(
      Uri.parse('$baseUrl$path'),
      headers: headers,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException: $statusCode - $message';
}
