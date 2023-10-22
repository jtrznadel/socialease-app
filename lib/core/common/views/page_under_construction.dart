import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:social_ease_app/core/common/widgets/gradient_background.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';

class PageUnderConstruction extends StatelessWidget {
  const PageUnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GradientBackground(
      image: MediaRes.onBoardingGradient,
      child: Center(
          child: SizedBox(
              width: context.width * .8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(MediaRes.underConstruction),
                  Text('Page is under construction',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: Fonts.lato))
                ],
              ))),
    ));
  }
}
