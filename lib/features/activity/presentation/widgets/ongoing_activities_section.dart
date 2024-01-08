import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/activity/presentation/widgets/ongoing_activity_page.dart';

class OngoingActivitiesSection extends StatelessWidget {
  const OngoingActivitiesSection({
    super.key,
    required this.activityController,
    required this.ongoingActivities,
  });

  final PageController activityController;
  final List<Activity> ongoingActivities;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: context.height * .2,
          child: PageView.builder(
            controller: activityController,
            itemCount: ongoingActivities.length,
            itemBuilder: (_, index) {
              return BlocProvider(
                create: (context) => sl<ActivityCubit>(),
                child: OngoingActivityPage(activity: ongoingActivities[index]),
              );
            },
          ),
        ),
        SmoothPageIndicator(
          controller: activityController,
          count: ongoingActivities.length,
          effect: const WormEffect(
            dotHeight: 8,
            dotColor: AppColors.primaryColor,
          ),
          onDotClicked: (index) {},
        )
      ],
    );
  }
}
