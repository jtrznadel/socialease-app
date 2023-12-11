import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/domain/repositories/activity_repository.dart';

class LeaveActivity extends FutureUsecaseWithParams<void, LeaveActivityParams> {
  const LeaveActivity(this._repo);

  final ActivityRepository _repo;

  @override
  ResultFuture<void> call(LeaveActivityParams params) =>
      _repo.leaveActivity(activityId: params.activityId, userId: params.userId);
}

class LeaveActivityParams extends Equatable {
  const LeaveActivityParams({required this.activityId, required this.userId});

  final String activityId;
  final String userId;

  @override
  List<String> get props => [activityId, userId];
}
