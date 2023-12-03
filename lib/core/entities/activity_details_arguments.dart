import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';

class ActivityDetailsArguments {
  final Activity activity;
  final LocalUser user;

  ActivityDetailsArguments({required this.activity, required this.user});
}
