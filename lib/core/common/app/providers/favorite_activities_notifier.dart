import 'package:flutter/material.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';

class FavoriteActivitiesNotifier extends ChangeNotifier {
  final List<Activity> _favoriteActivities = [];

  List<Activity> get favoriteActivities => _favoriteActivities;

  void addActivityToFavorites(Activity activity) {
    _favoriteActivities.add(activity);
    notifyListeners();
  }

  void removeFromFavoriteActivities(Activity activity) {
    if (!_favoriteActivities.contains(activity)) {
      return;
    }
    _favoriteActivities.remove(activity);
    notifyListeners();
  }
}
