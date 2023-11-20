import 'package:flutter/material.dart';
import 'package:social_ease_app/core/enums/activity_category.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/media_res.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    Key? key,
    required this.category,
    this.onTap,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(key: key);

  final ActivityCategory category;
  final VoidCallback? onTap;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5).copyWith(top: 10),
        width: context.width * .3,
        height: context.width * .3,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: const Offset(2, 4),
                blurRadius: 10,
                color: Colors.black.withOpacity(.5))
          ],
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              primaryColor,
              secondaryColor,
            ],
            end: Alignment.topLeft,
            begin: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              category.image,
              width: 60,
              height: 70,
            ),
            Text(
              category.label,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
