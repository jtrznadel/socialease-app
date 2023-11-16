import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';
import 'package:social_ease_app/features/chat/domain/repositories/chat_repository.dart';

class GetUserById extends FutureUsecaseWithParams<LocalUser, String> {
  const GetUserById(this._repo);

  final ChatRepository _repo;

  @override
  ResultFuture<LocalUser> call(String params) => _repo.getUserById(params);
}
