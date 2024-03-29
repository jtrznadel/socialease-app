import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/common/widgets/user_profile_modal.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/utils/constants.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';
import 'package:social_ease_app/features/chat/domain/entities/message.dart';
import 'package:social_ease_app/features/chat/presentation/cubit/chat_cubit.dart';

class MessageBubble extends StatefulWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.showSenderInfo,
  });

  final Message message;
  final bool showSenderInfo;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  LocalUser? user;
  late bool isCurrentUser;

  @override
  void initState() {
    if (widget.message.senderId == context.currentUser!.uid) {
      user = context.currentUser!;
      isCurrentUser = true;
    } else {
      isCurrentUser = false;
      context.read<ChatCubit>().getUser(widget.message.senderId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is UserLoaded && user == null) {
          setState(() {
            user = state.user;
          });
        }
      },
      child: Container(
        constraints: BoxConstraints(maxWidth: context.width - 45),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isCurrentUser && widget.showSenderInfo)
              GestureDetector(
                onTap: () {
                  if (user != null) {
                    showUserProfileModal(context, user!);
                  }
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(
                        user == null || user!.profilePic == null
                            ? kDefaultAvatar
                            : user!.profilePic!,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      user == null ? "Unknown User" : user!.fullName,
                      style: TextStyle(
                        fontFamily: Fonts.poppins,
                      ),
                    )
                  ],
                ),
              ),
            Container(
              margin: EdgeInsets.only(
                top: 4,
                left: isCurrentUser ? 0 : 20,
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color:
                    isCurrentUser ? AppColors.primaryColor : AppColors.bgColor,
              ),
              child: Text(
                widget.message.message,
                style: TextStyle(
                  color: isCurrentUser ? Colors.white : Colors.black,
                  fontFamily: Fonts.poppins,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
