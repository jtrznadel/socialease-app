import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/providers/explore_activities_type_notifier.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';

class ExploreAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ExploreAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: Text(
        'Explore',
        style: TextStyle(
          fontSize: 26,
          color: AppColors.primaryTextColor,
          fontFamily: Fonts.montserrat,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: FlutterSwitch(
            width: 80,
            showOnOff: true,
            value: context.watch<ExploreActivitiesTypeNotifier>().exploreType,
            activeIcon: const Icon(
              Icons.explore_outlined,
            ),
            activeText: "MAP",
            inactiveIcon: const Icon(Icons.format_list_bulleted),
            inactiveText: "LIST",
            inactiveColor: Colors.grey,
            activeColor: AppColors.primaryColor,
            activeTextFontWeight: FontWeight.normal,
            inactiveTextFontWeight: FontWeight.normal,
            onToggle: (val) {
              context.read<ExploreActivitiesTypeNotifier>().setExploreType(val);
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
