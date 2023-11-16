import 'package:flutter/foundation.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';

class ActivityOfTheDayNotifier extends ChangeNotifier {
  Activity? _activityOfTheDay;

  Activity? get activityOfTheDay => _activityOfTheDay;

  void setActivityOfTheDay(Activity activity) {
    _activityOfTheDay ??= activity;
    notifyListeners();
  }
}
