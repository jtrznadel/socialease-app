import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/notifications/domain/repositories/notification_repository.dart';

class MarkAsRead extends FutureUsecaseWithParams<void, String> {
  const MarkAsRead(this._repo);

  final NotificationRepository _repo;

  @override
  ResultFuture<void> call(String params) => _repo.markAsRead(params);
}
