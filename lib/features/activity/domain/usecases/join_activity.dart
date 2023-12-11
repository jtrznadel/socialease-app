import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/domain/repositories/activity_repository.dart';

class JoinActivity extends FutureUsecaseWithParams<void, JoinActivityParams> {
  const JoinActivity(this._repo);

  final ActivityRepository _repo;

  @override
  ResultFuture<void> call(JoinActivityParams params) =>
      _repo.joinActivity(activityId: params.activityId, userId: params.userId);
}

class JoinActivityParams extends Equatable {
  const JoinActivityParams({required this.activityId, required this.userId});

  final String activityId;
  final String userId;

  @override
  List<String> get props => [activityId, userId];
}
