import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/enums/notification_enum.dart';
import 'package:social_ease_app/core/enums/report_enum.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';
import 'package:social_ease_app/features/notifications/data/models/notification_model.dart';
import 'package:social_ease_app/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:social_ease_app/features/points/presentation/cubit/points_cubit.dart';
import 'package:social_ease_app/features/reports/data/models/report_model.dart';
import 'package:social_ease_app/features/reports/domain/entities/report.dart';
import 'package:social_ease_app/features/reports/presentation/cubit/report_cubit.dart';

class ActivityMemberTile extends StatefulWidget {
  final String memberId;
  final Activity activity;

  const ActivityMemberTile({
    Key? key,
    required this.memberId,
    required this.activity,
  }) : super(key: key);

  @override
  _ActivityMemberTileState createState() => _ActivityMemberTileState();
}

class _ActivityMemberTileState extends State<ActivityMemberTile> {
  LocalUser? user;
  final reasonController = TextEditingController();
  final pointsController = TextEditingController();
  final explanationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ActivityCubit>().getUser(widget.memberId);
  }

  @override
  void dispose() {
    reasonController.dispose();
    pointsController.dispose();
    explanationController.dispose();
    super.dispose();
  }

  void _showConfirmExecutionDialog(BuildContext parentsContext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Activity Execution'),
          content: const Text(
              'Are you sure you want to confirm this user\'s activity execution?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                int points = user?.accountLevel != null
                    ? 100 * user!.accountLevel.multiplier.toInt()
                    : 100;
                NotificationModel notification =
                    NotificationModel.empty().copyWith(
                  title: 'You have been awarded',
                  body:
                      'You have been awarded points for completing an activity of $points. Keep it up!',
                  category: NotificationCategory.pointsReceived,
                );
                parentsContext.read<NotificationCubit>().sendNotificationToUser(
                    userId: widget.memberId, notification: notification);
                parentsContext
                    .read<PointsCubit>()
                    .addPoints(userId: widget.memberId, points: points);
                parentsContext.read<ActivityCubit>().removeRequest(
                    activityId: widget.activity.id, userId: widget.memberId);
                parentsContext.read<ActivityCubit>().completeActivity(
                      activityId: widget.activity.id,
                      userId: widget.memberId,
                    );
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showReportDialog(BuildContext parentsContext) {
    ReportCategory? selectedCategory;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Report User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please provide the reason for reporting this user:'),
              DropdownButton<ReportCategory>(
                value: selectedCategory,
                items: ReportCategory.values.map((ReportCategory category) {
                  return DropdownMenuItem<ReportCategory>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (ReportCategory? newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
              ),
              const SizedBox(height: 16), // Add some spacing
              TextField(
                controller: explanationController,
                decoration: const InputDecoration(labelText: 'Explanation'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ReportModel report = ReportModel.empty().copyWith(
                  sentBy: context.currentUser!.uid,
                  reportedId: widget.memberId,
                  type: ReportType.userReport,
                  category: selectedCategory,
                  explanation: explanationController.text.trim(),
                );
                parentsContext.read<ReportCubit>().addReport(report);
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showAddPointsDialog(BuildContext parentsContext) {
    int? points;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Points to User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(labelText: 'Reason'),
              ),
              TextField(
                controller: pointsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Points'),
                onChanged: (value) {
                  if (value.isNotEmpty && int.tryParse(value) != null) {
                    points = int.parse(value);
                  } else {
                    points = null;
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                NotificationModel notification =
                    NotificationModel.empty().copyWith(
                  title: 'You have been awarded',
                  body:
                      'You have been awarded points of $points for "${reasonController.text}". Keep it up!',
                  category: NotificationCategory.pointsReceived,
                );
                parentsContext
                    .read<PointsCubit>()
                    .addPoints(userId: widget.memberId, points: points!);
                parentsContext.read<NotificationCubit>().sendNotificationToUser(
                    notification: notification, userId: widget.memberId);
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActivityCubit, ActivityState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          setState(() {
            user = state.user;
          });
        }
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: user?.profilePic != null
              ? NetworkImage(user!.profilePic!) as ImageProvider
              : const AssetImage(MediaRes.defaultAvatarImage),
        ),
        title: Text(
          user?.fullName ?? 'Unknown',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.activity.pendingRequests.contains(widget.memberId))
              IconButton(
                icon: const Icon(Icons.brightness_auto_outlined),
                onPressed: () {
                  _showConfirmExecutionDialog(context);
                },
              ),
            IconButton(
              icon: const Icon(Icons.report),
              onPressed: () {
                _showReportDialog(context);
              },
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _showAddPointsDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
