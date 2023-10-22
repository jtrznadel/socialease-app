import 'package:social_ease_app/core/enums/update_user.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';

abstract class AuthRepository {
  const AuthRepository();

  ResultFuture<LocalUser> signIn(
      {required String email, required String password});

  ResultFuture<void> signUp(
      {required String email,
      required String password,
      required String fullName});

  ResultFuture<void> forgotPassword(String email);

  ResultFuture<void> updateUser({
    required UpdateUserAction action,
    dynamic userData,
  });
}
