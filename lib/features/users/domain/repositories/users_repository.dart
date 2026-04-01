import 'package:causeries_client/features/users/domain/entities/public_user.dart';

abstract class UsersRepository {
  Future<PublicUser> getUser(String id);
}
