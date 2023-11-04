import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/domain/repositories/activity_repository.dart';

class AddActivity extends UsecaseWithParams<void, Activity> {
  const AddActivity(this._repo);

  final ActivityRepository _repo;

  @override
  ResultFuture<void> call(Activity params) async => _repo.addActivity(params);
}
