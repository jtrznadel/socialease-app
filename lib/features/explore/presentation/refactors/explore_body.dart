import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/providers/explore_activities_type_notifier.dart';
import 'package:social_ease_app/core/common/views/loading_view.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/explore/presentation/refactors/explore_list.dart';
import 'package:social_ease_app/features/explore/presentation/refactors/explore_map.dart';

class ExploreBody extends StatefulWidget {
  const ExploreBody({super.key});

  @override
  State<ExploreBody> createState() => _ExploreBodyState();
}

class _ExploreBodyState extends State<ExploreBody> {
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
    return BlocBuilder<ActivityCubit, ActivityState>(
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
          final activities = state.activities;
          return Consumer<ExploreActivitiesTypeNotifier>(
            builder: (_, provider, __) {
              bool exploreType = provider.exploreType;
              if (exploreType) {
                return ExploreMap(activities: activities);
              }
              return ExploreList(activities: activities);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
