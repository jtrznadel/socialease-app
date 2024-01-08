import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/features/home/presentation/widgets/user_of_the_all_time.dart';
import 'package:social_ease_app/features/home/presentation/widgets/user_of_the_month.dart';
import 'package:social_ease_app/features/points/presentation/cubit/points_cubit.dart';

class UserRankingSection extends StatefulWidget {
  const UserRankingSection({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final PageController controller;

  @override
  State<UserRankingSection> createState() => _UserRankingSectionState();
}

class _UserRankingSectionState extends State<UserRankingSection> {
  final pages = [
    UserOfTheMonth(),
    UserOfTheAllTime(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: context.height * .2,
          child: PageView.builder(
            controller: widget.controller,
            itemCount: pages.length,
            itemBuilder: (_, index) {
              return pages[index];
            },
          ),
        ),
        SmoothPageIndicator(
          controller: widget.controller,
          count: pages.length,
          effect: const WormEffect(
            dotHeight: 8,
          ),
          onDotClicked: (index) {},
        ),
      ],
    );
  }
}
