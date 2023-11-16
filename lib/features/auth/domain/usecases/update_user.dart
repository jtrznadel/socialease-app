import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/enums/update_user.dart';
import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/auth/domain/repositories/auth_repository.dart';

class UpdateUser extends FutureUsecaseWithParams<void, UpdateUserParams> {
  UpdateUser(this._repo);

  final AuthRepository _repo;

  @override
  ResultFuture<void> call(UpdateUserParams params) =>
      _repo.updateUser(action: params.action, userData: params.userdata);
}

class UpdateUserParams extends Equatable {
  const UpdateUserParams({required this.action, required this.userdata});

  factory UpdateUserParams.empty() {
    return const UpdateUserParams(
        action: UpdateUserAction.displayName, userdata: '');
  }

  final UpdateUserAction action;
  final dynamic userdata;

  @override
  List<dynamic> get props => [action, userdata];
}
