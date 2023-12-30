import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/common/views/loading_view.dart';
import 'package:social_ease_app/core/common/widgets/gradient_background.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/activity/presentation/views/activity_details_screen.dart';
import 'package:social_ease_app/features/activity/presentation/views/edit_activity_screen.dart';
import 'package:social_ease_app/features/activity/presentation/widgets/activity_tile.dart';

class ActivitiesManagementScreen extends StatefulWidget {
  const ActivitiesManagementScreen({super.key});

  static const routeName = "/activities-management";

  @override
  State<ActivitiesManagementScreen> createState() =>
      _ActivitiesManagementScreenState();
}

class _ActivitiesManagementScreenState
    extends State<ActivitiesManagementScreen> {
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
        title: const Text('Activity Management'),
      ),
      body: GradientBackground(
        image: MediaRes.dashboardGradient,
        child: BlocBuilder<ActivityCubit, ActivityState>(
          builder: (context, state) {
            if (state is LoadingActivities) {
              return const LoadingView();
            } else if ((state is ActivitiesLoaded &&
                    state.activities
                        .where((activity) =>
                            activity.createdBy == context.currentUser!.uid)
                        .toList()
                        .isEmpty) ||
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
              final userActivities = state.activities
                  .where((element) =>
                      element.createdBy == context.currentUser!.uid)
                  .toList();
              userActivities.sort((a, b) => b.endDate!.compareTo(a.endDate!));

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    itemCount: userActivities.length,
                    itemBuilder: (context, index) {
                      final activity = userActivities[index];
                      final isActive =
                          activity.endDate!.isAfter(DateTime.now());

                      return BlocProvider(
                        create: (_) => sl<ActivityCubit>(),
                        child: ActivityTile(
                          activity: activity,
                          editMode: true,
                          onTap: isActive
                              ? () => Navigator.of(context).pushNamed(
                                    EditActivityScreen.routeName,
                                    arguments: activity,
                                  )
                              : () {},
                        ),
                      );
                    }),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
