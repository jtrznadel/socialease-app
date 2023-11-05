import 'package:equatable/equatable.dart';

class Group extends Equatable {
  const Group({
    required this.id,
    required this.name,
    required this.activityId,
    required this.members,
    this.lastMessage,
    this.groupImageUrl,
    this.lastMessageTimestamp,
    this.lastMessageSenderName,
  });

  const Group.empty()
      : this(
            id: '',
            name: '',
            activityId: '',
            members: const [],
            lastMessage: null,
            groupImageUrl: null,
            lastMessageTimestamp: null,
            lastMessageSenderName: null);

  final String id;
  final String name;
  final String activityId;
  final List<String> members;
  final String? lastMessage;
  final String? groupImageUrl;
  final DateTime? lastMessageTimestamp;
  final String? lastMessageSenderName;

  @override
  List<Object?> get props => [id, name, activityId];
}
