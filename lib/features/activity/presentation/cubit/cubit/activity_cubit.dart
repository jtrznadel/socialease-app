import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/enums/activity_status.dart';
import 'package:social_ease_app/core/errors/failures.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/domain/entities/comment.dart';
import 'package:social_ease_app/features/activity/domain/usecases/add_activity.dart';
import 'package:social_ease_app/features/activity/domain/usecases/add_comment.dart';
import 'package:social_ease_app/features/activity/domain/usecases/complete_activity.dart';
import 'package:social_ease_app/features/activity/domain/usecases/get_activities.dart';
import 'package:social_ease_app/features/activity/domain/usecases/get_comments.dart';
import 'package:social_ease_app/features/activity/domain/usecases/get_user_by_id.dart';
import 'package:social_ease_app/features/activity/domain/usecases/join_activity.dart';
import 'package:social_ease_app/features/activity/domain/usecases/leave_activity.dart';
import 'package:social_ease_app/features/activity/domain/usecases/like_comment.dart';
import 'package:social_ease_app/features/activity/domain/usecases/remove_activity.dart';
import 'package:social_ease_app/features/activity/domain/usecases/remove_comment.dart';
import 'package:social_ease_app/features/activity/domain/usecases/remove_request.dart';
import 'package:social_ease_app/features/activity/domain/usecases/send_request.dart';
import 'package:social_ease_app/features/activity/domain/usecases/update_activity.dart';
import 'package:social_ease_app/features/activity/domain/usecases/update_activity_status.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';

