import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/common/app/providers/activity_of_the_day_notifier.dart';
import 'package:social_ease_app/core/common/views/loading_view.dart';
import 'package:social_ease_app/core/common/widgets/blank_tile.dart';
import 'package:social_ease_app/core/common/widgets/content_empty.dart';
import 'package:social_ease_app/core/common/widgets/gradient_background.dart';
import 'package:social_ease_app/core/enums/activity_status.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/core/utils/core_utils.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/activity/presentation/widgets/ongoing_activities_section.dart';
import 'package:social_ease_app/features/home/presentation/refactors/home_header.dart';
import 'package:social_ease_app/features/home/presentation/widgets/user_of_the_all_time.dart';
import 'package:social_ease_app/features/home/presentation/widgets/user_of_the_month.dart';
import 'package:social_ease_app/features/points/presentation/cubit/points_cubit.dart';
import 'package:social_ease_app/features/points/presentation/widgets/user_ranking.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final rankingController = PageController();
  final activityController = PageController();

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
    rankingController.dispose();
    activityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          final ongoingActivities = state.activities
              .where((activity) =>
                  context.currentUser!.ongoingActivities.contains(activity.id))
              .toList();
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                height: context.height * .32,
                width: context.width,
                color: Colors.white,
                child: const HomeHeader(),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: GradientBackground(
                    image: MediaRes.dashboardGradient,
                    child: Container(
                      width: context.width,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0,
                                  top: 5.0,
                                ),
                                child: Text(
                                  "Rankings",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primaryTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: Fonts.poppins,
                                  ),
                                ),
                              ),
                              BlocProvider(
                                create: (context) => sl<PointsCubit>(),
                                child: UserRankingSection(
                                  controller: rankingController,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text(
                                  "Ongoing initiatives",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primaryTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: Fonts.poppins,
                                  ),
                                ),
                              ),
                              ongoingActivities.isNotEmpty
                                  ? OngoingActivitiesSection(
                                      activityController: activityController,
                                      ongoingActivities: ongoingActivities)
                                  : const BlankTile(
                                      text:
                                          'At this moment you are not participating in any initiatives')
                            ],
                          ),
                        ],
                      ),
                    ),
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
