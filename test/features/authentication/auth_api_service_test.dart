import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:causeries_client/core/network/api_client.dart';
import 'package:causeries_client/features/authentication/data/services/auth_api_service.dart';
import 'package:causeries_client/features/authentication/domain/errors/auth_exceptions.dart';
import 'auth_api_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ApiClient>()])
void main() {
  group('AuthApiService', () {
    late MockApiClient mockApiClient;
    late AuthApiService authApiService;

    setUp(() {
      mockApiClient = MockApiClient();
      authApiService = AuthApiService(mockApiClient);
    });

    group('login', () {
      test('returns user data on successful login', () async {
        final expectedResponse = {'id': '1', 'email': 'test@example.com'};

        when(
          mockApiClient.post(
            '/sessions',
            body: {'email': 'test@example.com', 'password': 'password123'},
          ),
        ).thenAnswer((_) async => expectedResponse);

        final result = await authApiService.login(
          'test@example.com',
          'password123',
        );

        expect(result, expectedResponse);
        verify(
          mockApiClient.post(
            '/sessions',
            body: {'email': 'test@example.com', 'password': 'password123'},
          ),
        ).called(1);
      });

      test('throws InvalidCredentialsException on 401 status', () async {
        when(
          mockApiClient.post('/sessions', body: anyNamed('body')),
        ).thenThrow(ApiException(statusCode: 401, message: 'Unauthorized'));

        expect(
          () => authApiService.login('test@example.com', 'wrong'),
          throwsA(isA<InvalidCredentialsException>()),
        );
      });

      test('rethrows other ApiExceptions', () async {
        when(
          mockApiClient.post('/sessions', body: anyNamed('body')),
        ).thenThrow(ApiException(statusCode: 500, message: 'Server error'));

        expect(
          () => authApiService.login('test@example.com', 'password'),
          throwsA(isA<ApiException>()),
        );
      });
    });

    group('register', () {
      test('posts to /users with email, username, and password', () async {
        when(
          mockApiClient.post(
            '/users',
            body: {
              'email': 'test@example.com',
              'username': 'tester',
              'password': 'password123',
            },
          ),
        ).thenAnswer((_) async => <String, dynamic>{});

        await authApiService.register(
          'test@example.com',
          'tester',
          'password123',
        );

        verify(
          mockApiClient.post(
            '/users',
            body: {
              'email': 'test@example.com',
              'username': 'tester',
              'password': 'password123',
            },
          ),
        ).called(1);
      });

      test('throws UserAlreadyExistsException on 403 status', () async {
        when(
          mockApiClient.post('/users', body: anyNamed('body')),
        ).thenThrow(ApiException(statusCode: 403, message: 'Forbidden'));

        expect(
          () => authApiService.register('test@example.com', 'tester', 'pass'),
          throwsA(isA<UserAlreadyExistsException>()),
        );
      });
    });

    group('logout', () {
      test('calls delete on /sessions endpoint', () async {
        when(mockApiClient.delete('/sessions')).thenAnswer((_) async {});

        await authApiService.logout();

        verify(mockApiClient.delete('/sessions')).called(1);
      });
    });

    group('getCurrentUser', () {
      test('returns current user data', () async {
        final expectedUser = {
          'id': '1',
          'email': 'test@example.com',
          'name': 'John',
        };
        when(
          mockApiClient.get('/sessions'),
        ).thenAnswer((_) async => expectedUser);

        final result = await authApiService.getCurrentUser();

        expect(result, expectedUser);
        verify(mockApiClient.get('/sessions')).called(1);
      });
    });
  });
}
