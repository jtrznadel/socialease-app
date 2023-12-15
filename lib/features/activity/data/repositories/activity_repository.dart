import 'package:dartz/dartz.dart';
import 'package:social_ease_app/core/enums/activity_status.dart';
import 'package:social_ease_app/core/errors/exceptions.dart';
import 'package:social_ease_app/core/errors/failures.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/data/datasources/activity_remote_data_source.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
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
  ResultFuture<List<Activity>> getActivities() async {
    try {
      final activities = await _remoteDataSource.getActivities();
      return Right(activities);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
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
}
