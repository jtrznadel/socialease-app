import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/enums/notification_enum.dart';

class Notification extends Equatable {
  const Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    this.seen = false,
    required this.sentAt,
  });

  Notification.empty()
      : id = '_empty.id',
        title = '_empty.title',
        body = '_empty.body',
        category = NotificationCategory.none,
        seen = false,
        sentAt = DateTime.now();

  final String id;
  final String title;
  final String body;
  final NotificationCategory category;
  final bool seen;
  final DateTime sentAt;

  @override
  List<Object?> get props => [id];
}
