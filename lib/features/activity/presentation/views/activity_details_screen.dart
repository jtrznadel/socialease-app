import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_ease_app/core/common/widgets/expandable_text.dart';
import 'package:social_ease_app/core/common/widgets/tag_tile.dart';
import 'package:social_ease_app/core/entities/activity_details_arguments.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
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
    var toEnd =
        widget.arguments.activity.endDate!.difference(DateTime.now()).inDays;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Activity Details',
          style: TextStyle(
            color: AppColors.primaryColor,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: '$toEnd ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: toEnd > 30
                                      ? Colors.green
                                      : toEnd < 5
                                          ? Colors.red
                                          : Colors.yellow,
                                ),
                                children: const [
                                  TextSpan(
                                    text: 'days to go',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Row(
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
                                          ? NetworkImage(widget.arguments.user
                                              .profilePic!) as ImageProvider
                                          : const AssetImage(
                                              MediaRes.defaultAvatarImage),
                                ),
                              ],
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
                        Row(
                          children: [
                            const Text(
                              'Location: ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              widget.arguments.activity.location,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.calendar_month),
                            Row(
                              children: [
                                const Text(
                                  'From: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  DateFormat.yMMMd().format(
                                      widget.arguments.activity.startDate!),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'To: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  DateFormat.yMMMd().format(
                                      widget.arguments.activity.endDate!),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
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
