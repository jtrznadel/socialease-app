import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/points/domain/repositories/points_repository.dart';

class UpdateLevel extends FutureUsecaseWithParams<void, String> {
  const UpdateLevel(this._repo);

  final PointsRepo _repo;

  @override
  ResultFuture<void> call(String params) => _repo.updateLevel(userId: params);
}
