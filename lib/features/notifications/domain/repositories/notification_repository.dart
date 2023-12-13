import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/notifications/domain/entities/notification.dart';

abstract class NotificationRepository {
  const NotificationRepository();

  ResultFuture<void> markAsRead(String notificationId);

  ResultFuture<void> clearAll();
  ResultFuture<void> clear(String notificationId);

  ResultFuture<void> sendNotification(Notification notification);
  ResultFuture<void> sendNotificationToUser(
      {required String userId, required Notification notification});

  ResultStream<List<Notification>> getNotifications();
}
