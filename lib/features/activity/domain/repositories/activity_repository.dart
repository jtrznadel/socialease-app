import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';

abstract class ActivityRepository {
  const ActivityRepository();

  ResultFuture<List<Activity>> getActivities();
  ResultFuture<void> addActivity(Activity activity);
}
