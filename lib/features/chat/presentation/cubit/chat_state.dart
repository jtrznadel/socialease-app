part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

final class LoadingGroups extends ChatState {
  const LoadingGroups();
}

final class LoadingMessages extends ChatState {
  const LoadingMessages();
}

final class SendingMessage extends ChatState {
  const SendingMessage();
}

final class JoiningGroup extends ChatState {
  const JoiningGroup();
}

final class LeavingGroup extends ChatState {
  const LeavingGroup();
}

final class GettingUser extends ChatState {
  const GettingUser();
}

final class MessageSent extends ChatState {
  const MessageSent();
}

final class GroupsLoaded extends ChatState {
  const GroupsLoaded(this.groups);

  final List<Group> groups;

  @override
  List<Object> get props => [groups];
}

final class UserLoaded extends ChatState {
  const UserLoaded(this.user);

  final LocalUser user;

  @override
  List<Object> get props => [user];
}

final class MessagesLoaded extends ChatState {
  const MessagesLoaded(this.messages);

  final List<Message> messages;

  @override
  List<Object> get props => [messages];
}

final class JoinedGroup extends ChatState {
  const JoinedGroup();
}

final class LeftGroup extends ChatState {
  const LeftGroup();
}

final class ChatError extends ChatState {
  const ChatError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
