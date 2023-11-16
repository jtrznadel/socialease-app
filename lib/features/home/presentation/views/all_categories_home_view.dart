import 'package:flutter/material.dart';
import 'package:social_ease_app/core/common/widgets/gradient_background.dart';
import 'package:social_ease_app/core/common/widgets/nested_back_button.dart';
import 'package:social_ease_app/core/enums/activity_category.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/activity_category/presentation/widgets/category_tile.dart';

class AllCategoriesView extends StatelessWidget {
  const AllCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    const List<ActivityCategory> categories = ActivityCategory.values;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const NestedBackButton(),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: GradientBackground(
          image: MediaRes.dashboardGradient,
          child: Padding(
            padding: const EdgeInsets.all(20.0).copyWith(top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: Fonts.montserrat,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                Text(
                  'Explore beyond all opportunities',
                  style: TextStyle(
                    color: AppColors.secondaryTextColor,
                    fontSize: 18,
                    fontFamily: Fonts.montserrat,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      final category = categories[index];
                      return CategoryTile(
                        primaryColor: AppColors.primaryColor,
                        secondaryColor: AppColors.bgColor,
                        category: category,
                        onTap: () => Navigator.of(context)
                            .pushNamed('/unknown', arguments: category),
                      );
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
