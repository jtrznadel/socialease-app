import 'package:flutter/material.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';

import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';

class TinderCard extends StatelessWidget {
  const TinderCard(
      {super.key, required this.isFirst, this.color, required this.activity});

  final bool isFirst;
  final Color? color;
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      height: 137,
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: activity.image != null
              ? NetworkImage(activity.image!) as ImageProvider
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
      child: Container(
        width: context.width * .8,
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
              activity.title.length < 25
                  ? activity.title
                  : '${activity.title.substring(0, 25)}...',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: Fonts.poppins,
              ),
              maxLines: 2,
            ),
            Row(
              children: [
                Text(
                  activity.category.label.length < 20
                      ? activity.category.label
                      : '${activity.category.label.substring(0, 20)}...',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    fontFamily: Fonts.poppins,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                Icon(activity.category.icon)
              ],
            ),
            Text(
              activity.location,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: Fonts.poppins,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
