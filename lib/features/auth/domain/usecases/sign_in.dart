import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';
import 'package:social_ease_app/features/auth/domain/repositories/auth_repository.dart';

class SignIn extends FutureUsecaseWithParams<LocalUser, SignInParams> {
  const SignIn(this._repo);

  final AuthRepository _repo;

  @override
  ResultFuture<LocalUser> call(SignInParams params) =>
      _repo.signIn(email: params.email, password: params.password);
}

class SignInParams extends Equatable {
  const SignInParams({required this.email, required this.password});

  factory SignInParams.empty() {
    return const SignInParams(email: '', password: '');
  }

  final String email;
  final String password;

  @override
  List<String> get props => [email, password];
}
