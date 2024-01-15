import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/activity/presentation/views/activity_completed_screen.dart';
import 'package:social_ease_app/features/activity/presentation/views/activity_joined_screen.dart';
import 'package:social_ease_app/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class ActivityJoinButton extends StatefulWidget {
  const ActivityJoinButton({
    super.key,
    required this.groupId,
    required this.activityId,
    required this.notifyParent,
  });
  final String groupId;
  final String activityId;
  final Function() notifyParent;

  @override
  State<ActivityJoinButton> createState() => _ActivityJoinButtonState();
}

class _ActivityJoinButtonState extends State<ActivityJoinButton> {
  bool isFinished = false;
  @override
  Widget build(BuildContext context) {
    return SwipeableButtonView(
      onFinish: () async {
        context.read<ActivityCubit>().joinActivity(
              activityId: widget.activityId,
              userId: context.currentUser!.uid,
            );
        context.read<ChatCubit>().joinGroup(
              groupId: widget.groupId,
              userId: context.currentUser!.uid,
            );
        await Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: const ActivityJoinedScreen()));
        setState(() {
          isFinished = false;
        });
        widget.notifyParent();
      },
      onWaitingProcess: () {
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isFinished = true;
          });
        });
      },
      activeColor: Colors.green,
      isFinished: isFinished,
      buttonWidget: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.grey,
      ),
      buttonText: "Slide to join",
    );
  }
}
