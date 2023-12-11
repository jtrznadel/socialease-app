import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/utils/core_utils.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/chat/presentation/cubit/chat_cubit.dart';

class ActivityActionButton extends StatefulWidget {
  const ActivityActionButton({
    super.key,
    required this.activity,
  });

  final Activity activity;

  @override
  State<ActivityActionButton> createState() => _ActivityActionButtonState();
}

class _ActivityActionButtonState extends State<ActivityActionButton> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ActivityCubit, ActivityState>(
      listener: (context, state) {
        if (state is ActivityError) {
          CoreUtils.showSnackBar(context, state.message);
        } else if (state is JoinedActivity) {
          CoreUtils.showSnackBar(
            context,
            "Successfully joined to the Activity",
          );
        }
      },
      builder: (context, state) {
        if (state is JoiningActivity) {
          return FloatingActionButton(
            backgroundColor: Colors.yellow,
            onPressed: () {},
            child: const CircularProgressIndicator(),
          );
        } else if (widget.activity.members.contains(context.currentUser!.uid) ||
            state is JoinedActivity) {
          return FloatingActionButton(
            backgroundColor: AppColors.secondaryTextColor,
            onPressed: () {},
            splashColor: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Activity Joined',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: Fonts.montserrat,
                  ),
                ),
              ],
            ),
          );
        } else {
          return FloatingActionButton(
            backgroundColor: AppColors.primaryColor,
            onPressed: () {
              context.read<ActivityCubit>().joinActivity(
                    activityId: widget.activity.id,
                    userId: context.currentUser!.uid,
                  );
              context.read<ChatCubit>().joinGroup(
                    groupId: widget.activity.groupId,
                    userId: context.currentUser!.uid,
                  );
            },
            child: Text(
              'Join Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: Fonts.montserrat,
              ),
            ),
          );
        }
      },
    );
  }
}
