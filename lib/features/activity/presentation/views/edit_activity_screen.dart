import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_ease_app/core/common/widgets/expandable_text.dart';
import 'package:social_ease_app/core/common/widgets/tag_tile.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/extensions/string_extensions.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/activity/presentation/views/activity_members_screen.dart';
import 'package:social_ease_app/features/activity/presentation/widgets/edit_activity_sheet.dart';

class EditActivityScreen extends StatefulWidget {
  const EditActivityScreen(this.activity, {Key? key}) : super(key: key);

  static const routeName = '/edit-activity';

  final Activity activity;

  @override
  State<EditActivityScreen> createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends State<EditActivityScreen> {
  var removeController = TextEditingController();
  @override
  void dispose() {
    removeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void showEditActivitySheet(BuildContext context, Activity activity) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return BlocProvider(
            create: (context) => sl<ActivityCubit>(),
            child: EditActivitySheet(
              editActivity: activity,
            ),
          );
        },
      );
    }

    var toEnd = widget.activity.endDate!.difference(DateTime.now()).inDays + 1;
    var confirmCode = widget.activity.title.shuffleString;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Edit Activity'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          widget.activity.image != null
              ? Image.network(
                  widget.activity.image!,
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
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  context.currentUser!.fullName,
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
                                      context.currentUser!.profilePic != null
                                          ? NetworkImage(context.currentUser!
                                              .profilePic!) as ImageProvider
                                          : const AssetImage(
                                              MediaRes.defaultAvatarImage),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          widget.activity.title,
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
                            Icon(widget.activity.category.icon),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.activity.category.label,
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
                          text: widget.activity.description,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          spacing: 5.0,
                          runSpacing: 8.0,
                          children: [
                            ...widget.activity.tags
                                .take(3)
                                .map((tag) => TagTile(tag: tag)),
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
                              widget.activity.location,
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
                                  DateFormat.yMMMd()
                                      .format(widget.activity.startDate!),
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
                                  DateFormat.yMMMd()
                                      .format(widget.activity.endDate!),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Members: ${widget.activity.members.length}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (await confirm(
                        context,
                        title: const Text('Confirm'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Are you sure?'),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: removeController,
                              decoration: InputDecoration(
                                labelText: 'Enter code below to confirm',
                                hintText: confirmCode,
                              ),
                              validator: (value) {
                                if (value == confirmCode) {
                                  return null;
                                } else {
                                  return 'Code does not match';
                                }
                              },
                            )
                          ],
                        ),
                        textOK: const Text('Remove'),
                        textCancel: const Text('Cancel'),
                      )) {
                        context
                            .read<ActivityCubit>()
                            .removeActivity(widget.activity.id);
                        Navigator.pop(context);
                      }
                      context.pop();
                    },
                    child: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showEditActivitySheet(context, widget.activity);
                    },
                    child: const Icon(
                      Icons.edit_document,
                      color: Colors.blue,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        ActivityMembersScreen.routeName,
                        arguments: widget.activity,
                      );
                    },
                    child: const Icon(
                      Icons.people,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
