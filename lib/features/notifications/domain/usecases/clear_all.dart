import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/notifications/domain/repositories/notification_repository.dart';

class ClearAll extends FutureUsecaseWithoutParams<void> {
  const ClearAll(this._repo);
  final NotificationRepository _repo;

  @override
  ResultFuture<void> call() => _repo.clearAll();
}
