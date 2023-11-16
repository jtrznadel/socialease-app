import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/on_boarding/domain/repositories/on_boarding_repository.dart';

class CacheFirstTimer extends FutureUsecaseWithoutParams<void> {
  const CacheFirstTimer(this._repo);

  final OnBoardingRepository _repo;

  @override
  ResultFuture<void> call() async => _repo.cacheFirstTimer();
}
