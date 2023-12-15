import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/domain/repositories/activity_repository.dart';

class GetActivities extends StreamUsecaseWithoutParams<List<Activity>> {
  const GetActivities(this._repo);

  final ActivityRepository _repo;

  @override
  ResultStream<List<Activity>> call() => _repo.getActivities();
}
