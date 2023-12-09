import 'package:social_ease_app/core/enums/notification_enum.dart';

extension NotificationExt on String {
  NotificationCategory get toNotificationCategory {
    switch (this) {
      case 'activityFeedback':
        return NotificationCategory.activityFeedback;
      case 'reportFeedback':
        return NotificationCategory.reportFeedback;
      case 'activityExpiry':
        return NotificationCategory.activityExpiry;
      case 'pointsReceived':
        return NotificationCategory.pointsReceived;
      case 'levelUp':
        return NotificationCategory.levelUp;
      default:
        return NotificationCategory.none;
    }
  }
}
