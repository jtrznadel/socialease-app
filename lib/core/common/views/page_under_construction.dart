import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:social_ease_app/core/common/widgets/gradient_background.dart';
import 'package:social_ease_app/core/res/media_res.dart';

class PageUnderConstruction extends StatelessWidget {
  const PageUnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GradientBackground(
      image: MediaRes.onBoardingGradient,
      child: Center(child: Lottie.asset(MediaRes.underConstruction)),
    ));
  }
}
