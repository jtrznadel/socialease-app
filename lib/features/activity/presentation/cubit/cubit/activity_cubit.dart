import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/domain/usecases/add_activity.dart';
import 'package:social_ease_app/features/activity/domain/usecases/get_activities.dart';
import 'package:social_ease_app/features/activity/domain/usecases/get_user_by_id.dart';
import 'package:social_ease_app/features/activity/domain/usecases/join_activity.dart';
import 'package:social_ease_app/features/activity/domain/usecases/leave_activity.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';

part 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit({
    required AddActivity addActivity,
    required GetActivities getActivities,
    required GetUserById getUserById,
    required JoinActivity joinActivity,
    required LeaveActivity leaveActivity,
  })  : _addActivity = addActivity,
        _getActivities = getActivities,
        _getUserById = getUserById,
        _joinActivity = joinActivity,
        _leaveActivity = leaveActivity,
        super(ActivityInitial());

  final AddActivity _addActivity;
  final GetActivities _getActivities;
  final GetUserById _getUserById;
  final JoinActivity _joinActivity;
  final LeaveActivity _leaveActivity;

  Future<void> addActivity(Activity activity) async {
    emit(AddingActivity());
    final result = await _addActivity(activity);
    result.fold(
      (failure) => emit(ActivityError(failure.errorMessage)),
      (_) => emit(ActivityAdded()),
    );
  }

  Future<void> getActivities() async {
    emit(LoadingActivities());
    final result = await _getActivities();
    result.fold(
      (failure) => emit(ActivityError(failure.errorMessage)),
      (activities) => emit(ActivitiesLoaded(activities)),
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

  void resetState() {
    emit(ActivityInitial());
  }
}
