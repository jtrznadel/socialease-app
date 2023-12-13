import 'package:social_ease_app/core/enums/account_level.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';

abstract class PointsRepo {
  const PointsRepo();

  ResultFuture<void> addPoints({required String userId, required int points});
  ResultFuture<void> subPoints({required String userId, required int points});
  ResultStream<int> getPoints({required String userId});
  ResultStream<AccountLevel> getLevel({required String userId});
  ResultFuture<void> updateLevel({required String userId});
}
