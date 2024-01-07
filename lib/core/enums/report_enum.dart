import 'package:flutter/material.dart';

enum ReportCategory {
  privacyViolation(
    value: 'privacyViolation',
    icon: Icons.feedback,
  ),
  rulesViolation(
    value: 'rulesViolation',
    icon: Icons.feedback,
  ),
  spamContent(
    value: 'spamContent',
    icon: Icons.feedback,
  ),
  inappropriateContent(
    value: 'inappropriateContent',
    icon: Icons.feedback,
  );

  const ReportCategory({required this.value, required this.icon});

  final String value;
  final IconData icon;
}

enum ReportType { activityReport, userReport }

enum ReportStatus { verified, waiting }
