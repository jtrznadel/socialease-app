import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/domain/repositories/activity_repository.dart';

class LikeActivity extends FutureUsecaseWithParams<void, LikeActivityParams> {
  const LikeActivity(this._repo);

  final ActivityRepository _repo;

  @override
  ResultFuture<void> call(LikeActivityParams params) =>
      _repo.likeActivity(activityId: params.activityId, userId: params.userId);
}

class LikeActivityParams extends Equatable {
  const LikeActivityParams({required this.activityId, required this.userId});

  final String activityId;
  final String userId;

  @override
  List<String> get props => [activityId, userId];
}
