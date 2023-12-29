part of 'points_cubit.dart';

sealed class PointsState extends Equatable {
  const PointsState();

  @override
  List<Object> get props => [];
}

final class PointsInitial extends PointsState {}

final class AddingPoints extends PointsState {
  const AddingPoints();
}

final class PointsAdded extends PointsState {
  const PointsAdded();
}

final class SubingPoints extends PointsState {
  const SubingPoints();
}

final class PointsSubd extends PointsState {
  const PointsSubd();
}

final class UpdatingLevel extends PointsState {
  const UpdatingLevel();
}

final class LevelUpdated extends PointsState {
  const LevelUpdated();
}

final class GettingPoints extends PointsState {
  const GettingPoints();
}

final class PointsLoaded extends PointsState {
  const PointsLoaded(this.points);

  final int points;

  @override
  List<Object> get props => [points];
}

final class GettingLevel extends PointsState {
  const GettingLevel();
}

final class LevelLoaded extends PointsState {
  const LevelLoaded(this.level);

  final AccountLevel level;

  @override
  List<Object> get props => [level];
}

final class LoadingAllTimeRanking extends PointsState {
  const LoadingAllTimeRanking();
}

final class AllTimeRankingLoaded extends PointsState {
  const AllTimeRankingLoaded(this.allTimeRanking);
  final List<RankingPosition> allTimeRanking;
  @override
  List<Object> get props => [allTimeRanking];
}

final class LoadingMonthlyRanking extends PointsState {
  const LoadingMonthlyRanking();
}

final class MonthlyRankingLoaded extends PointsState {
  const MonthlyRankingLoaded(this.monthlyRanking);
  final List<RankingPosition> monthlyRanking;
  @override
  List<Object> get props => [monthlyRanking];
}

final class PointsError extends PointsState {
  const PointsError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
