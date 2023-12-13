import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/points/domain/repositories/points_repository.dart';

class AddPoints extends FutureUsecaseWithParams<void, AddPointsParams> {
  const AddPoints(this._repo);
  final PointsRepo _repo;

  @override
  ResultFuture<void> call(AddPointsParams params) =>
      _repo.addPoints(userId: params.userId, points: params.points);
}

class AddPointsParams extends Equatable {
  const AddPointsParams({required this.userId, required this.points});

  final String userId;
  final int points;

  @override
  List<Object?> get props => [userId, points];
}
