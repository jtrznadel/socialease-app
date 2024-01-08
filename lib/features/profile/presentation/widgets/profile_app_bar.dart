import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/providers/tab_navigator.dart';
import 'package:social_ease_app/core/common/widgets/popup_item.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:social_ease_app/features/profile/presentation/views/edit_profile_view.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Account',
        style: TextStyle(
            fontFamily: Fonts.poppins,
            fontWeight: FontWeight.w600,
            fontSize: 26,
            color: AppColors.primaryTextColor),
      ),
      actions: [
        PopupMenuButton(
          offset: const Offset(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          itemBuilder: (_) => [
            PopupMenuItem<void>(
              onTap: () => context.push(BlocProvider(
                  create: (_) => sl<AuthBloc>(),
                  child: const EditProfileView())),
              child: const PopupItem(
                title: 'Edit profile',
                icon: Icon(
                  Icons.edit,
                ),
              ),
            ),
            PopupMenuItem<void>(
              onTap: () => context.push(const Placeholder()),
              child: const PopupItem(
                title: 'Notification',
                icon: Icon(
                  Icons.notifications,
                ),
              ),
            ),
            PopupMenuItem<void>(
              onTap: () => context.push(const Placeholder()),
              child: const PopupItem(
                title: 'Help',
                icon: Icon(
                  Icons.help_outline,
                ),
              ),
            ),
            const PopupMenuItem(
                height: 1,
                child: Divider(
                  color: Colors.grey,
                  height: 1,
                )),
            PopupMenuItem<void>(
              child: const PopupItem(
                title: 'Logout',
                icon: Icon(
                  Icons.logout,
                ),
              ),
              onTap: () async {
                final navigator = Navigator.of(context);
                await FirebaseAuth.instance.signOut();
                navigator.pushNamedAndRemoveUntil('/', (route) => false);
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
