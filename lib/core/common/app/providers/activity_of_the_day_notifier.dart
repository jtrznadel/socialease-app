import 'package:flutter/foundation.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';

class ActivityOfTheDayNotifier extends ChangeNotifier {
  Activity? _activityOfTheDay;
  List<Activity>? _activitiesOfTheDay;

  Activity? get activityOfTheDay => _activityOfTheDay;
  List<Activity>? get activitiesOfTheDay => _activitiesOfTheDay;

  void setActivityOfTheDay(Activity activity) {
    _activityOfTheDay ??= activity;
    notifyListeners();
  }

  void setActivitiesOfTheDay(List<Activity> activities) {
    _activitiesOfTheDay ??= activities;
    notifyListeners();
  }
}
