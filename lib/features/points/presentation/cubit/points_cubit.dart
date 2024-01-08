import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/enums/account_level.dart';
import 'package:social_ease_app/core/errors/failures.dart';
import 'package:social_ease_app/features/points/domain/entities/ranking_position.dart';
import 'package:social_ease_app/features/points/domain/usecases/add_points.dart';
import 'package:social_ease_app/features/points/domain/usecases/get_all_time_ranking.dart';
import 'package:social_ease_app/features/points/domain/usecases/get_level.dart';
import 'package:social_ease_app/features/points/domain/usecases/get_monthly_ranking.dart';
import 'package:social_ease_app/features/points/domain/usecases/get_points.dart';
import 'package:social_ease_app/features/points/domain/usecases/subtract_points.dart';
import 'package:social_ease_app/features/points/domain/usecases/update_level.dart';

part 'points_state.dart';

class PointsCubit extends Cubit<PointsState> {
  PointsCubit({
    required AddPoints addPoints,
    required SubPoints subPoints,
    required UpdateLevel updateLevel,
    required GetPoints getPoints,
    required GetLevel getLevel,
    required GetAllTimeRanking getAllTimeRanking,
    required GetMonthlyRanking getMonthlyRanking,
  })  : _addPoints = addPoints,
        _subPoints = subPoints,
        _updateLevel = updateLevel,
        _getPoints = getPoints,
        _getLevel = getLevel,
        _getAllTimeRanking = getAllTimeRanking,
        _getMonthlyRanking = getMonthlyRanking,
        super(PointsInitial());

  final AddPoints _addPoints;
  final SubPoints _subPoints;
  final UpdateLevel _updateLevel;
  final GetPoints _getPoints;
  final GetLevel _getLevel;
  final GetAllTimeRanking _getAllTimeRanking;
  final GetMonthlyRanking _getMonthlyRanking;

  Future<void> addPoints({
    required String userId,
    required int points,
  }) async {
    emit(const AddingPoints());
    final result = await _addPoints(AddPointsParams(
      userId: userId,
      points: points,
    ));
    result.fold(
      (failure) => emit(PointsError(failure.errorMessage)),
      (_) => emit(const PointsAdded()),
    );
  }

  Future<void> subPoints({
    required String userId,
    required int points,
  }) async {
    emit(const SubingPoints());
    final result = await _subPoints(SubPointsParams(
      userId: userId,
      points: points,
    ));
    result.fold(
      (failure) => emit(PointsError(failure.errorMessage)),
      (_) => emit(const PointsSubd()),
    );
  }

  Future<void> updateLevel(String userId) async {
    emit(const UpdatingLevel());
    final result = await _updateLevel(userId);
    result.fold(
      (failure) => emit(PointsError(failure.errorMessage)),
      (_) => emit(const LevelUpdated()),
    );
  }

  void getPoints(String userId) {
    emit(const GettingPoints());
    StreamSubscription<Either<Failure, int>>? subscription;

    subscription = _getPoints(userId).listen(
      (result) {
        if (isClosed) return;
        result.fold(
          (failure) => emit(PointsError(failure.errorMessage)),
          (points) => emit(PointsLoaded(points)),
        );
      },
      onError: (dynamic error) {
        emit(PointsError(error.toString()));
        subscription?.cancel();
      },
      onDone: () => subscription?.cancel(),
    );
  }

  void getLevel(String userId) {
    emit(const GettingLevel());
    StreamSubscription<Either<Failure, AccountLevel>>? subscription;

    subscription = _getLevel(userId).listen(
      (result) {
        if (isClosed) return;
        result.fold(
          (failure) => emit(PointsError(failure.errorMessage)),
          (level) => emit(LevelLoaded(level)),
        );
      },
      onError: (dynamic error) {
        emit(PointsError(error.toString()));
        subscription?.cancel();
      },
      onDone: () => subscription?.cancel(),
    );
  }

  void getAllTimeRanking() {
    emit(const LoadingAllTimeRanking());
    StreamSubscription<Either<Failure, List<RankingPosition>>>? subscription;

    subscription = _getAllTimeRanking().listen(
      (result) {
        result.fold(
          (failure) => emit(PointsError(failure.errorMessage)),
          (ranking) => emit(AllTimeRankingLoaded(ranking)),
        );
      },
      onDone: () => subscription?.cancel(),
      onError: (error) {
        emit(PointsError(error.toString()));
        subscription?.cancel();
      },
    );
  }

  void getMonthlyRanking() {
    emit(const LoadingMonthlyRanking());
    StreamSubscription<Either<Failure, List<RankingPosition>>>? subscription;

    subscription = _getMonthlyRanking().listen(
      (result) {
        result.fold(
          (failure) => emit(PointsError(failure.errorMessage)),
          (ranking) => emit(MonthlyRankingLoaded(ranking)),
        );
      },
      onDone: () => subscription?.cancel(),
      onError: (error) {
        emit(PointsError(error.toString()));
        subscription?.cancel();
      },
    );
  }
}
