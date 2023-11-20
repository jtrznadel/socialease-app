import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/domain/usecases/add_activity.dart';
import 'package:social_ease_app/features/activity/domain/usecases/get_activities.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';

part 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit({
    required AddActivity addActivity,
    required GetActivities getActivities,
  })  : _addActivity = addActivity,
        _getActivities = getActivities,
        super(ActivityInitial());

  final AddActivity _addActivity;
  final GetActivities _getActivities;

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
}
