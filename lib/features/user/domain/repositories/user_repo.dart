import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';

abstract class UserRepo {
  const UserRepo();

  ResultFuture<LocalUser> getUserById(String userId);
}
