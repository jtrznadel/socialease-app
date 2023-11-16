import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';
import 'package:social_ease_app/features/chat/domain/entities/group.dart';
import 'package:social_ease_app/features/chat/domain/entities/message.dart';

abstract class ChatRepository {
  const ChatRepository();

  ResultFuture<void> sendMessage(Message message);

  ResultStream<List<Group>> getGroups();

  ResultStream<List<Message>> getMessages(String groupId);

  ResultFuture<void> joinGroup(
      {required String groupId, required String userId});

  ResultFuture<void> leaveGroup(
      {required String groupId, required String userId});

  ResultFuture<LocalUser> getUserById(String userId);
}
