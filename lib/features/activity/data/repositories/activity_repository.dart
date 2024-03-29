import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:social_ease_app/core/enums/activity_status.dart';
import 'package:social_ease_app/core/errors/exceptions.dart';
import 'package:social_ease_app/core/errors/failures.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/data/datasources/activity_remote_data_source.dart';
import 'package:social_ease_app/features/activity/data/models/activity_model.dart';
import 'package:social_ease_app/features/activity/data/models/comment_model.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/domain/entities/comment.dart';
import 'package:social_ease_app/features/activity/domain/repositories/activity_repository.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  const ActivityRepositoryImpl(this._remoteDataSource);

  final ActivityRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<void> addActivity(Activity activity) async {
    try {
      await _remoteDataSource.addActivity(activity);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> removeActivity(String activityId) async {
    try {
      await _remoteDataSource.removeActivity(activityId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> updateActivity(Activity activity) async {
    try {
      await _remoteDataSource.updateActivity(activity);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultStream<List<Activity>> getActivities() {
    return _remoteDataSource.getActivities().transform(
          StreamTransformer<List<ActivityModel>,
              Either<Failure, List<Activity>>>.fromHandlers(
            handleData: (activities, sink) {
              sink.add(Right(activities));
            },
            handleError: (error, stackTrace, sink) {
              debugPrint(stackTrace.toString());
              if (error is ServerException) {
                sink.add(Left(ServerFailure.fromException(error)));
              } else {
                sink.add(Left(
                    ServerFailure(message: error.toString(), statusCode: 505)));
              }
            },
          ),
        );
  }

  @override
  ResultFuture<LocalUser> getUserById(String userId) async {
    try {
      final result = await _remoteDataSource.getUserById(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> joinActivity(
      {required String activityId, required String userId}) async {
    try {
      await _remoteDataSource.joinActivity(
          activityId: activityId, userId: userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> leaveActivity(
      {required String activityId, required String userId}) async {
    try {
      await _remoteDataSource.leaveActivity(
          activityId: activityId, userId: userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> completeActivity(
      {required String activityId, required String userId}) async {
    try {
      await _remoteDataSource.completeActivity(
          activityId: activityId, userId: userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> updateActivityStatus(
      {required String activityId, required ActivityStatus status}) async {
    try {
      await _remoteDataSource.updateActivityStatus(
          status: status, activityId: activityId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> sendRequest(
      {required String activityId, required String userId}) async {
    try {
      await _remoteDataSource.sendRequest(
          userId: userId, activityId: activityId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> removeRequest(
      {required String activityId, required String userId}) async {
    try {
      await _remoteDataSource.removeRequest(
          userId: userId, activityId: activityId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> addComment(
      {required ActivityComment comment, required String activityId}) async {
    try {
      await _remoteDataSource.addComment(
          comment: comment, activityId: activityId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultStream<List<ActivityComment>> getComments(String activityId) {
    return _remoteDataSource.getComments(activityId).transform(
          StreamTransformer<List<CommentModel>,
              Either<Failure, List<ActivityComment>>>.fromHandlers(
            handleData: (comments, sink) {
              sink.add(Right(comments));
            },
            handleError: (error, stackTrace, sink) {
              debugPrint(stackTrace.toString());
              if (error is ServerException) {
                sink.add(Left(ServerFailure.fromException(error)));
              } else {
                sink.add(Left(
                    ServerFailure(message: error.toString(), statusCode: 505)));
              }
            },
          ),
        );
  }

  @override
  ResultFuture<void> likeComment(
      {required String commentId, required String activityId}) async {
    try {
      await _remoteDataSource.likeComment(
          commentId: commentId, activityId: activityId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> removeComment(
      {required String commentId, required String activityId}) async {
    try {
      await _remoteDataSource.removeComment(
          activityId: activityId, commentId: commentId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> likeActivity(
      {required String activityId, required String userId}) async {
    try {
      await _remoteDataSource.likeActivity(
          activityId: activityId, userId: userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
