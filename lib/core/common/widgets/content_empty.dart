import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/media_res.dart';

class ContentEmpty extends StatelessWidget {
  const ContentEmpty({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LottieBuilder.asset(
          MediaRes.searchNotFound,
          width: context.height * .3,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.secondaryTextColor,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
