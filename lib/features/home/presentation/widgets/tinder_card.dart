import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/providers/activity_of_the_day_notifier.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/core/utils/constants.dart';

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
        image: DecorationImage(
          image: context
                      .read<ActivityOfTheDayNotifier>()
                      .activityOfTheDay
                      ?.image !=
                  null
              ? NetworkImage(context
                  .read<ActivityOfTheDayNotifier>()
                  .activityOfTheDay!
                  .image!) as ImageProvider
              : const AssetImage(MediaRes.defaultActivityBackground),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.3),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
        borderRadius: BorderRadius.circular(25),
      ),
      child: isFirst
          ? Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.8),
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '${context.read<ActivityOfTheDayNotifier>().activityOfTheDay?.title}',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '${context.read<ActivityOfTheDayNotifier>().activityOfTheDay?.category.label}',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${context.read<ActivityOfTheDayNotifier>().activityOfTheDay?.description.substring(0, 25)}...',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
