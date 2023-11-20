import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/providers/favorite_activities_notifier.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/features/activity/presentation/widgets/favorite_activity_tile.dart';
import 'package:social_ease_app/features/home/presentation/views/all_favorites_view.dart';
import 'package:social_ease_app/features/home/presentation/widgets/section_header.dart';

class HomeFavorites extends StatelessWidget {
  const HomeFavorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          sectionTitle: 'Followed activities',
          seeAll: true,
          onSeeAll: (() => context.push(const AllFavoritesView())),
        ),
        // Text(
        //   'Check Your Favorite',
        //   style: TextStyle(
        //       color: AppColors.secondaryTextColor,
        //       fontWeight: FontWeight.w500,
        //       fontFamily: Fonts.poppins),
        // ),
        const SizedBox(
          height: 10,
        ),
        Consumer<FavoriteActivitiesNotifier>(builder: (_, provider, __) {
          final favoriteActivity = provider.favoriteActivities.isEmpty
              ? null
              : provider.favoriteActivities.first;
          return favoriteActivity != null
              ? FavoriteActivityTile(
                  favoriteActivity: favoriteActivity,
                )
              : const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Center(
                    child: Text(
                      'You have not been added any activity to favorite',
                      style: TextStyle(
                        color: AppColors.secondaryTextColor,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
        })
      ],
    );
  }
}
