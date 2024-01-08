import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/enums/notification_enum.dart';
import 'package:social_ease_app/core/enums/points_value_enum.dart';
import 'package:social_ease_app/core/enums/report_enum.dart';
import 'package:social_ease_app/core/extensions/date_time_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/features/notifications/data/models/notification_model.dart';
import 'package:social_ease_app/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:social_ease_app/features/points/presentation/cubit/points_cubit.dart';
import 'package:social_ease_app/features/reports/domain/entities/report.dart';
import 'package:social_ease_app/features/reports/presentation/cubit/report_cubit.dart';

class ReportTile extends StatelessWidget {
  const ReportTile({super.key, required this.report});

  final Report report;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(report.category.icon),
      title: Text(
        report.category.value,
        style: TextStyle(
          fontSize: 14,
          fontFamily: Fonts.poppins,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        report.sentAt.timeAgo,
        style: TextStyle(
          fontSize: 14,
          fontFamily: Fonts.poppins,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              _showReportInfoDialog(context);
            },
            icon: const Icon(
              Icons.info_outline,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              NotificationModel notificationToReportedUser =
                  NotificationModel.empty().copyWith(
                title: 'You receive a warning',
                body: report.type == ReportType.userReport
                    ? 'A clear violation of the rules in the area was noted: ${report.category.value}. You have been deducted points.'
                    : 'Your initiative with id no. ${report.reportedActivityId} violates the regulations in terms of ${report.category.value}. You have been deducted points.',
                category: NotificationCategory.reportFeedback,
              );
              NotificationModel notificationToReportingUser =
                  NotificationModel.empty().copyWith(
                title: 'Your report has been successful',
                body:
                    'Thank you for keeping an eye on the rules and regulations among the participants. You have been rewarded with additional points',
                category: NotificationCategory.reportFeedback,
              );
              context.read<ReportCubit>().changeReportStatus(
                  reportId: report.id, status: ReportStatus.verified);
              context.read<PointsCubit>().subPoints(
                  userId: report.reportedUserId,
                  points: PointsValue.violation.value);
              context.read<NotificationCubit>().sendNotificationToUser(
                  userId: report.reportedUserId,
                  notification: notificationToReportedUser);
              context.read<PointsCubit>().addPoints(
                  userId: report.sentBy,
                  points: PointsValue.orderKeeping.value);
              context.read<NotificationCubit>().sendNotificationToUser(
                  userId: report.sentBy,
                  notification: notificationToReportingUser);
            },
            icon: const Icon(
              Icons.task_alt,
              color: Colors.green,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showReportInfoDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.bgColor,
          title: const Text('Report Information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Category: ${report.category.value}'),
                Text('Type: ${report.type.name}'),
                Text('Sent at: ${report.sentAt}'),
                Text('Reported User: ${report.reportedUserId}'),
                Text('Reported Activity: ${report.reportedActivityId}'),
                Text('Reported by: ${report.sentBy}'),
                Text('Reason: ${report.explanation}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
