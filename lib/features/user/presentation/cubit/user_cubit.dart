import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';
import 'package:social_ease_app/features/user/domain/usecases/get_user_by_id.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetUserById _getUserById;
  UserCubit({required GetUserById getUserById})
      : _getUserById = getUserById,
        super(UserInitial());

  Future<void> getUser(String userId) async {
    if (isClosed) return;
    emit(const GettingUser());
    final result = await _getUserById(userId);
    result.fold(
      (failure) => emit(UserError(failure.errorMessage)),
      (user) => emit(UserLoaded(user)),
    );
  }
}
