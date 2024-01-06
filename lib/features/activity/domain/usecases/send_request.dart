import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/domain/repositories/activity_repository.dart';

class SendRequest extends FutureUsecaseWithParams<void, SendRequestParams> {
  const SendRequest(this._repo);

  final ActivityRepository _repo;

  @override
  ResultFuture<void> call(SendRequestParams params) =>
      _repo.sendRequest(activityId: params.activityId, userId: params.userId);
}

class SendRequestParams extends Equatable {
  const SendRequestParams({required this.activityId, required this.userId});

  final String activityId;
  final String userId;

  @override
  List<String> get props => [activityId, userId];
}
