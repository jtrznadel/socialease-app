import 'package:flutter/material.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/presentation/views/activity_details_screen.dart';
import 'package:social_ease_app/features/activity/presentation/widgets/activity_tile.dart';

class ExploreList extends StatelessWidget {
  const ExploreList({super.key, required this.activities});

  final List<Activity> activities;

  @override
  Widget build(BuildContext context) {
    final allActivities = activities
        .where(((element) => element.createdBy != context.currentUser!.uid))
        .toList();
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 10,
          );
        },
        itemCount: allActivities.length,
        itemBuilder: (BuildContext context, int index) {
          Activity activity = allActivities[index];
          return ActivityTile(
            activity: activity,
            onTap: () => Navigator.of(context).pushNamed(
              ActivityDetailsScreen.routeName,
              arguments: activity,
            ),
          );
        },
      ),
    );
  }
}

class Actvity {}
