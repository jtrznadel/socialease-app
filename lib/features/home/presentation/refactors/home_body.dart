import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/common/app/providers/activity_of_the_day_notifier.dart';
import 'package:social_ease_app/core/common/views/loading_view.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/utils/core_utils.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/home/presentation/refactors/home_categories.dart';
import 'package:social_ease_app/features/home/presentation/refactors/home_favorites.dart';
import 'package:social_ease_app/features/home/presentation/refactors/home_header.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
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
    return BlocConsumer<ActivityCubit, ActivityState>(
      listener: (_, state) {
        if (state is ActivityError) {
          CoreUtils.showSnackBar(context, state.message);
        } else if (state is ActivitiesLoaded && state.activities.isNotEmpty) {
          final activities = state.activities..shuffle();
          final activityOfTheDay = activities.first;
          context
              .read<ActivityOfTheDayNotifier>()
              .setActivityOfTheDay(activityOfTheDay);
        }
      },
      builder: ((context, state) {
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
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            children: const [
              HomeHeader(),
              HomeCategories(),
              HomeFavorites(),
            ],
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
