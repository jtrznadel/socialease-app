import 'package:flutter/material.dart';
import 'package:social_ease_app/core/enums/activity_category.dart';

class ActivitiesListView extends StatefulWidget {
  const ActivitiesListView({super.key, this.category});

  final ActivityCategory? category;

  @override
  State<ActivitiesListView> createState() => _ActivitiesListViewState();
}

class _ActivitiesListViewState extends State<ActivitiesListView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
