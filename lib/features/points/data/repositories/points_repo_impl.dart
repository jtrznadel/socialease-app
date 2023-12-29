import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:social_ease_app/core/enums/account_level.dart';
import 'package:social_ease_app/core/errors/exceptions.dart';
import 'package:social_ease_app/core/errors/failures.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/points/data/datasources/points_remote_data_source.dart';
import 'package:social_ease_app/features/points/data/models/ranking_position_model.dart';
import 'package:social_ease_app/features/points/domain/entities/ranking_position.dart';
import 'package:social_ease_app/features/points/domain/repositories/points_repository.dart';

class PointsRepoImpl implements PointsRepo {
  const PointsRepoImpl(this._remoteDataSrc);

  final PointsRemoteDataSrc _remoteDataSrc;

  @override
  ResultFuture<void> addPoints(
      {required String userId, required int points}) async {
    try {
      await _remoteDataSrc.addPoints(userId: userId, points: points);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultStream<AccountLevel> getLevel({required String userId}) {
    return _remoteDataSrc.getLevel(userId: userId).transform(
          StreamTransformer<AccountLevel,
                  Either<Failure, AccountLevel>>.fromHandlers(
              handleData: (accountLevel, sink) {
            sink.add(Right(accountLevel));
          }, handleError: (error, stackTrace, sink) {
            debugPrint(stackTrace.toString());
            if (error is ServerException) {
              sink.add(Left(ServerFailure.fromException(error)));
            } else {
              sink.add(Left(
                  ServerFailure(message: error.toString(), statusCode: 505)));
            }
          }),
        );
  }

  @override
  ResultStream<int> getPoints({required String userId}) {
    return _remoteDataSrc.getPoints(userId: userId).transform(
          StreamTransformer<int, Either<Failure, int>>.fromHandlers(
              handleData: (points, sink) {
            sink.add(Right(points));
          }, handleError: (error, stackTrace, sink) {
            debugPrint(stackTrace.toString());
            if (error is ServerException) {
              sink.add(Left(ServerFailure.fromException(error)));
            } else {
              sink.add(Left(
                  ServerFailure(message: error.toString(), statusCode: 505)));
            }
          }),
        );
  }

  @override
  ResultFuture<void> subPoints(
      {required String userId, required int points}) async {
    try {
      await _remoteDataSrc.subPoints(userId: userId, points: points);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> updateLevel({required String userId}) async {
    try {
      await _remoteDataSrc.updateLevel(userId: userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultStream<List<RankingPosition>> getAllTimeRanking() {
    return _remoteDataSrc.getAllTimeRanking().transform(
          StreamTransformer<List<RankingPositionModel>,
              Either<Failure, List<RankingPosition>>>.fromHandlers(
            handleData: (positions, sink) {
              sink.add(Right(positions));
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
  ResultStream<List<RankingPosition>> getMonthlyRanking() {
    return _remoteDataSrc.getMonthlyRanking().transform(
          StreamTransformer<List<RankingPositionModel>,
              Either<Failure, List<RankingPosition>>>.fromHandlers(
            handleData: (positions, sink) {
              sink.add(Right(positions));
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
  ResultFuture<void> updateRanking() async {
    try {
      await _remoteDataSrc.updateRanking();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
