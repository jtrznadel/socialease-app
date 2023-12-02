import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/domain/repositories/activity_repository.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';

class GetUserById extends FutureUsecaseWithParams<LocalUser, String> {
  const GetUserById(this._repo);
  final ActivityRepository _repo;

  @override
  ResultFuture<LocalUser> call(String params) => _repo.getUserById(params);
}
