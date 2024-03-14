import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/providers/location_provider.dart';
import 'package:social_ease_app/core/common/views/loading_view.dart';
import 'package:social_ease_app/core/common/widgets/content_empty.dart';
import 'package:social_ease_app/core/common/widgets/expandable_text.dart';
import 'package:social_ease_app/core/common/widgets/tag_tile.dart';
import 'package:social_ease_app/core/common/widgets/user_profile_modal.dart';
import 'package:social_ease_app/core/entities/activity_details_arguments.dart';
import 'package:social_ease_app/core/enums/points_value_enum.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/extensions/string_extensions.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/features/activity/domain/entities/comment.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/activity/presentation/widgets/activity_action_button.dart';
import 'package:social_ease_app/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:social_ease_app/features/dashboard/presentation/utils/dashboard_utils.dart';
import 'package:social_ease_app/features/points/presentation/cubit/points_cubit.dart';
import 'package:social_ease_app/features/social_interactions/widgets/comments_list.dart';

class ActivityDetailsScreen extends StatefulWidget {
  const ActivityDetailsScreen(this.arguments, {Key? key}) : super(key: key);

  static const routeName = '/activity-details';

  final ActivityDetailsArguments arguments;

  @override
  State<ActivityDetailsScreen> createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLikedByUser =
        widget.arguments.activity.likedBy.contains(widget.arguments.user.uid);
    var toEnd =
        widget.arguments.activity.endDate!.difference(DateTime.now()).inDays;
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            'Activity Details',
            style: TextStyle(
              color: Colors.white,
              fontFamily: Fonts.poppins,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(children: [
              widget.arguments.activity.image != null
                  ? Image.network(
                      widget.arguments.activity.image!,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      MediaRes.defaultActivityBackground,
                      fit: BoxFit.cover,
                    ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.arguments.activity.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 22,
                        color: AppColors.primaryTextColor,
                        fontFamily: Fonts.poppins,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.arguments.activity.category.label,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.primaryTextColor,
                                fontFamily: Fonts.poppins,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(widget.arguments.activity.category.icon),
                          ],
                        ),
                        IconButton(
                            onPressed: () {
                              context.read<ActivityCubit>().likeActivity(
                                  activityId: widget.arguments.activity.id,
                                  userId: widget.arguments.user.uid);
                              int points = PointsValue.communityActivity.value *
                                  context.currentUser!.accountLevel.multiplier
                                      .toInt();
                              context.read<PointsCubit>().addPoints(
                                  userId: context.currentUser!.uid,
                                  points: points);
                            },
                            icon: Icon(
                              !isLikedByUser
                                  ? Icons.favorite_outline_outlined
                                  : Icons.favorite,
                              color: !isLikedByUser ? Colors.black : Colors.red,
                              size: 30,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      color: AppColors.primaryTextColor,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ExpandableText(
                      context,
                      text: widget.arguments.activity.description,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      spacing: 5.0,
                      runSpacing: 8.0,
                      children: [
                        ...widget.arguments.activity.tags
                            .take(3)
                            .map((tag) => TagTile(
                                  tag: tag,
                                )),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Consumer<LocationProvider>(
                          builder: (_, provider, __) {
                            return FutureBuilder<int>(
                              future: provider.calculateDistance(
                                widget.arguments.activity.latitude,
                                widget.arguments.activity.longitude,
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasError) {
                                    return const Text('Error');
                                  }
                                  return Text(
                                    '${widget.arguments.activity.location} (${snapshot.data.toString().getDistance} away)',
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
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          '${DateFormat.yMMMd().format(widget.arguments.activity.startDate!)}-${DateFormat.yMMMd().format(widget.arguments.activity.endDate!)} ($toEnd days left)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: Fonts.poppins,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Organizer:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: Fonts.poppins,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showUserProfileModal(
                                context, widget.arguments.user);
                          },
                          child: Row(
                            children: [
                              Text(
                                widget.arguments.user.fullName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: Fonts.poppins,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              CircleAvatar(
                                backgroundImage:
                                    widget.arguments.user.profilePic != null
                                        ? NetworkImage(widget.arguments.user
                                            .profilePic!) as ImageProvider
                                        : const AssetImage(
                                            MediaRes.defaultAvatarImage),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: AppColors.secondaryTextColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Reviews',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: Fonts.poppins,
                          ),
                        ),
                        StreamBuilder(
                          stream: DashboardUtils.commentsStream(
                              widget.arguments.activity.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const LoadingView();
                            } else if (snapshot.hasError) {
                              return const Text('No comments');
                            } else {
                              List<ActivityComment> comments = snapshot.data!;
                              return Row(
                                children: [
                                  Text(comments.length.toString()),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Icon(
                                    Icons.forum,
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: context.height * .3,
                      child: StreamBuilder(
                          stream: DashboardUtils.commentsStream(
                              widget.arguments.activity.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const LoadingView();
                            } else if (snapshot.hasError) {
                              return const ContentEmpty(
                                  text: 'No comments found');
                            } else {
                              List<ActivityComment> comments = snapshot.data!;
                              return CommentsList(
                                comments: comments,
                                activityId: widget.arguments.activity.id,
                              );
                            }
                          }),
                    ),
                    SizedBox(
                      height: context.height * .1,
                    )
                  ],
                ),
              ),
            ]),
          ),
          Positioned(
            bottom: 30,
            right: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              width: context.width,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => sl<ActivityCubit>(),
                  ),
                  BlocProvider(
                    create: (_) => sl<ChatCubit>(),
                  ),
                ],
                child: ActivityActionButton(
                  notifyParent: refresh,
                  activity: widget.arguments.activity,
                ),
              ),
            ),
          ),
        ]));
  }
}
