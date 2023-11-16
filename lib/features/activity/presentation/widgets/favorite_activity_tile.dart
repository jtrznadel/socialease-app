import 'package:flutter/material.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';

class FavoriteActivityTile extends StatelessWidget {
  const FavoriteActivityTile({super.key, required this.favoriteActivity});

  final Activity favoriteActivity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      height: context.height * .18,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.secondaryColor,
            AppColors.primaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Image.asset(
              MediaRes.activityOfTheDay,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0).copyWith(top: 20),
              child: Column(
                children: [
                  Text(
                    favoriteActivity.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
