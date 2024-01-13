import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/domain/repositories/activity_repository.dart';

class LikeComment extends FutureUsecaseWithParams<void, LikeCommentParams> {
  const LikeComment(this._repo);

  final ActivityRepository _repo;

  @override
  ResultFuture<void> call(LikeCommentParams params) => _repo.likeComment(
        activityId: params.activityId,
        commentId: params.commentId,
      );
}

class LikeCommentParams extends Equatable {
  const LikeCommentParams({required this.commentId, required this.activityId});

  final String commentId;
  final String activityId;

  @override
  List<Object?> get props => [commentId, activityId];
}
