import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/common/widgets/expandable_text.dart';
import 'package:social_ease_app/core/common/widgets/tag_tile.dart';
import 'package:social_ease_app/core/entities/activity_details_arguments.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/activity/presentation/widgets/activity_action_button.dart';
import 'package:social_ease_app/features/chat/presentation/cubit/chat_cubit.dart';

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
    bool isCurrentUserMember =
        widget.arguments.activity.members.contains(context.currentUser!.uid);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.bgColor.withOpacity(.8),
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Text('Activity Details'),
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
                color: Colors.white.withOpacity(0.9),
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
              child: ListView(
                padding: const EdgeInsets.only(top: 10),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0).copyWith(top: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              widget.arguments.user.fullName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              backgroundImage:
                                  widget.arguments.user.profilePic != null
                                      ? NetworkImage(
                                              widget.arguments.user.profilePic!)
                                          as ImageProvider
                                      : const AssetImage(
                                          MediaRes.defaultAvatarImage),
                            ),
                          ],
                        ),
                        Text(
                          widget.arguments.activity.title,
                          style: TextStyle(
                            fontSize: 26,
                            fontFamily: Fonts.lato,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Icon(widget.arguments.activity.category.icon),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.arguments.activity.category.label,
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.secondaryTextColor,
                                fontFamily: Fonts.lato,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
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
                        const Row(
                          children: [
                            Text(
                              'Location: ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Sunrises Avenue 3/5, 243-54 LA',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Row(
                          children: [
                            Text(
                              'Time: ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '23rd December 2023',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
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
