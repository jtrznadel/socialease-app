import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/domain/repositories/activity_repository.dart';

class CompleteActivity
    extends FutureUsecaseWithParams<void, CompleteActivityParams> {
  const CompleteActivity(this._repo);

  final ActivityRepository _repo;

  @override
  ResultFuture<void> call(CompleteActivityParams params) => _repo
      .completeActivity(activityId: params.activityId, userId: params.userId);
}

class CompleteActivityParams extends Equatable {
  const CompleteActivityParams(
      {required this.activityId, required this.userId});

  final String activityId;
  final String userId;

  @override
  List<String> get props => [activityId, userId];
}
