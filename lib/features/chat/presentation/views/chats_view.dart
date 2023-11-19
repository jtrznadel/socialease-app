import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/common/views/loading_view.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/utils/core_utils.dart';
import 'package:social_ease_app/features/chat/domain/entities/group.dart';
import 'package:social_ease_app/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:social_ease_app/features/chat/presentation/widgets/user_chat_tile.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({super.key});

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  List<Group> yourChats = [];
  //TODO: wonder of making otherChats
  bool showingDialog = false;

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().getGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Chat',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (_, state) {
          if (showingDialog) {
            Navigator.of(context).pop();
            showingDialog = false;
          }
          if (state is ChatError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is JoiningGroup) {
            showingDialog = true;
            CoreUtils.showLoadingDialog(context);
          } else if (state is JoinedGroup) {
            CoreUtils.showSnackBar(context, 'Joined group successfully');
          } else if (state is GroupsLoaded) {
            yourChats = state.groups
                .where(
                  (group) => group.members.contains(context.currentUser!.uid),
                )
                .toList();
          }
        },
        builder: (context, state) {
          if (state is LoadingGroups) {
            return const LoadingView();
          } else if (state is GroupsLoaded && state.groups.isEmpty) {
            return const Text('No chats found');
          } else if ((state is GroupsLoaded) || (yourChats.isNotEmpty)) {
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (yourChats.isNotEmpty) ...[
                  const Text(
                    'Your Chats',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Divider(
                    color: AppColors.secondaryTextColor,
                  ),
                  ...yourChats.map((group) => UserChatTile(group: group)),
                ]
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
