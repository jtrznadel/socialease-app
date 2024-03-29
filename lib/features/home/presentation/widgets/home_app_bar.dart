import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/providers/user_provider.dart';
import 'package:social_ease_app/core/common/widgets/user_profile_modal.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/home/presentation/widgets/notification_bell.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: RichText(
        text: TextSpan(
            text: 'Hello, ',
            style: TextStyle(
              fontSize: 22,
              color: AppColors.primaryTextColor,
              fontWeight: FontWeight.w400,
              fontFamily: Fonts.poppins,
            ),
            children: [
              TextSpan(
                text: (context.watch<UserProvider>().user!.fullName)
                    .split(' ')[0],
                style: TextStyle(
                  fontSize: 26,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontFamily: Fonts.poppins,
                ),
              )
            ]),
      ),
      actions: [
        const Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: NotificationBell(),
        ),
        Consumer<UserProvider>(
          builder: (_, provider, __) {
            return Padding(
              padding: const EdgeInsets.only(right: 15),
              child: GestureDetector(
                onTap: () {
                  showUserProfileModal(context, context.currentUser!);
                },
                child: CircleAvatar(
                  backgroundImage: provider.user!.profilePic != null
                      ? NetworkImage(provider.user!.profilePic!)
                      : const AssetImage(MediaRes.defaultAvatarImage)
                          as ImageProvider,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
