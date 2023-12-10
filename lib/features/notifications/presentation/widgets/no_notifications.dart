import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:social_ease_app/core/res/media_res.dart';

class NoNotifications extends StatelessWidget {
  const NoNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(MediaRes.noNotifications),
    );
  }
}
