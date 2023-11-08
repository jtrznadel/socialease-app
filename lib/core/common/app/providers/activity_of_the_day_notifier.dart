import 'package:flutter/foundation.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';

class ActivityOfTheDayNotifier extends ChangeNotifier {
  Activity? _activityOfTheDay;
  DateTime? _dayOfRefresh;

  Activity? get activityOfTheDay => _activityOfTheDay;

  void setActivityOfTheDay(Activity activity) {
    _dayOfRefresh = DateTime.now();
    _activityOfTheDay ??= activity;
    notifyListeners();
  }
}
