import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/domain/repositories/activity_repository.dart';

class RemoveRequest extends FutureUsecaseWithParams<void, RemoveRequestParams> {
  const RemoveRequest(this._repo);

  final ActivityRepository _repo;

  @override
  ResultFuture<void> call(RemoveRequestParams params) =>
      _repo.removeRequest(activityId: params.activityId, userId: params.userId);
}

class RemoveRequestParams extends Equatable {
  const RemoveRequestParams({required this.activityId, required this.userId});

  final String activityId;
  final String userId;

  @override
  List<String> get props => [activityId, userId];
}
