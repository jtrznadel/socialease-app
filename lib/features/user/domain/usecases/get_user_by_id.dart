import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';
import 'package:social_ease_app/features/user/domain/repositories/user_repo.dart';

class GetUserById extends FutureUsecaseWithParams<LocalUser, String> {
  const GetUserById(this._repo);
  final UserRepo _repo;

  @override
  ResultFuture<LocalUser> call(String params) => _repo.getUserById(params);
}
