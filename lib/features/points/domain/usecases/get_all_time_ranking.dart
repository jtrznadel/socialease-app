import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/points/domain/entities/ranking_position.dart';
import 'package:social_ease_app/features/points/domain/repositories/points_repository.dart';

class GetAllTimeRanking
    extends StreamUsecaseWithoutParams<List<RankingPosition>> {
  const GetAllTimeRanking(this._repo);
  final PointsRepo _repo;

  @override
  ResultStream<List<RankingPosition>> call() => _repo.getAllTimeRanking();
}
