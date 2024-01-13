import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/domain/entities/comment.dart';
import 'package:social_ease_app/features/activity/domain/repositories/activity_repository.dart';

class AddComment extends FutureUsecaseWithParams<void, AddCommentParams> {
  const AddComment(this._repo);

  final ActivityRepository _repo;

  @override
  ResultFuture<void> call(AddCommentParams params) async => _repo.addComment(
        comment: params.comment,
        activityId: params.activityId,
      );
}

class AddCommentParams extends Equatable {
  const AddCommentParams({
    required this.comment,
    required this.activityId,
  });

  final ActivityComment comment;
  final String activityId;

  @override
  List<Object?> get props => [comment, activityId];
}
