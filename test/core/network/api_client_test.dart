import 'dart:convert';

import 'package:causeries_client/core/network/api_client.dart';
import 'package:causeries_client/core/storage/token_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'api_client_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>(), MockSpec<TokenStorage>()])
void main() {
  group('ApiClient', () {
    late MockClient mockHttpClient;
    late MockTokenStorage mockTokenStorage;
    late ApiClient apiClient;

    setUp(() {
      mockHttpClient = MockClient();
      mockTokenStorage = MockTokenStorage();
      when(mockTokenStorage.hasToken()).thenAnswer((_) async => false);
      when(mockTokenStorage.read()).thenAnswer((_) async => null);
      apiClient = ApiClient(
        httpClient: mockHttpClient,
        tokenStorage: mockTokenStorage,
        baseUrl: 'https://api.example.com',
      );
    });

    group('get', () {
      test('returns decoded json when response is successful', () async {
        when(
          mockHttpClient.get(
            Uri.parse('https://api.example.com/users'),
            headers: {},
          ),
        ).thenAnswer((_) async => http.Response('{"id":1}', 200));

        final result = await apiClient.get('/users');

        expect(result, {'id': 1});
      });

      test('throws ApiException when response is not successful', () async {
        when(
          mockHttpClient.get(
            Uri.parse('https://api.example.com/users'),
            headers: {},
          ),
        ).thenAnswer((_) async => http.Response('Not found', 404));

        expect(
          () => apiClient.get('/users'),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'statusCode', 404)
                .having((e) => e.message, 'message', 'Not found'),
          ),
        );
      });

      test('adds Authorization header when token exists', () async {
        when(mockTokenStorage.hasToken()).thenAnswer((_) async => true);
        when(mockTokenStorage.read()).thenAnswer((_) async => 'token-123');
        when(
          mockHttpClient.get(
            Uri.parse('https://api.example.com/users'),
            headers: {'Authorization': 'Bearer token-123'},
          ),
        ).thenAnswer((_) async => http.Response('{"id":1}', 200));

        final result = await apiClient.get('/users');

        expect(result, {'id': 1});
      });
    });

    group('post', () {
      test('sends json body and returns decoded json', () async {
        when(
          mockHttpClient.post(
            Uri.parse('https://api.example.com/users'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'name': 'John'}),
          ),
        ).thenAnswer((_) async => http.Response('{"created":true}', 201));

        final result = await apiClient.post('/users', body: {'name': 'John'});

        expect(result, {'created': true});
      });

      test('throws ApiException when response is not successful', () async {
        when(
          mockHttpClient.post(
            Uri.parse('https://api.example.com/users'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'name': 'John'}),
          ),
        ).thenAnswer((_) async => http.Response('Bad request', 400));

        expect(
          () => apiClient.post('/users', body: {'name': 'John'}),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'statusCode', 400)
                .having((e) => e.message, 'message', 'Bad request'),
          ),
        );
      });

      test('adds Authorization header when token exists', () async {
        when(mockTokenStorage.hasToken()).thenAnswer((_) async => true);
        when(mockTokenStorage.read()).thenAnswer((_) async => 'token-123');
        when(
          mockHttpClient.post(
            Uri.parse('https://api.example.com/users'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer token-123',
            },
            body: jsonEncode({'name': 'John'}),
          ),
        ).thenAnswer((_) async => http.Response('{"created":true}', 201));

        final result = await apiClient.post('/users', body: {'name': 'John'});

        expect(result, {'created': true});
      });
    });

    group('put', () {
      test('sends json body and returns decoded json', () async {
        when(
          mockHttpClient.put(
            Uri.parse('https://api.example.com/users/1'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'name': 'Jane'}),
          ),
        ).thenAnswer((_) async => http.Response('{"updated":true}', 200));

        final result = await apiClient.put('/users/1', body: {'name': 'Jane'});

        expect(result, {'updated': true});
      });

      test('throws ApiException when response is not successful', () async {
        when(
          mockHttpClient.put(
            Uri.parse('https://api.example.com/users/1'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'name': 'Jane'}),
          ),
        ).thenAnswer((_) async => http.Response('Conflict', 409));

        expect(
          () => apiClient.put('/users/1', body: {'name': 'Jane'}),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'statusCode', 409)
                .having((e) => e.message, 'message', 'Conflict'),
          ),
        );
      });

      test('adds Authorization header when token exists', () async {
        when(mockTokenStorage.hasToken()).thenAnswer((_) async => true);
        when(mockTokenStorage.read()).thenAnswer((_) async => 'token-123');
        when(
          mockHttpClient.put(
            Uri.parse('https://api.example.com/users/1'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer token-123',
            },
            body: jsonEncode({'name': 'Jane'}),
          ),
        ).thenAnswer((_) async => http.Response('{"updated":true}', 200));

        final result = await apiClient.put('/users/1', body: {'name': 'Jane'});

        expect(result, {'updated': true});
      });
    });

    group('delete', () {
      test('completes when response is successful', () async {
        when(
          mockHttpClient.delete(
            Uri.parse('https://api.example.com/users/1'),
            headers: {},
          ),
        ).thenAnswer((_) async => http.Response('', 204));

        await apiClient.delete('/users/1');

        verify(
          mockHttpClient.delete(
            Uri.parse('https://api.example.com/users/1'),
            headers: {},
          ),
        ).called(1);
      });

      test('throws ApiException when response is not successful', () async {
        when(
          mockHttpClient.delete(
            Uri.parse('https://api.example.com/users/1'),
            headers: {},
          ),
        ).thenAnswer((_) async => http.Response('Unauthorized', 401));

        expect(
          () => apiClient.delete('/users/1'),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'statusCode', 401)
                .having((e) => e.message, 'message', 'Unauthorized'),
          ),
        );
      });

      test('adds Authorization header when token exists', () async {
        when(mockTokenStorage.hasToken()).thenAnswer((_) async => true);
        when(mockTokenStorage.read()).thenAnswer((_) async => 'token-123');
        when(
          mockHttpClient.delete(
            Uri.parse('https://api.example.com/users/1'),
            headers: {'Authorization': 'Bearer token-123'},
          ),
        ).thenAnswer((_) async => http.Response('', 204));

        await apiClient.delete('/users/1');

        verify(
          mockHttpClient.delete(
            Uri.parse('https://api.example.com/users/1'),
            headers: {'Authorization': 'Bearer token-123'},
          ),
        ).called(1);
      });
    });

    test('ApiException toString includes status code and message', () {
      final exception = ApiException(statusCode: 418, message: 'I am a teapot');

      expect(exception.toString(), 'ApiException: 418 - I am a teapot');
    });
  });
}
