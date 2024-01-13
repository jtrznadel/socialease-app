import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/providers/location_provider.dart';
import 'package:social_ease_app/core/common/views/loading_view.dart';
import 'package:social_ease_app/core/common/widgets/content_empty.dart';
import 'package:social_ease_app/core/common/widgets/expandable_text.dart';
import 'package:social_ease_app/core/common/widgets/tag_tile.dart';
import 'package:social_ease_app/core/entities/activity_details_arguments.dart';
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
import 'package:social_ease_app/features/social_interactions/widgets/comments_list.dart';

class ActivityDetailsScreen extends StatefulWidget {
  const ActivityDetailsScreen(this.arguments, {Key? key}) : super(key: key);

  static const routeName = '/activity-details';

  final ActivityDetailsArguments arguments;

  @override
  State<ActivityDetailsScreen> createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    var toEnd =
        widget.arguments.activity.endDate!.difference(DateTime.now()).inDays;
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Activity Details',
          style: TextStyle(
            fontFamily: Fonts.poppins,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          widget.arguments.activity.image != null
              ? Image.network(
                  widget.arguments.activity.image!,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  MediaRes.defaultActivityBackground,
                  fit: BoxFit.cover,
                ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: AppColors.bgColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100.0, top: 15),
                child: ListView(
                  padding: const EdgeInsets.only(
                    top: 0,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0).copyWith(top: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.arguments.activity.title,
                            style: TextStyle(
                              fontSize: 26,
                              color: AppColors.primaryTextColor,
                              fontFamily: Fonts.poppins,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                widget.arguments.activity.category.label,
                                style: TextStyle(
                                  fontSize: 14,
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
                                String distance = provider
                                    .calculateDistance(
                                        widget.arguments.activity.latitude,
                                        widget.arguments.activity.longitude)
                                    .toString()
                                    .getDistance;
                                return Text(
                                  '${widget.arguments.activity.location} ($distance away)',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: Fonts.poppins,
                                  ),
                                );
                              })
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
                              Row(
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
                            ],
                          ),
                          const Divider(
                            color: AppColors.secondaryTextColor,
                          ),
                          Text(
                            'Reviews',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: Fonts.poppins,
                            ),
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
                                    List<ActivityComment> comments =
                                        snapshot.data!;
                                    return CommentsList(
                                      comments: comments,
                                      activityId: widget.arguments.activity.id,
                                    );
                                  }
                                }),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 20,
            left: 20,
            child: SizedBox(
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
                  activity: widget.arguments.activity,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
