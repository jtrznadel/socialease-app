import 'package:social_ease_app/core/enums/account_level.dart';
import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/points/domain/repositories/points_repository.dart';

class GetLevel extends StreamUsecaseWithParams<AccountLevel, String> {
  const GetLevel(this._repo);

  final PointsRepo _repo;

  @override
  ResultStream<AccountLevel> call(String params) =>
      _repo.getLevel(userId: params);
}
