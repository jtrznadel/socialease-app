import 'package:flutter/material.dart';

enum NotificationCategory {
  activityFeedback(
    value: 'activityFeedback',
    icon: Icons.feedback,
  ),
  reportFeedback(
    value: 'reportFeedback',
    icon: Icons.feedback,
  ),
  activityExpiry(
    value: 'activityExpiry',
    icon: Icons.exposure_minus_1_outlined,
  ),
  pointsReceived(
    value: 'pointsReceived',
    icon: Icons.add,
  ),
  levelUp(
    value: 'levelUp',
    icon: Icons.add,
  ),
  none(
    value: 'none',
    icon: Icons.no_encryption,
  );

  const NotificationCategory({required this.value, required this.icon});

  final String value;
  final IconData icon;
}
