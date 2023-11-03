import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/providers/user_provider.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/profile/presentation/widgets/account_stats.dart';
import 'package:social_ease_app/features/profile/presentation/widgets/social_buttons.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, provider, __) {
        final user = provider.user;
        final image =
            user?.profileAvatar == null || user!.profileAvatar!.isEmpty
                ? null
                : user.profileAvatar;
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            image != null
                ? CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(image),
                  )
                : const Image(
                    height: 120,
                    image: AssetImage(
                      MediaRes.defaultAvatarImage,
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            Text(
              user?.fullName ?? 'Hey, Stranger',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTextColor),
            ),
            if (user?.bio != null && user!.bio!.isNotEmpty) ...[
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.width * .15),
                child: Text(
                  user.bio!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.secondaryTextColor),
                ),
              ),
            ],
            const SizedBox(
              height: 15,
            ),
            const SocialButtons(),
            const SizedBox(
              height: 15,
            ),
            const AccountStats()
          ],
        );
      },
    );
  }
}
