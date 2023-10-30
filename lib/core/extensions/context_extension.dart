import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/provides/user_provider.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get size => mediaQuery.size;
  double get width => size.width;
  double get height => size.height;

  UserProvider get userProvider => read<UserProvider>();

  LocalUser? get currentUser => userProvider.user;
}
