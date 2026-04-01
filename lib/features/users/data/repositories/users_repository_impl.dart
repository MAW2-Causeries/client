import 'package:causeries_client/features/users/data/models/public_user_dto.dart';
import 'package:causeries_client/features/users/data/services/users_api_service.dart';
import 'package:causeries_client/features/users/domain/entities/public_user.dart';
import 'package:causeries_client/features/users/domain/repositories/users_repository.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersApiService api;
  final Map<String, PublicUser> _cache = {};

  UsersRepositoryImpl(this.api);

  @override
  Future<PublicUser> getUser(String id) async {
    final cached = _cache[id];
    if (cached != null) return cached;

    final res = await api.getUser(id);
    final user = PublicUserDto.fromJson(res).toDomain();
    _cache[id] = user;
    return user;
  }
}
