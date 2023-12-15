import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/enums/activity_status.dart';
import 'package:social_ease_app/core/utils/core_utils.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/admin_panel/presentation/views/requests_management.dart';
import 'package:social_ease_app/features/profile/presentation/widgets/profile_action_button.dart';

class RequestsManagementButton extends StatefulWidget {
  const RequestsManagementButton({
    super.key,
  });

  @override
  State<RequestsManagementButton> createState() =>
      _RequestsManagementButtonState();
}

class _RequestsManagementButtonState extends State<RequestsManagementButton> {
  @override
  void initState() {
    context.read<ActivityCubit>().getActivities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityCubit, ActivityState>(
      builder: (context, state) {
        if (state is ActivityError) {
          return ProfileActionButton(
              label: 'Not Available', icon: Icons.error, onPressed: () {});
        } else if (state is ActivitiesLoaded) {
          final counter = state.activities
              .where((activity) =>
                  activity.status == ActivityStatus.toBeVerified.name)
              .length;
          return ProfileActionButton(
              label: 'Requests Management',
              numberToCheck: counter > 0 ? counter : null,
              icon: Icons.manage_history,
              onPressed: () {
                if (counter > 0) {
                  Navigator.of(context).pushNamed(
                    RequestsManagementScreen.routeName,
                  );
                } else {
                  CoreUtils.showSnackBar(
                      context, "There are not any requests to check");
                  return;
                }
              });
        }
        return const SizedBox.shrink();
      },
    );
  }
}
