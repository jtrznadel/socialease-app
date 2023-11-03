import 'package:flutter/material.dart';
import 'package:social_ease_app/core/common/widgets/gradient_background.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/profile/presentation/widgets/profile_app_bar.dart';
import 'package:social_ease_app/features/profile/presentation/widgets/profile_header.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ProfileAppBar(),
      body: GradientBackground(
        image: MediaRes.dashboardGradient,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              ProfileHeader(),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Text(
                      'Version 0.0.1',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.secondaryTextColor),
                    ),
                    Text(
                      '© 2023-2024 jTrznadel. Icons by Icons8',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.secondaryTextColor),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
