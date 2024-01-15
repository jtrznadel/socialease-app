import 'package:flutter/material.dart';
import 'package:social_ease_app/core/common/widgets/stats_element.dart';
import 'package:social_ease_app/core/common/widgets/user_profile_modal.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/common/widgets/stats_element.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/core/utils/core_utils.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';
import 'package:social_ease_app/features/points/presentation/cubit/points_cubit.dart';

class UserOfTheAllTime extends StatefulWidget {
  const UserOfTheAllTime({
    Key? key,
  }) : super(key: key);

  @override
  State<UserOfTheAllTime> createState() => _UserOfTheAllTimeState();
}

class _UserOfTheAllTimeState extends State<UserOfTheAllTime> {
  String? leaderId;

  @override
  void initState() {
    context.read<PointsCubit>().getAllTimeRanking();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PointsCubit, PointsState>(
      listener: (context, state) {
        if (state is PointsError) {
          CoreUtils.showSnackBar(context, state.message);
        } else if (state is AllTimeRankingLoaded) {
          final ranking = state.allTimeRanking
            ..sort((a, b) => a.position.compareTo(b.position));
          setState(() {
            leaderId = ranking.isNotEmpty ? ranking.first.userId : null;
          });
        }
      },
      builder: (context, state) {
        if (state is LoadingAllTimeRanking) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AllTimeRankingLoaded) {
          return BlocProvider(
            create: (context) => sl<ActivityCubit>(),
            child: AllTimeLeaderTile(
              userId: leaderId!,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class AllTimeLeaderTile extends StatefulWidget {
  const AllTimeLeaderTile({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<AllTimeLeaderTile> createState() => _AllTimeLeaderTileState();
}

class _AllTimeLeaderTileState extends State<AllTimeLeaderTile> {
  LocalUser? user;
  @override
  void initState() {
    context.read<ActivityCubit>().getUser(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ActivityCubit, ActivityState>(
      listener: (context, state) {
        if (state is ActivityError) {
          CoreUtils.showSnackBar(context, state.message);
        } else if (state is UserLoaded) {
          setState(() {
            user = state.user;
          });
        }
      },
      builder: (context, state) {
        if (state is GettingUser) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserLoaded) {
          return GestureDetector(
            onTap: () {
              if (user != null) {
                showUserProfileModal(context, user!);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                image: const DecorationImage(
                  image: AssetImage(MediaRes.goldenBg),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(user!.profilePic!),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        user?.fullName ?? 'unknown',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: Fonts.poppins,
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "User of The All-time",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: Fonts.poppins,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          StatsElement(
                            color: Colors.yellow,
                            icon: Icons.star,
                            value: '${user!.points}',
                            text: 'points',
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          StatsElement(
                            color: Colors.lime,
                            icon: Icons.celebration,
                            value: '${user!.completedActivities.length}',
                            text: 'completed',
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          StatsElement(
                            color: Colors.green,
                            icon: Icons.local_activity,
                            text: 'created',
                            value: '${user!.createdActivities.length}',
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        }
        return const Text('test');
      },
    );
  }
}
