import 'package:flutter/material.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/features/on_boarding/domain/entities/page_content.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({required this.pageContent, super.key});

  final PageContent pageContent;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          pageContent.image,
          height: context.height * .3,
        ),
        SizedBox(
          height: context.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.all(20).copyWith(bottom: 0),
          child: Column(
            children: [
              Text(
                pageContent.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: Fonts.aeonik,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: context.height * 0.02,
              ),
              Text(
                pageContent.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        )
      ],
    );
  }
}
