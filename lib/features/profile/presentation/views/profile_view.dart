import 'package:flutter/material.dart';
import 'package:social_ease_app/core/common/widgets/gradient_background.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/profile/presentation/widgets/profile_app_bar.dart';
import 'package:social_ease_app/features/profile/presentation/refactors/profile_header.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const ProfileAppBar(),
      body: GradientBackground(
        image: MediaRes.dashboardGradient,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              const ProfileHeader(),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Text(
                      'Version 0.0.1',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryTextColor,
                        fontFamily: Fonts.poppins,
                      ),
                    ),
                    Text(
                      '© 2023-2024 jTrznadel. Icons by Icons8',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryTextColor,
                        fontFamily: Fonts.poppins,
                      ),
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
