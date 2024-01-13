import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/domain/repositories/activity_repository.dart';

class RemoveComment extends FutureUsecaseWithParams<void, RemoveCommentParams> {
  const RemoveComment(this._repo);

  final ActivityRepository _repo;

  @override
  ResultFuture<void> call(RemoveCommentParams params) => _repo.removeComment(
      activityId: params.activityId, commentId: params.commentId);
}

class RemoveCommentParams extends Equatable {
  const RemoveCommentParams(
      {required this.commentId, required this.activityId});

  final String commentId;
  final String activityId;

  @override
  List<Object?> get props => [commentId, activityId];
}
