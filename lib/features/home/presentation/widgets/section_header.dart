import 'package:flutter/material.dart';
import 'package:social_ease_app/core/res/colors.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.sectionTitle,
    required this.seeAll,
    required this.onSeeAll,
  });

  final String sectionTitle;
  final bool seeAll;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          sectionTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (seeAll)
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              splashFactory: NoSplash.splashFactory,
            ),
            child: const Text(
              'See All',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: AppColors.primaryTextColor,
              ),
            ),
          ),
      ],
    );
  }
}
