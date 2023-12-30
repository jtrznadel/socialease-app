import 'package:flutter/material.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/features/auth/data/models/user_model.dart';
import 'package:social_ease_app/features/points/presentation/cubit/points_cubit.dart';

class UserProvider extends ChangeNotifier {
  LocalUserModel? _user;

  LocalUserModel? get user => _user;

  void initUser(LocalUserModel? user) {
    if (_user != user) _user = user;
  }

  set user(LocalUserModel? user) {
    if (_user != user) {
      _user = user;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }
}
