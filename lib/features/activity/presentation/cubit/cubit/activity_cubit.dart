import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/enums/activity_status.dart';
import 'package:social_ease_app/core/errors/failures.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/domain/usecases/add_activity.dart';
import 'package:social_ease_app/features/activity/domain/usecases/get_activities.dart';
import 'package:social_ease_app/features/activity/domain/usecases/get_user_by_id.dart';
import 'package:social_ease_app/features/activity/domain/usecases/join_activity.dart';
import 'package:social_ease_app/features/activity/domain/usecases/leave_activity.dart';
import 'package:social_ease_app/features/activity/domain/usecases/remove_activity.dart';
import 'package:social_ease_app/features/activity/domain/usecases/update_activity.dart';
import 'package:social_ease_app/features/activity/domain/usecases/update_activity_status.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';

part 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  final AddActivity _addActivity;
  final RemoveActivity _removeActivity;
  final UpdateActivity _updateActivity;
  final GetActivities _getActivities;
  final GetUserById _getUserById;
  final JoinActivity _joinActivity;
  final LeaveActivity _leaveActivity;
  final UpdateActivityStatus _updateActivityStatus;

  StreamSubscription<Either<Failure, List<Activity>>>? activitiesSubscription;

  ActivityCubit({
    required AddActivity addActivity,
    required RemoveActivity removeActivity,
    required UpdateActivity updateActivity,
    required GetActivities getActivities,
    required GetUserById getUserById,
    required JoinActivity joinActivity,
    required LeaveActivity leaveActivity,
    required UpdateActivityStatus updateActivityStatus,
  })  : _addActivity = addActivity,
        _removeActivity = removeActivity,
        _updateActivity = updateActivity,
        _getActivities = getActivities,
        _getUserById = getUserById,
        _joinActivity = joinActivity,
        _leaveActivity = leaveActivity,
        _updateActivityStatus = updateActivityStatus,
        super(ActivityInitial());

  @override
  Future<void> close() {
    activitiesSubscription?.cancel();
    return super.close();
  }

  Future<void> addActivity(Activity activity) async {
    emit(AddingActivity());
    final result = await _addActivity(activity);
    result.fold(
      (failure) => emit(ActivityError(failure.errorMessage)),
      (_) => emit(ActivityAdded()),
    );
  }

  Future<void> removeActivity(String activityId) async {
    emit(const ActivityRemoving());
    final result = await _removeActivity(activityId);
    result.fold(
      (failure) => emit(ActivityError(failure.errorMessage)),
      (_) => emit(const ActivityRemoved()),
    );
  }

  Future<void> updateActivity(Activity activity) async {
    emit(const UpdatingActivity());
    final result = await _updateActivity(activity);
    result.fold(
      (failure) => emit(ActivityError(failure.errorMessage)),
      (_) => emit(const ActivityUpdated()),
    );
  }

  void getActivities() {
    emit(LoadingActivities());
    activitiesSubscription = _getActivities().listen(
      (result) {
        result.fold(
          (failure) => emit(ActivityError(failure.errorMessage)),
          (activities) => emit(ActivitiesLoaded(activities)),
        );
      },
      onError: (error) {
        emit(ActivityError(error.toString()));
      },
    );
  }

  Future<void> getUser(String userId) async {
    emit(const GettingUser());
    final result = await _getUserById(userId);
    result.fold(
      (failure) => emit(ActivityError(failure.errorMessage)),
      (user) => emit(UserLoaded(user)),
    );
  }

  Future<void> joinActivity({
    required String activityId,
    required String userId,
  }) async {
    emit(const JoiningActivity());
    final result = await _joinActivity(JoinActivityParams(
      activityId: activityId,
      userId: userId,
    ));
    result.fold(
      (failure) => emit(ActivityError(failure.errorMessage)),
      (_) => emit(const JoinedActivity()),
    );
  }

  Future<void> leaveActivity({
    required String activityId,
    required String userId,
  }) async {
    emit(const LeavingActivity());
    final result = await _leaveActivity(LeaveActivityParams(
      activityId: activityId,
      userId: userId,
    ));
    result.fold(
      (failure) => emit(ActivityError(failure.errorMessage)),
      (_) => emit(const LeftActivity()),
    );
  }

  Future<void> updateActivityStatus({
    required ActivityStatus status,
    required String activityId,
  }) async {
    emit(const UpdatingActivityStatus());
    final result = await _updateActivityStatus(
        UpdateActivityStatusParams(activityId: activityId, status: status));
    result.fold(
      (failure) => emit(ActivityError(failure.errorMessage)),
      (_) => emit(const ActivityStatusUpdated()),
    );
  }
}
