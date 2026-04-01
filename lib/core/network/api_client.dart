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

  Future<Map<String, String>> _headers({bool json = false}) async {
    final headers = <String, String>{};
    if (json) headers['Content-Type'] = 'application/json';

    if (await tokenStorage.hasToken()) {
      final token = await tokenStorage.read();
      if (token != null && token.trim().isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Map<String, dynamic> _decodeBody(String body) {
    final decoded = jsonDecode(body);
    if (decoded is Map) {
      return decoded.cast<String, dynamic>();
    }

    return {'data': decoded}.cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> get(String path) async {
    final headers = await _headers();

    final response = await httpClient.get(
      Uri.parse('$baseUrl$path'),
      headers: headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }

      return _decodeBody(response.body);
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
    final headers = await _headers(json: true);

    final response = await httpClient.post(
      Uri.parse('$baseUrl$path'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }

      return _decodeBody(response.body);
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
    final headers = await _headers(json: true);

    final response = await httpClient.put(
      Uri.parse('$baseUrl$path'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }

      return _decodeBody(response.body);
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }
  }

  Future<void> delete(String path) async {
    final headers = await _headers();

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
