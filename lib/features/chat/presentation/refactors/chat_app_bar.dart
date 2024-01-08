import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/common/widgets/nested_back_button.dart';
import 'package:social_ease_app/core/common/widgets/popup_item.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/features/chat/domain/entities/group.dart';
import 'package:social_ease_app/features/chat/presentation/cubit/chat_cubit.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    final groupName =
        group.name.length > 10 ? group.name.substring(0, 10) : group.name;
    return AppBar(
      leading: const NestedBackButton(),
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(group.groupImageUrl!),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            groupName,
            style: TextStyle(
              fontFamily: Fonts.poppins,
            ),
          ),
        ],
      ),
      foregroundColor: Colors.black,
      actions: [
        PopupMenuButton(
          offset: const Offset(0, 50),
          surfaceTintColor: Colors.white,
          icon: const Icon(Icons.more_horiz),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          itemBuilder: (_) => [
            PopupMenuItem<void>(
              child: const PopupItem(
                title: 'Exit Group',
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                ),
              ),
              onTap: () async {
                final chatCubit = context.read<ChatCubit>();
                final result = await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog.adaptive(
                      title: const Text('Exit Group'),
                      content: const Text(
                          'Are you sure you want to leave the Group?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text('Exit Group'),
                        ),
                      ],
                    );
                  },
                );
                if (result ?? false) {
                  await chatCubit.leaveGroup(
                    groupId: group.id,
                    userId: sl<FirebaseAuth>().currentUser!.uid,
                  );
                }
              },
            )
          ],
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
