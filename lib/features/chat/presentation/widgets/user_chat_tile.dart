import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/common/widgets/time_text.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/features/chat/domain/entities/group.dart';
import 'package:social_ease_app/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:social_ease_app/features/chat/presentation/views/chat_view.dart';

class UserChatTile extends StatelessWidget {
  const UserChatTile({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        group.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(360),
        child: CircleAvatar(
          child: Image.network(
            group.groupImageUrl!,
            fit: BoxFit.cover,
            height: 100,
          ),
        ),
      ),
      subtitle: group.lastMessage != null
          ? RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: '${group.lastMessageSenderName}: ',
                style: TextStyle(
                  color: AppColors.secondaryTextColor,
                  fontSize: 12,
                  fontFamily: Fonts.poppins,
                ),
                children: [
                  TextSpan(
                    text: '${group.lastMessage}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: Fonts.poppins,
                    ),
                  )
                ],
              ),
            )
          : null,
      trailing: group.lastMessage != null
          ? TimeText(
              time: group.lastMessageTimestamp!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      onTap: () {
        context.push(
          BlocProvider(
            create: (_) => sl<ChatCubit>(),
            child: ChatView(group: group),
          ),
        );
      },
    );
  }
}
