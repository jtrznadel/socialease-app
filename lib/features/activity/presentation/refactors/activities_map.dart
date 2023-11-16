import 'package:flutter/material.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';

class ExploreMap extends StatelessWidget {
  const ExploreMap({super.key, required this.activities});

  final List<Activity> activities;

  @override
  Widget build(BuildContext context) {
    return const Text('Map');
  }
}
