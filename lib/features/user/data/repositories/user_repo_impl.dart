import 'package:dartz/dartz.dart';
import 'package:social_ease_app/core/errors/exceptions.dart';
import 'package:social_ease_app/core/errors/failures.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';
import 'package:social_ease_app/features/user/data/datasources/user_remote_data_source.dart';
import 'package:social_ease_app/features/user/domain/repositories/user_repo.dart';

class UserRepoImpl implements UserRepo {
  const UserRepoImpl(this._remoteDataSrc);

  final UserRemoteDataSrc _remoteDataSrc;

  @override
  ResultFuture<LocalUser> getUserById(String userId) async {
    try {
      final result = await _remoteDataSrc.getUserById(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
