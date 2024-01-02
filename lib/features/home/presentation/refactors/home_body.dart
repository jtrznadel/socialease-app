import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:social_ease_app/core/common/app/providers/activity_of_the_day_notifier.dart';
import 'package:social_ease_app/core/common/views/loading_view.dart';
import 'package:social_ease_app/core/common/widgets/content_empty.dart';
import 'package:social_ease_app/core/common/widgets/gradient_background.dart';
import 'package:social_ease_app/core/enums/activity_status.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/core/utils/core_utils.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/home/presentation/refactors/home_categories.dart';
import 'package:social_ease_app/features/home/presentation/refactors/home_favorites.dart';
import 'package:social_ease_app/features/home/presentation/refactors/home_header.dart';
import 'package:social_ease_app/features/home/presentation/widgets/user_of_the_all_time.dart';
import 'package:social_ease_app/features/home/presentation/widgets/user_of_the_month.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final controller = PageController();

  void getActivities() {
    context.read<ActivityCubit>().getActivities();
  }

  @override
  void initState() {
    getActivities();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [const UserOfTheMonth(), const UserOfTheAllTime()];
    return BlocConsumer<ActivityCubit, ActivityState>(
      listener: (_, state) {
        if (state is ActivityError) {
          CoreUtils.showSnackBar(context, state.message);
        } else if (state is ActivitiesLoaded && state.activities.isNotEmpty) {
          final activities = state.activities..shuffle();
          final activitiesOfTheDay = state.activities
              .where((activity) =>
                  activity.createdBy != context.currentUser!.uid &&
                  activity.status == ActivityStatus.active.name)
              .toList();
          final activityOfTheDay = activities.first;
          context
              .read<ActivityOfTheDayNotifier>()
              .setActivityOfTheDay(activityOfTheDay);
          context
              .read<ActivityOfTheDayNotifier>()
              .setActivitiesOfTheDay(activitiesOfTheDay);
        }
      },
      builder: ((context, state) {
        if (state is LoadingActivities) {
          return const LoadingView();
        } else if (state is ActivitiesLoaded && state.activities.isEmpty ||
            state is ActivityError) {
          return const GradientBackground(
            image: MediaRes.dashboardGradient,
            child: ContentEmpty(
              text: 'Activities have not been found or have not been added yet',
            ),
          );
        } else if (state is ActivitiesLoaded) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                height: context.height * .3,
                width: context.width,
                color: Colors.white,
                child: const HomeHeader(),
              ),
              Expanded(
                child: Container(
                  width: context.width,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 8,
                        blurRadius: 15,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        height: context.height * .2,
                        child: PageView.builder(
                          controller: controller,
                          itemBuilder: (_, index) {
                            return pages[index % pages.length];
                          },
                        ),
                      ),
                      SmoothPageIndicator(
                          controller: controller,
                          count: 2,
                          effect: const WormEffect(),
                          onDotClicked: (index) {})
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
