import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/chat/domain/entities/group.dart';

class GroupModel extends Group {
  const GroupModel({
    required super.id,
    required super.name,
    required super.activityId,
    required super.members,
    super.lastMessage,
    super.groupImageUrl,
    super.lastMessageTimestamp,
    super.lastMessageSenderName,
  });

  const GroupModel.empty()
      : this(
            id: '',
            name: '',
            activityId: '',
            members: const [],
            lastMessage: null,
            groupImageUrl: null,
            lastMessageTimestamp: null,
            lastMessageSenderName: null);

  GroupModel.fromMap(Map<String, dynamic> map)
      : this(
          id: map['id'] as String,
          name: map['name'] as String,
          activityId: map['activityId'] as String,
          members: (map['members'] as List<dynamic>).cast<String>(),
          lastMessage: map['lastMessage'] as String?,
          groupImageUrl: map['groupImageUrl'] as String?,
          lastMessageTimestamp:
              (map['lastMessageTimestamp'] as Timestamp?)?.toDate(),
          lastMessageSenderName: map['lastMessageSenderName'] as String?,
        );

  GroupModel copyWith({
    String? id,
    String? name,
    String? activityId,
    List<String>? members,
    String? lastMessage,
    String? groupImageUrl,
    DateTime? lastMessageTimestamp,
    String? lastMessageSenderName,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      activityId: activityId ?? this.activityId,
      members: members ?? this.members,
      lastMessage: lastMessage ?? this.lastMessage,
      groupImageUrl: groupImageUrl ?? this.groupImageUrl,
      lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
      lastMessageSenderName:
          lastMessageSenderName ?? this.lastMessageSenderName,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'activityId': activityId,
      'name': name,
      'members': members,
      'lastMessage': lastMessage,
      'lastMessageSenderName': lastMessageSenderName,
      'lastMessageTimestamp':
          lastMessage == null ? null : FieldValue.serverTimestamp(),
      'groupImageUrl': groupImageUrl,
    };
  }
}
