import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_ease_app/core/errors/exceptions.dart';
import 'package:social_ease_app/core/utils/datasource_utils.dart';
import 'package:social_ease_app/features/auth/data/models/user_model.dart';
import 'package:social_ease_app/features/chat/data/models/group_model.dart';
import 'package:social_ease_app/features/chat/data/models/message_model.dart';
import 'package:social_ease_app/features/chat/domain/entities/message.dart';

abstract class ChatRemoteDataSource {
  const ChatRemoteDataSource();

  Future<void> sendMessage(Message message);

  Stream<List<MessageModel>> getMessages(String groupId);

  Stream<List<GroupModel>> getGroups();

  Future<void> joinGroup({required String groupId, required String userId});

  Future<void> leaveGroup({required String groupId, required String userId});

  Future<LocalUserModel> getUserById(String userId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  const ChatRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  @override
  Stream<List<GroupModel>> getGroups() {
    try {
      DataSourceUtils.authorizeUser(_auth);
      final groupsStream =
          _firestore.collection('groups').snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => GroupModel.fromMap(doc.data()))
            .toList();
      });
      return groupsStream.handleError((dynamic error) {
        if (error is FirebaseException) {
          throw ServerException(
            message: error.message ?? 'Unknown error occurred',
            statusCode: error.code,
          );
        } else {
          throw ServerException(message: error.toString(), statusCode: '500');
        }
      });
    } on FirebaseException catch (e) {
      return Stream.error(
        ServerException(
          message: e.message ?? 'Unknown error occurred',
          statusCode: e.code,
        ),
      );
    } catch (e) {
      return Stream.error(
        ServerException(
          message: e.toString(),
          statusCode: '500',
        ),
      );
    }
  }

  @override
  Stream<List<MessageModel>> getMessages(String groupId) {
    try {
      DataSourceUtils.authorizeUser(_auth);
      final messagesStream = _firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.data()))
            .toList();
      });
      return messagesStream.handleError((dynamic error) {
        if (error is FirebaseException) {
          throw ServerException(
            message: error.message ?? 'Unknown error occurred',
            statusCode: error.code,
          );
        } else {
          throw ServerException(message: error.toString(), statusCode: '500');
        }
      });
    } on FirebaseException catch (e) {
      return Stream.error(
        ServerException(
          message: e.message ?? 'Unknown error occurred',
          statusCode: e.code,
        ),
      );
    } catch (e) {
      return Stream.error(
        ServerException(
          message: e.toString(),
          statusCode: '500',
        ),
      );
    }
  }

  @override
  Future<LocalUserModel> getUserById(String userId) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        throw const ServerException(
          message: 'UserNotFound',
          statusCode: '404',
        );
      }
      return LocalUserModel.fromMap(userDoc.data()!);
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> joinGroup({
    required String groupId,
    required String userId,
  }) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      await _firestore.collection('groups').doc(groupId).update({
        'members': FieldValue.arrayUnion([userId])
      });
      await _firestore.collection('users').doc(userId).update({
        'groups': FieldValue.arrayUnion([groupId])
      });
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> leaveGroup(
      {required String groupId, required String userId}) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      await _firestore.collection('groups').doc(groupId).update({
        'members': FieldValue.arrayRemove([userId])
      });
      await _firestore.collection('users').doc(userId).update({
        'groups': FieldValue.arrayRemove([groupId])
      });
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> sendMessage(Message message) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      final messageRef = _firestore
          .collection('groups')
          .doc(message.groupId)
          .collection('messages')
          .doc();
      final messageToUpload =
          (message as MessageModel).copyWith(id: messageRef.id);
      await messageRef.set(messageToUpload.toMap());

      await _firestore.collection('groups').doc(message.groupId).update({
        'lastMessage': message.message,
        'lastMessageSenderName': _auth.currentUser!.displayName,
        'lastMessageTimestamp': message.timestamp,
      });
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }
}
