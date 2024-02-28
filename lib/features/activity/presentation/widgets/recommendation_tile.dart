import 'package:flutter/material.dart';
import 'package:social_ease_app/core/enums/account_level.dart';
import 'package:social_ease_app/core/res/fonts.dart';

class RecommendationTile extends StatelessWidget {
  final AccountLevel accountLevel;
  const RecommendationTile({super.key, required this.accountLevel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: accountLevel.color,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Recommended',
            style: TextStyle(
              color: Colors.white,
              fontFamily: Fonts.lato,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            width: 2,
          ),
          const Icon(
            Icons.star,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
