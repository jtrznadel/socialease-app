import 'package:flutter/material.dart';
import 'package:social_ease_app/features/activity_category/category_info_mapper.dart';
import 'package:social_ease_app/features/activity_category/presentation/widgets/category_tile.dart';
import 'package:social_ease_app/core/enums/activity_category.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/features/home/presentation/views/activities_list_view.dart';
import 'package:social_ease_app/features/home/presentation/views/all_categories_home_view.dart';
import 'package:social_ease_app/features/home/presentation/widgets/section_header.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    const List<ActivityCategory> categories = ActivityCategory.values;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          sectionTitle: 'Top Categories',
          seeAll: categories.length > 3,
          onSeeAll: (() => context.push(const AllCategoriesView())),
        ),
        Text(
          'Check our trending categories',
          style: TextStyle(
              color: AppColors.secondaryTextColor,
              fontWeight: FontWeight.w500,
              fontFamily: Fonts.poppins),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: categories
              .take(3)
              .map((category) => CategoryTile(
                    category: CategoryInfoMapper.categoryInfo[category]!,
                    onTap: (() => context.push(const ActivitiesListView())),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
