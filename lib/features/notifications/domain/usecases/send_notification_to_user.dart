import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/notifications/data/repos/notification_repo_impl.dart';
import 'package:social_ease_app/features/notifications/domain/entities/notification.dart';
import 'package:social_ease_app/features/notifications/domain/repositories/notification_repository.dart';

class SendNotificationToUser
    extends FutureUsecaseWithParams<void, SendNotificationToUserParams> {
  const SendNotificationToUser(this._repo);

  final NotificationRepository _repo;

  @override
  ResultFuture<void> call(SendNotificationToUserParams params) =>
      _repo.sendNotificationToUser(
          userId: params.userId, notification: params.notification);
}

class SendNotificationToUserParams {
  const SendNotificationToUserParams(
      {required this.userId, required this.notification});
  final String userId;
  final Notification notification;
}
