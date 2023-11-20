import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/providers/user_provider.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/activity/presentation/widgets/add_activity_sheet.dart';
import 'package:social_ease_app/features/admin_panel/presentation/views/requests_management.dart';
import 'package:social_ease_app/features/profile/presentation/widgets/account_stats.dart';
import 'package:social_ease_app/features/profile/presentation/widgets/profile_action_button.dart';
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
            if (!context.currentUser!.isAdmin) ...[
              const SocialButtons(),
              const SizedBox(
                height: 15,
              ),
              const AccountStats(),
              const SizedBox(
                height: 15,
              ),
              ProfileActionButton(
                label: 'Request an Activity',
                icon: Icons.volunteer_activism_outlined,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                    showDragHandle: true,
                    elevation: 6,
                    useSafeArea: true,
                    builder: (_) => BlocProvider(
                      create: (_) => sl<ActivityCubit>(),
                      child: const AddActivitySheet(),
                    ),
                  );
                },
              ),
              ProfileActionButton(
                label: 'Manage Activities',
                icon: Icons.assignment_outlined,
                onPressed: () {},
              ),
              ProfileActionButton(
                label: 'Register an Organization',
                icon: Icons.account_balance,
                onPressed: () {},
              ),
            ] else ...[
              const Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                      height: 2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'ADMIN PANEL',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                      height: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ProfileActionButton(
                label: 'Users Management',
                icon: Icons.manage_accounts,
                onPressed: () {},
              ),
              const SizedBox(
                height: 10,
              ),
              ProfileActionButton(
                label: 'Requests Management',
                numberToCheck: 2,
                icon: Icons.manage_history,
                onPressed: () => Navigator.of(context).pushNamed(
                  RequestsManagementScreen.routeName,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ProfileActionButton(
                label: 'Reports Management',
                numberToCheck: 5,
                icon: Icons.manage_search,
                onPressed: () {},
              ),
              const SizedBox(
                height: 10,
              ),
              ProfileActionButton(
                label: 'Manage ',
                icon: Icons.manage_accounts,
                onPressed: () {},
              ),
            ]
          ],
        );
      },
    );
  }
}
