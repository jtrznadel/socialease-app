import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/common/views/loading_view.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/core/utils/core_utils.dart';
import 'package:social_ease_app/features/chat/domain/entities/group.dart';
import 'package:social_ease_app/features/chat/domain/entities/message.dart';
import 'package:social_ease_app/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:social_ease_app/features/chat/presentation/refactors/chat_app_bar.dart';
import 'package:social_ease_app/features/chat/presentation/widgets/chat_input_field.dart';
import 'package:social_ease_app/features/chat/presentation/widgets/message_bubble.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key, required this.group});

  final Group group;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  bool showingDialog = false;
  bool showInputField = false;

  List<Message> messages = [];
  late ChatCubit chatCubit;
  @override
  void initState() {
    super.initState();

    chatCubit = context.read<ChatCubit>();
    chatCubit.getMessages(widget.group.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: ChatAppBar(group: widget.group),
        body: BlocConsumer<ChatCubit, ChatState>(
          listener: (_, state) {
            if (showingDialog) {
              Navigator.of(context).pop();
              showingDialog = false;
            }
            if (state is ChatError) {
              CoreUtils.showSnackBar(context, state.message);
            } else if (state is LeavingGroup) {
              showingDialog = true;
              CoreUtils.showLoadingDialog(context);
            } else if (state is LeftGroup) {
              context.pop();
            } else if (state is MessagesLoaded) {
              setState(() {
                messages = state.messages;
                showInputField = true;
              });
            }
          },
          builder: (context, state) {
            if (state is LoadingMessages) {
              return const LoadingView();
            } else if (state is MessagesLoaded ||
                showInputField ||
                messages.isNotEmpty) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: messages.length,
                      reverse: true,
                      itemBuilder: (_, index) {
                        final message = messages[index];
                        final prevMessage =
                            index > 0 ? messages[index - 1] : null;

                        final showSenderInfo = prevMessage == null ||
                            prevMessage.senderId != message.senderId;

                        return BlocProvider(
                          create: (_) => sl<ChatCubit>(),
                          child: MessageBubble(
                            key: ValueKey<String>(message.id),
                            message: message,
                            showSenderInfo: showSenderInfo,
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  BlocProvider(
                    create: (_) => sl<ChatCubit>(),
                    child: ChatInputField(
                      groupId: widget.group.id,
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ));
  }
}
