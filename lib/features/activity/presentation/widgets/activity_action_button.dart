import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/core/utils/core_utils.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/chat/presentation/cubit/chat_cubit.dart';

class ActivityActionButton extends StatelessWidget {
  const ActivityActionButton({
    super.key,
    required this.activity,
  });

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChatCubit>(),
      child: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is ChatError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is JoinedGroup) {
            CoreUtils.showSnackBar(
              context,
              "Successfully joined to the Activity",
            );
          }
        },
        builder: (context, state) {
          if (state is JoiningGroup) {
            return FloatingActionButton(
              backgroundColor: Colors.yellow,
              onPressed: () {},
              child: const CircularProgressIndicator(),
            );
          } else if (state is JoinedGroup) {
            return FloatingActionButton(
              backgroundColor: AppColors.primaryColor,
              onPressed: () {},
              child: Row(
                children: [
                  const Icon(Icons.person),
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
                context.read<ChatCubit>().joinGroup(
                      groupId: activity.groupId,
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
      ),
    );
  }
}
