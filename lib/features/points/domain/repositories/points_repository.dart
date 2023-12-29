import 'package:social_ease_app/core/enums/account_level.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/points/domain/entities/ranking_position.dart';

abstract class PointsRepo {
  const PointsRepo();

  ResultFuture<void> addPoints({required String userId, required int points});
  ResultFuture<void> subPoints({required String userId, required int points});
  ResultStream<int> getPoints({required String userId});
  ResultStream<AccountLevel> getLevel({required String userId});
  ResultFuture<void> updateLevel({required String userId});
  ResultStream<List<RankingPosition>> getAllTimeRanking();
  ResultStream<List<RankingPosition>> getMonthlyRanking();
  ResultFuture<void> updateRanking();
}
