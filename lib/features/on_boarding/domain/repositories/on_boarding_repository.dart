import 'package:social_ease_app/core/utils/typedefs.dart';

abstract class OnBoardingRepository {
  const OnBoardingRepository();

  ResultFuture<void> cacheFirstTimer();

  ResultFuture<bool> checkIfUserIsFirstTimer();
}
