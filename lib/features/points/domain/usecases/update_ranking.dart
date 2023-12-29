import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/points/domain/repositories/points_repository.dart';

class UpdateRanking extends FutureUsecaseWithoutParams<void> {
  const UpdateRanking(this._repo);
  final PointsRepo _repo;

  @override
  ResultFuture<void> call() => _repo.updateRanking();
}
