import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/auth/domain/repositories/auth_repository.dart';

class SignUp extends UsecaseWithParams<void, SignUpParams> {
  const SignUp(this._repo);

  final AuthRepository _repo;

  @override
  ResultFuture<void> call(SignUpParams params) => _repo.signUp(
      email: params.email,
      password: params.password,
      fullName: params.fullName);
}

class SignUpParams extends Equatable {
  const SignUpParams(
      {required this.email, required this.password, required this.fullName});

  factory SignUpParams.empty() {
    return const SignUpParams(email: '', password: '', fullName: '');
  }

  final String email;
  final String password;
  final String fullName;

  @override
  List<String> get props => [email, password, fullName];
}
