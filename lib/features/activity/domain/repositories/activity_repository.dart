import 'package:social_ease_app/core/enums/activity_status.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';

abstract class ActivityRepository {
  const ActivityRepository();

  ResultFuture<List<Activity>> getActivities();
  ResultFuture<void> addActivity(Activity activity);
  ResultFuture<LocalUser> getUserById(String userId);
  ResultFuture<void> joinActivity(
      {required String activityId, required String userId});
  ResultFuture<void> leaveActivity(
      {required String activityId, required String userId});
  ResultFuture<void> updateActivityStatus({
    required String activityId,
    required ActivityStatus status,
  });
}
