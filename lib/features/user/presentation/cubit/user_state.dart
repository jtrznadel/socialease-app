part of 'user_cubit.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

class UserError extends UserState {
  const UserError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

final class GettingUser extends UserState {
  const GettingUser();
}

final class UserLoaded extends UserState {
  const UserLoaded(this.user);

  final LocalUser user;

  @override
  List<Object> get props => [user];
}
