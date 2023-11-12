import 'package:flutter/material.dart';
import 'package:social_ease_app/core/common/widgets/tag_tile.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';

class ActivityTile extends StatelessWidget {
  const ActivityTile({super.key, required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            width: context.width,
            height: context.height * .26,
            decoration: BoxDecoration(
              color: AppColors.thirdColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: activity.image != null
                ? Image.network(
                    activity.image!,
                    fit: BoxFit.fill,
                  )
                : Image.asset(MediaRes.defaultActivityBackground),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            width: context.width,
            height: context.height * .12,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.9),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0).copyWith(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    activity.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: Fonts.montserrat,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    activity.description,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: Fonts.montserrat,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ...activity.tags.take(3).map((tag) => TagTile(
                                tag: tag,
                              )),
                        ],
                      ),
                      const Text('300 m')
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
            right: 5,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.favorite_border_outlined,
                size: 30,
                color: Colors.white,
              ),
            ))
      ],
    );
  }
}
