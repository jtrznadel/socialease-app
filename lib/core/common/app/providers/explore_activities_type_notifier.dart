import 'package:flutter/material.dart';

class ExploreActivitiesTypeNotifier extends ChangeNotifier {
  bool _exploreType = true;

  bool get exploreType => _exploreType;

  void setExploreType(bool value) {
    _exploreType = value;
    notifyListeners();
  }
}
