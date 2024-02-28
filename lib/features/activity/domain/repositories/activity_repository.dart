import 'package:social_ease_app/core/enums/activity_status.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/domain/entities/comment.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';

abstract class ActivityRepository {
  const ActivityRepository();

  ResultStream<List<Activity>> getActivities();
  ResultFuture<void> addActivity(Activity activity);
  ResultFuture<void> removeActivity(String activityId);
  ResultFuture<void> updateActivity(Activity activity);
  ResultFuture<LocalUser> getUserById(String userId);
  ResultFuture<void> joinActivity(
      {required String activityId, required String userId});
  ResultFuture<void> leaveActivity(
      {required String activityId, required String userId});
  ResultFuture<void> completeActivity(
      {required String activityId, required String userId});
  ResultFuture<void> sendRequest(
      {required String activityId, required String userId});
  ResultFuture<void> removeRequest(
      {required String activityId, required String userId});
  ResultFuture<void> updateActivityStatus({
    required String activityId,
    required ActivityStatus status,
  });
  ResultFuture<void> addComment(
      {required ActivityComment comment, required String activityId});
  ResultFuture<void> removeComment(
      {required String commentId, required String activityId});
  ResultStream<List<ActivityComment>> getComments(String activityId);
  ResultFuture<void> likeComment(
      {required String commentId, required String activityId});
  ResultFuture<void> likeActivity(
      {required String activityId, required String userId});
}
