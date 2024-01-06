import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/features/activity/presentation/views/activity_completed_screen.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class ActivityCompleteButton extends StatefulWidget {
  const ActivityCompleteButton({
    super.key,
  });

  @override
  State<ActivityCompleteButton> createState() => _ActivityCompleteButtonState();
}

class _ActivityCompleteButtonState extends State<ActivityCompleteButton> {
  bool isFinished = false;
  @override
  Widget build(BuildContext context) {
    return SwipeableButtonView(
        onFinish: () async {
          await Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: const ActivityCompletedScreen()));
          setState(() {
            isFinished = false;
          });
        },
        onWaitingProcess: () {
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              isFinished = true;
            });
          });
        },
        activeColor: AppColors.primaryColor,
        isFinished: isFinished,
        buttonWidget: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.grey,
        ),
        buttonText: "Slide to complete");
  }
}
