import 'package:flutter/material.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/activity_category/category_info_mapper.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    Key? key,
    required this.category,
    this.onTap,
  }) : super(key: key);

  final CategoryInfo category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5).copyWith(top: 10),
        width: context.width * .3,
        height: context.width * .3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [
              AppColors.primaryColor,
              AppColors.secondaryColor,
            ],
            end: Alignment.topLeft,
            begin: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              category.image ?? MediaRes.charity,
              width: 60, // Adjusted width to stick out
              height: 70, // Adjusted height to stick out
            ),
            Text(
              category.name,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
