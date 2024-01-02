import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/providers/explore_activities_type_notifier.dart';
import 'package:social_ease_app/core/common/views/loading_view.dart';
import 'package:social_ease_app/core/common/widgets/content_empty.dart';
import 'package:social_ease_app/core/enums/activity_category.dart';
import 'package:social_ease_app/core/enums/activity_status.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/activity/presentation/refactors/activities_list.dart';
import 'package:social_ease_app/features/activity/presentation/refactors/activities_map.dart';
import 'package:social_ease_app/features/dashboard/presentation/utils/dashboard_utils.dart';

class ExploreBody extends StatefulWidget {
  const ExploreBody({super.key});

  @override
  State<ExploreBody> createState() => _ExploreBodyState();
}

class _ExploreBodyState extends State<ExploreBody> {
  final List<ActivityCategory> categories = ActivityCategory.values;
  late List<ActivityCategory> selectedCategories;

  void getCategories() {
    selectedCategories = List.from(categories);
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  List<Activity> filterActivities(List<Activity> allActivities) {
    return allActivities
        .where((activity) {
          return selectedCategories.contains(activity.category);
        })
        .toList()
        .where((activity) =>
            activity.createdBy != context.currentUser!.uid &&
            activity.status == ActivityStatus.active.name &&
            activity.endDate!.isAfter(DateTime.now()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Activity>>(
      stream: DashboardUtils.activitiesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingView();
        } else if (snapshot.hasError) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: Text(
                'Error loading activities',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.secondaryTextColor,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          List<Activity> activities = snapshot.data!;
          List<Activity> filteredActivities = filterActivities(activities);

          return Consumer<ExploreActivitiesTypeNotifier>(
            builder: (_, provider, __) {
              bool exploreType = provider.exploreType;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategories.clear();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            child: const Icon(
                              Icons.cancel,
                              size: 30,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [
                                Colors.white.withOpacity(.0),
                                Colors.white,
                                Colors.white,
                                Colors.white.withOpacity(.0),
                              ],
                              stops: const [0, 0.05, 0.95, 1],
                              begin: Alignment.topLeft,
                              end: Alignment.topRight,
                              tileMode: TileMode.mirror,
                            ).createShader(bounds);
                          },
                          child: SizedBox(
                            width: context.width - 80,
                            height: context.height * .05,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              itemBuilder: (BuildContext context, int index) {
                                var category = categories[index];
                                bool isSelected =
                                    selectedCategories.contains(category);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      List<ActivityCategory> updatedCategories =
                                          List.from(selectedCategories);
                                      setState(() {
                                        if (updatedCategories
                                            .contains(category)) {
                                          updatedCategories.remove(category);
                                        } else {
                                          updatedCategories.add(category);
                                        }
                                        selectedCategories = updatedCategories;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primaryColor
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(category.icon),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(category.label),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (filteredActivities.isEmpty)
                    const Expanded(
                      child: ContentEmpty(
                        text: 'No activities found',
                      ),
                    )
                  else
                    Expanded(
                      child: exploreType
                          ? ExploreMap(
                              activities: filteredActivities,
                            )
                          : ExploreList(
                              key: UniqueKey(),
                              activities: filteredActivities,
                            ),
                    ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