part 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  final AddActivity _addActivity;
  final RemoveActivity _removeActivity;
  final UpdateActivity _updateActivity;
  final GetActivities _getActivities;
  final GetUserById _getUserById;
  final JoinActivity _joinActivity;
  final LeaveActivity _leaveActivity;
  final CompleteActivity _completeActivity;
  final SendRequest _sendRequest;
  final RemoveRequest _removeRequest;
  final UpdateActivityStatus _updateActivityStatus;
  final AddComment _addComment;
  final RemoveComment _removeComment;
  final LikeComment _likeComment;
  final GetComments _getComments;

  StreamSubscription<Either<Failure, List<Activity>>>? activitiesSubscription;
  StreamSubscription<Either<Failure, List<ActivityComment>>>?
      commentsSubscription;

  ActivityCubit({
    required AddActivity addActivity,
    required RemoveActivity removeActivity,
    required UpdateActivity updateActivity,
    required GetActivities getActivities,
    required GetUserById getUserById,
    required JoinActivity joinActivity,
    required LeaveActivity leaveActivity,
    required CompleteActivity completeActivity,
    required SendRequest sendRequest,
    required RemoveRequest removeRequest,
    required UpdateActivityStatus updateActivityStatus,
    required AddComment addComment,
    required RemoveComment removeComment,
    required LikeComment likeComment,
    required GetComments getComments,
  })  : _addActivity = addActivity,
        _removeActivity = removeActivity,
        _updateActivity = updateActivity,
        _getActivities = getActivities,
        _getUserById = getUserById,
        _joinActivity = joinActivity,
        _leaveActivity = leaveActivity,
        _completeActivity = completeActivity,
        _sendRequest = sendRequest,
        _removeRequest = removeRequest,
        _updateActivityStatus = updateActivityStatus,
        _addComment = addComment,
        _removeComment = removeComment,
        _likeComment = likeComment,
        _getComments = getComments,
        super(ActivityInitial());

  @override
  Future<void> close() {
    activitiesSubscription?.cancel();
    return super.close();
  }

  Future<void> addActivity(Activity activity) async {
    emit(AddingActivity());
    final result = await _addActivity(activity);
    result.fold(
      (failure) => emit(ActivityError(failure.errorMessage)),
      (_) => emit(ActivityAdded()),
    );
  }

  Future<void> removeActivity(String activityId) async {
    emit(const ActivityRemoving());
    final result = await _removeActivity(activityId);
    result.fold(
      (failure) => emit(ActivityError(failure.errorMessage)),
      (_) => emit(const ActivityRemoved()),
    );
  }

  Future<void> updateActivity(Activity activity) async {
    emit(const UpdatingActivity());
    final result = await _updateActivity(activity);
    result.fold(
      (failure) => emit(ActivityError(failure.errorMessage)),
      (_) => emit(const ActivityUpdated()),
    );
  }

  void getActivities() {
    emit(LoadingActivities());
    activitiesSubscription = _getActivities().listen(
      (result) {
        result.fold(
          (failure) => emit(ActivityError(failure.errorMessage)),
          (activities) => emit(ActivitiesLoaded(activities)),
        );
      },
      onError: (error) {
        emit(ActivityError(error.toString()));
      },
    );
  }

  Future<void> getUser(String userId) async {
    emit(const GettingUser());
    final result = await _getUserById(userId);
    result.fold(
      (failure) => emit(ActivityError(failure.errorMessage)),
      (user) => emit(UserLoaded(user)),
    );
  }

  Future<void> joinActivity({
    required String activityId,
    required String userId,
  }) async {
    emit(const JoiningActivity());
    final result = await _joinActivity(JoinActivityParams(
      activityId: activityId,
      userId: userId,
    ));
    result.fold(
      (failure) => emit(ActivityError(failure.errorMessage)),
      (_) => emit(const JoinedActivity()),
    );
  }

  Future<void> leaveActivity({
    required String activityId,
    required String userId,
  }) async {
    emit(const LeavingActivity());
    final result = await _leaveActivity(LeaveActivityParams(
      activityId: activityId,
      userId: userId,
    ));
    result.fold(
      (failure) => emit(ActivityError(failure.errorMessage)),
      (_) => emit(const LeftActivity()),
    );
  }

  Future<void> completeActivity({
    required String activityId,
    required String userId,
  }) async {
    emit(const CompletingActivity());
    final result = await _completeActivity(CompleteActivityParams(
      activityId: activityId,
      userId: userId,
    ));
    result.fold(
      (failure) => emit(ActivityError(failure.errorMessage)),
      (_) => emit(const ActivityCompleted()),
    );
  }

  Future<void> sendRequest({
    required String activityId,
    required String userId,
  }) async {
    emit(const SendingActivityRequest());
    final result = await _sendRequest(SendRequestParams(
      activityId: activityId,
      userId: userId,
    ));
    result.fold(
      (failure) => emit(ActivityError(failure.errorMessage)),
      (_) => emit(const ActivityRequestSent()),
    );
  }

  Future<void> removeRequest({
    required String activityId,
    required String userId,
  }) async {
    emit(const RemovingActivityRequest());
    final result = await _removeRequest(RemoveRequestParams(
      activityId: activityId,
      userId: userId,
    ));
    result.fold(
      (failure) => emit(ActivityError(failure.errorMessage)),
      (_) => emit(const ActivityRequestRemoved()),
    );
  }

  Future<void> updateActivityStatus({
    required ActivityStatus status,
    required String activityId,
  }) async {
    emit(const UpdatingActivityStatus());
    final result = await _updateActivityStatus(
        UpdateActivityStatusParams(activityId: activityId, status: status));
    result.fold(
      (failure) => emit(ActivityError(failure.errorMessage)),
      (_) => emit(const ActivityStatusUpdated()),
    );
  }

  Future<void> addComment({
    required String activityId,
    required ActivityComment comment,
  }) async {
    emit(const AddingComment());
    final result = await _addComment(
        AddCommentParams(comment: comment, activityId: activityId));
    result.fold(
      (failure) => emit(ActivityError(failure.errorMessage)),
      (_) => emit(const CommentAdded()),
    );
  }

  Future<void> removeComment({
    required String activityId,
    required String commentId,
  }) async {
    emit(const ActivityRemoving());
    final result = await _removeComment(
        RemoveCommentParams(commentId: commentId, activityId: activityId));
    result.fold(
      (failure) => emit(ActivityError(failure.errorMessage)),
      (_) => emit(const CommentRemoved()),
    );
  }

  Future<void> likeComment({
    required String activityId,
    required String commentId,
  }) async {
    emit(const UpdadingCommentLikes());
    final result = await _likeComment(
        LikeCommentParams(commentId: commentId, activityId: activityId));
    result.fold(
      (failure) => emit(ActivityError(failure.errorMessage)),
      (_) => emit(const CommentLikesUpdated()),
    );
  }

  void getComments(String activityId) {
    emit(const GettingComments());
    commentsSubscription = _getComments(activityId).listen(
      (result) {
        result.fold(
          (failure) => emit(ActivityError(failure.errorMessage)),
          (comments) => emit(CommentsLoaded(comments)),
        );
      },
      onError: (error) {
        emit(ActivityError(error.toString()));
      },
    );
  }
}
