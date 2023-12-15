import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/enums/activity_status.dart';
import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/domain/repositories/activity_repository.dart';

class UpdateActivityStatus
    extends FutureUsecaseWithParams<void, UpdateActivityStatusParams> {
  UpdateActivityStatus(this._repo);

  final ActivityRepository _repo;

  @override
  ResultFuture<void> call(UpdateActivityStatusParams params) =>
      _repo.updateActivityStatus(
        activityId: params.activityId,
        status: params.status,
      );
}

class UpdateActivityStatusParams extends Equatable {
  const UpdateActivityStatusParams({
    required this.activityId,
    required this.status,
  });

  final String activityId;
  final ActivityStatus status;

  @override
  List<Object?> get props => [activityId, status];
}
