import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/providers/favorite_activities_notifier.dart';
import 'package:social_ease_app/core/common/app/providers/location_provider.dart';
import 'package:social_ease_app/core/entities/activity_details_arguments.dart';
import 'package:social_ease_app/core/enums/account_level.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/extensions/string_extensions.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/activity/presentation/views/activity_details_screen.dart';
import 'package:social_ease_app/features/activity/presentation/views/edit_activity_screen.dart';
import 'package:social_ease_app/features/activity/presentation/widgets/recommendation_tile.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';

class ActivityTile extends StatefulWidget {
  const ActivityTile({
    Key? key,
    required this.activity,
    required this.onTap,
    required this.editMode,
  }) : super(key: key);

  final Activity activity;
  final VoidCallback onTap;
  final bool editMode;

  @override
  State<ActivityTile> createState() => _ActivityTileState();
}

class _ActivityTileState extends State<ActivityTile> {
  LocalUser? user;

  @override
  void initState() {
    context.read<ActivityCubit>().getUser(widget.activity.createdBy);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.activity.endDate!.isAfter(DateTime.now());

    final ImageProvider<Object> image = widget.activity.image != null
        ? NetworkImage(widget.activity.image!) as ImageProvider
        : const AssetImage(MediaRes.defaultActivityBackground);

    widget.activity.tags.sort((a, b) => b.length.compareTo(a.length));
    return BlocListener<ActivityCubit, ActivityState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          setState(() {
            user = state.user;
          });
        }
      },
      child: Opacity(
        opacity: isActive ? 1 : .2,
        child: GestureDetector(
          onTap: isActive
              ? !widget.editMode
                  ? () {
                      final arguments = ActivityDetailsArguments(
                        activity: widget.activity,
                        user: user!,
                      );

                      Navigator.of(context).pushNamed(
                        ActivityDetailsScreen.routeName,
                        arguments: arguments,
                      );
                    }
                  : () {
                      Navigator.of(context).pushNamed(
                        EditActivityScreen.routeName,
                        arguments: widget.activity,
                      );
                    }
              : () {},
          child: Container(
            width: context.width,
            height: context.height * .25,
            decoration: BoxDecoration(
              color: AppColors.thirdColor,
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: image,
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0).copyWith(top: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    widget.activity.likedBy.length.toString(),
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                            if (user?.accountLevel == AccountLevel.master ||
                                user?.accountLevel == AccountLevel.veteran)
                              RecommendationTile(
                                  accountLevel: user?.accountLevel ??
                                      AccountLevel.rookie),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: user?.profilePic != null
                                      ? NetworkImage(user!.profilePic!)
                                          as ImageProvider
                                      : const AssetImage(
                                          MediaRes.defaultAvatarImage),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.bgColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    user?.fullName ?? 'Unknown',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: Fonts.poppins,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: AppColors.bgColor,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                children: [
                                  Icon(
                                    widget.activity.category.icon,
                                    size: 20,
                                  ),
                                  // const SizedBox(
                                  //   width: 5,
                                  // ),
                                  // Text(
                                  //   widget.activity.category.label,
                                  //   style: TextStyle(
                                  //     color: Colors.black,
                                  //     fontSize: 14,
                                  //     fontWeight: FontWeight.w600,
                                  //     fontFamily: Fonts.poppins,
                                  //   ),
                                  // ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: AppColors.bgColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.activity.title.length <= 30
                              ? widget.activity.title
                              : '${widget.activity.title.substring(0, 31)}...',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: Fonts.poppins,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.activity.description.length <= 50
                              ? widget.activity.description
                              : '${widget.activity.description.substring(0, 51)}...',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: Fonts.poppins,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.activity.tags.join(', ').length >= 30
                                  ? '${widget.activity.tags.join(', ').substring(0, 29)}...'
                                  : widget.activity.tags.join(', '),
                              style: TextStyle(
                                color: AppColors.secondaryTextColor,
                                fontFamily: Fonts.poppins,
                                fontSize: 12,
                              ),
                            ),
                            Consumer<LocationProvider>(
                              builder: (_, provider, __) {
                                return FutureBuilder<int>(
                                  future: provider.calculateDistance(
                                    widget.activity.latitude,
                                    widget.activity.longitude,
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        return const Text('Error');
                                      }
                                      return Text(
                                        snapshot.data.toString().getDistance,
                                        style: TextStyle(
                                          fontFamily: Fonts.poppins,
                                        ),
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
