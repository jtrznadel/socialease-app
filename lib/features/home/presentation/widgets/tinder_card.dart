import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/providers/activity_of_the_day_notifier.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/media_res.dart';

class TinderCard extends StatelessWidget {
  const TinderCard({super.key, required this.isFirst, this.color});

  final bool isFirst;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      height: 137,
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        gradient: isFirst
            ? const LinearGradient(
                colors: [
                  AppColors.primaryColor,
                  AppColors.secondaryColor,
                ],
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.3),
            offset: const Offset(0, 4),
            blurRadius: 5,
          ),
        ],
        borderRadius: BorderRadius.circular(25),
      ),
      child: isFirst
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${context.read<ActivityOfTheDayNotifier>().activityOfTheDay?.title}',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                const Text('SDS')
              ],
            )
          : null,
    );
  }
}
