import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/points/domain/repositories/points_repository.dart';

class SubPoints extends FutureUsecaseWithParams<void, SubPointsParams> {
  const SubPoints(this._repo);
  final PointsRepo _repo;

  @override
  ResultFuture<void> call(SubPointsParams params) =>
      _repo.subPoints(userId: params.userId, points: params.points);
}

class SubPointsParams extends Equatable {
  const SubPointsParams({required this.userId, required this.points});

  final String userId;
  final int points;

  @override
  List<Object?> get props => [userId, points];
}
