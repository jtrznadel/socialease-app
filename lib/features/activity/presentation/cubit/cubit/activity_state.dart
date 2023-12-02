part of 'activity_cubit.dart';

sealed class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object> get props => [];
}

final class ActivityInitial extends ActivityState {}

class LoadingActivities extends ActivityState {}

class ActivitiesLoaded extends ActivityState {
  const ActivitiesLoaded(this.activities);

  final List<Activity> activities;

  @override
  List<Object> get props => [activities];
}

final class AddingActivity extends ActivityState {}

class ActivityAdded extends ActivityState {}

class ActivityError extends ActivityState {
  const ActivityError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

final class GettingUser extends ActivityState {
  const GettingUser();
}

final class UserLoaded extends ActivityState {
  const UserLoaded(this.user);

  final LocalUser user;

  @override
  List<Object> get props => [user];
}
