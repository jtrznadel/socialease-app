import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/domain/repositories/activity_repository.dart';

class RemoveActivity extends FutureUsecaseWithParams<void, String> {
  const RemoveActivity(this._repo);

  final ActivityRepository _repo;

  @override
  ResultFuture<void> call(String params) => _repo.removeActivity(params);
}
