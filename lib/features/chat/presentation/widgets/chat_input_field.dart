import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/features/chat/data/models/message_model.dart';
import 'package:social_ease_app/features/chat/presentation/cubit/chat_cubit.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({super.key, required this.groupId});

  final String groupId;

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        minLines: 1,
        maxLines: 5,
        decoration: InputDecoration(
          hintText: "Message",
          hintStyle: TextStyle(
            color: AppColors.secondaryTextColor,
            fontFamily: Fonts.poppins,
          ),
          filled: true,
          fillColor: AppColors.fieldInputColor,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 22,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          suffixIcon: Transform.scale(
            scale: .8,
            child: Material(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(50),
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  final message = controller.text.trim();
                  if (message.isEmpty) return;
                  controller.clear();
                  context.read<ChatCubit>().sendMessage(
                        MessageModel.empty().copyWith(
                          message: message,
                          senderId: context.currentUser!.uid,
                          groupId: widget.groupId,
                        ),
                      );
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
