import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/activity/presentation/widgets/activity_member_tile.dart';
import 'package:social_ease_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:social_ease_app/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:social_ease_app/features/points/presentation/cubit/points_cubit.dart';

class ActivityMembersScreen extends StatelessWidget {
  const ActivityMembersScreen({
    super.key,
    required this.activity,
  });

  static const routeName = '/activity-members';

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    List<String> members = List<String>.from(activity.members)
      ..remove(activity.createdBy);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Members'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
          itemCount: members.length,
          itemBuilder: (BuildContext context, int index) {
            var member = members[index];
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => sl<AuthBloc>(),
                ),
                BlocProvider(
                  create: (context) => sl<ActivityCubit>(),
                ),
                BlocProvider(
                  create: (context) => sl<NotificationCubit>(),
                ),
                BlocProvider(
                  create: (context) => sl<PointsCubit>(),
                ),
              ],
              child: ActivityMemberTile(
                memberId: member,
                activity: activity,
              ),
            );
          },
        ),
      ),
    );
  }
}
