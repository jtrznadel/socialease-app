import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/provides/tab_navigator.dart';
import 'package:social_ease_app/core/common/views/persistent_view.dart';

class DashboardController extends ChangeNotifier {
  List<int> _indexHistory = [0];
  final List<Widget> _screens = [
    ChangeNotifierProvider(
      create: (_) => TabNavigator(TabItem(child: const Text('View 1'))),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(TabItem(child: const Text('View 2'))),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(TabItem(child: const Text('View 3'))),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(TabItem(child: const Text('View 4'))),
      child: const PersistentView(),
    ),
  ];

  List<Widget> get screens => _screens;
  int _currentIndex = 2;

  int get currentIndex => _currentIndex;

  void changeIndex(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    _indexHistory.add(index);
    notifyListeners();
  }

  void goBack() {
    if (_indexHistory.length == 1) return;
    _indexHistory.removeLast();
    _currentIndex = _indexHistory.last;
    notifyListeners();
  }

  void resetIndex() {
    _indexHistory = [0];
    _currentIndex = 0;
    notifyListeners();
  }
}
