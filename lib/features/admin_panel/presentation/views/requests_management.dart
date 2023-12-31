import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/common/views/loading_view.dart';
import 'package:social_ease_app/core/common/widgets/gradient_background.dart';
import 'package:social_ease_app/core/enums/activity_status.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/core/services/injection_container.dart';

import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/admin_panel/presentation/widgets/request_viewer.dart';
import 'package:social_ease_app/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:social_ease_app/features/points/presentation/cubit/points_cubit.dart';

class RequestsManagementScreen extends StatefulWidget {
  const RequestsManagementScreen({super.key});

  static const routeName = '/request-management';

  @override
  State<RequestsManagementScreen> createState() =>
      _RequestsManagementScreenState();
}

class _RequestsManagementScreenState extends State<RequestsManagementScreen> {
  void getActivities() {
    context.read<ActivityCubit>().getActivities();
  }

  @override
  void initState() {
    getActivities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Requests Management'),
      ),
      body: GradientBackground(
        image: MediaRes.dashboardGradient,
        child: BlocBuilder<ActivityCubit, ActivityState>(
          builder: (context, state) {
            if (state is LoadingActivities) {
              return const LoadingView();
            } else if (state is ActivitiesLoaded && state.activities.isEmpty ||
                state is ActivityError) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0),
                  child: Text(
                    'Activities have not been found or have not been added yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.secondaryTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else if (state is ActivitiesLoaded) {
              final requests = state.activities
                  .where((request) =>
                      request.status == ActivityStatus.toBeVerified.name)
                  .toList();

              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => sl<NotificationCubit>(),
                  ),
                  BlocProvider(
                    create: (context) => sl<ActivityCubit>(),
                  ),
                  BlocProvider(
                    create: (context) => sl<PointsCubit>(),
                  )
                ],
                child: RequestViewer(requests: requests),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
