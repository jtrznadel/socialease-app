import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/points/domain/repositories/points_repository.dart';

class GetPoints extends StreamUsecaseWithParams<int, String> {
  const GetPoints(this._repo);

  final PointsRepo _repo;

  @override
  ResultStream<int> call(String params) => _repo.getPoints(userId: params);
}
