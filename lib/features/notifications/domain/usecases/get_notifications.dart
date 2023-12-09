import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/notifications/domain/entities/notification.dart';
import 'package:social_ease_app/features/notifications/domain/repositories/notification_repository.dart';

class GetNotifications extends StreamUsecaseWithoutParams<List<Notification>> {
  const GetNotifications(this._repo);

  final NotificationRepository _repo;

  @override
  ResultStream<List<Notification>> call() => _repo.getNotifications();
}
