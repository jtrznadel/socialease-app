import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/providers/user_provider.dart';
import 'package:social_ease_app/core/enums/account_level.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/activity/presentation/widgets/add_activity_sheet.dart';
import 'package:social_ease_app/features/admin_panel/presentation/views/activities_management.dart';
import 'package:social_ease_app/features/admin_panel/presentation/views/requests_management.dart';
import 'package:social_ease_app/features/admin_panel/presentation/widgets/requests_management_button.dart';
import 'package:social_ease_app/features/auth/domain/entites/social_media_links.dart';
import 'package:social_ease_app/features/points/presentation/cubit/points_cubit.dart';
import 'package:social_ease_app/features/profile/presentation/widgets/account_stats.dart';
import 'package:social_ease_app/features/profile/presentation/widgets/profile_action_button.dart';
import 'package:social_ease_app/features/profile/presentation/widgets/social_buttons.dart';
import 'package:social_ease_app/features/reports/presentation/cubit/report_cubit.dart';
import 'package:social_ease_app/features/reports/presentation/views/reports_management_screen.dart';
import 'package:social_ease_app/features/reports/presentation/widgets/report_management_button.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  void initState() {
    context.read<PointsCubit>().getPoints(context.currentUser!.uid);
    //context.read<PointsCubit>().getLevel(context.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, provider, __) {
        final user = provider.user;
        final image = user?.profilePic == null || user!.profilePic!.isEmpty
            ? null
            : user.profilePic;
        final points = user?.points ?? 0;
        final level = user?.accountLevel ?? AccountLevel.rookie;
        final mediaLinks = user?.socialMediaLinks ?? SocialMediaLinks.empty();
        return Column(
          children: [
            SizedBox(
              height: context.width * .45,
              width: context.width * .45,
              child: DashedCircularProgressBar.square(
                dimensions: 350,
                progress: points.toDouble(),
                maxProgress: user!.accountLevel.maxRange.toDouble(),
                startAngle: 0,
                foregroundColor: level.color,
                backgroundColor: AppColors.secondaryTextColor.withOpacity(.6),
                foregroundStrokeWidth: 7,
                backgroundStrokeWidth: 7,
                foregroundGapSize: 8,
                foregroundDashSize: 32,
                backgroundGapSize: 8,
                backgroundDashSize: 32,
                animation: true,
                child: Container(
                  margin: const EdgeInsets.all(15),
                  child: image != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            image,
                          ),
                        )
                      : const Image(
                          height: 120,
                          image: AssetImage(
                            MediaRes.defaultAvatarImage,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              user.fullName ?? 'Hey, Stranger',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryTextColor,
                fontFamily: Fonts.poppins,
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: level.color,
                  fontFamily: Fonts.poppins,
                ),
                children: [
                  TextSpan(text: level.label),
                  TextSpan(
                    text: ' ($points/${level.maxRange})',
                    style: TextStyle(
                      color: AppColors.secondaryTextColor,
                      fontSize: 14,
                      fontFamily: Fonts.poppins,
                    ),
                  ),
                ],
              ),
            ),
            if (user.bio != null && user.bio!.isNotEmpty) ...[
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.width * .15),
                child: Text(
                  user.bio!,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.secondaryTextColor,
                    fontFamily: Fonts.poppins,
                  ),
                ),
              ),
            ],
            const SizedBox(
              height: 15,
            ),
            if (!context.currentUser!.isAdmin) ...[
              SocialButtons(
                mediaLinks: mediaLinks,
              ),
              const SizedBox(
                height: 15,
              ),
              BlocBuilder<PointsCubit, PointsState>(
                builder: (context, state) {
                  if (state is PointsError) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else if (state is PointsLoaded) {
                    return BlocProvider(
                      create: (context) => sl<PointsCubit>(),
                      child: AccountStats(
                        points: state.points,
                        activityCounter: user.createdActivities.length +
                            user.completedActivities.length,
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
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
                onPressed: () => Navigator.of(context).pushNamed(
                  ActivitiesManagementScreen.routeName,
                ),
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
              BlocProvider(
                create: (context) => sl<ActivityCubit>(),
                child: const RequestsManagementButton(),
              ),
              const SizedBox(
                height: 10,
              ),
              BlocProvider(
                create: (context) => sl<ReportCubit>(),
                child: const ReportsManagementButton(),
              ),
            ]
          ],
        );
      },
    );
  }
}
