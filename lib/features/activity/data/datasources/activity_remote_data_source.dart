import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_ease_app/core/enums/activity_status.dart';
import 'package:social_ease_app/core/errors/exceptions.dart';
import 'package:social_ease_app/core/utils/datasource_utils.dart';
import 'package:social_ease_app/features/activity/data/models/activity_model.dart';
import 'package:social_ease_app/features/activity/data/models/comment_model.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/domain/entities/comment.dart';
import 'package:social_ease_app/features/auth/data/models/user_model.dart';
import 'package:social_ease_app/features/chat/data/models/group_model.dart';

abstract class ActivityRemoteDataSource {
  const ActivityRemoteDataSource();
  Stream<List<ActivityModel>> getActivities();
  Future<void> addActivity(Activity activity);
  Future<void> removeActivity(String activityId);
  Future<void> updateActivity(Activity activity);
  Future<LocalUserModel> getUserById(String userId);
  Future<void> joinActivity({required activityId, required userId});
  Future<void> leaveActivity({required activityId, required userId});
  Future<void> completeActivity({required activityId, required userId});
  Future<void> sendRequest({required activityId, required userId});
  Future<void> removeRequest({required activityId, required userId});
  Future<void> updateActivityStatus(
      {required String activityId, required ActivityStatus status});
  Future<void> addComment({required comment, required activityId});
  Future<void> removeComment({required activityId, required commentId});
  Stream<List<CommentModel>> getComments(String activityId);
  Future<void> likeComment({required activityId, required commentId});
}

class ActivityRemoteDataSourceImpl implements ActivityRemoteDataSource {
  const ActivityRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _storage = storage,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  @override
  Future<void> addActivity(Activity activity) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const ServerException(
            message: 'User is not authenticated', statusCode: '401');
      }
      final activityRef = _firestore.collection('activities').doc();
      final groupRef = _firestore.collection('groups').doc();

      var activityModel = (activity as ActivityModel).copyWith(
        id: activityRef.id,
        groupId: groupRef.id,
        members: [user.uid],
      );
      if (activityModel.imageIsFile) {
        final imageRef = _storage.ref().child(
            'activities/${activityModel.id}/profile_image/${activityModel.title}-pfp');
        await imageRef.putFile(File(activityModel.image!)).then((value) async {
          final url = await value.ref.getDownloadURL();
          activityModel = activityModel.copyWith(image: url);
        });
      }
      await activityRef.set(activityModel.toMap());

      await _firestore.collection('users').doc(user.uid).update({
        'createdActivities': FieldValue.arrayUnion([activityModel.id]),
      });

      final group = GroupModel(
        id: groupRef.id,
        name: activity.title,
        activityId: activityRef.id,
        members: [user.uid],
        groupImageUrl: activityModel.image,
      );

      return groupRef.set(group.toMap());
    } on FirebaseException catch (e) {
      throw ServerException(
          message: e.message ?? 'Unknown error occured', statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<void> removeActivity(String activityId) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      WriteBatch batch = _firestore.batch();

      batch.delete(_firestore.collection('activities').doc(activityId));

      final activitySnapshot =
          await _firestore.collection('activities').doc(activityId).get();
      final List<String> members =
          List<String>.from(activitySnapshot.get('members'));

      for (final memberId in members) {
        batch.update(
          _firestore.collection('users').doc(memberId),
          {
            'ongoingActivities': FieldValue.arrayRemove([activityId])
          },
        );
      }
      await batch.commit();
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
  Future<void> updateActivity(Activity updateData) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);

      var activityModel = (updateData as ActivityModel);
      if (activityModel.imageIsFile) {
        final imageRef = _storage.ref().child(
            'activities/${activityModel.id}/profile_image/${activityModel.title}-pfp');
        await imageRef.putFile(File(activityModel.image!)).then((value) async {
          final url = await value.ref.getDownloadURL();
          activityModel = activityModel.copyWith(image: url);
        });
      }
      await _firestore
          .collection('activities')
          .doc(activityModel.id)
          .update(activityModel.toMap());
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
  Stream<List<ActivityModel>> getActivities() {
    try {
      DataSourceUtils.authorizeUser(_auth);
      final activitiesStream =
          _firestore.collection('activities').snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => ActivityModel.fromMap(doc.data()))
            .toList();
      });
      return activitiesStream.handleError((error) {
        if (error is FirebaseException) {
          throw ServerException(
            message: error.message ?? 'Unknown error occurred',
            statusCode: error.code,
          );
        } else {
          throw ServerException(message: error.toString(), statusCode: '505');
        }
      });
    } on FirebaseException catch (e) {
      return Stream.error(
        ServerException(
          message: e.message ?? 'Unknown error occurred',
          statusCode: e.code,
        ),
      );
    } on ServerException catch (e) {
      return Stream.error(e);
    } catch (e) {
      return Stream.error(
        ServerException(
          message: e.toString(),
          statusCode: '505',
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
  Future<void> joinActivity({required activityId, required userId}) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      await _firestore.collection('activities').doc(activityId).update({
        'members': FieldValue.arrayUnion([userId])
      });
      await _firestore.collection('users').doc(userId).update({
        'ongoingActivities': FieldValue.arrayUnion([activityId])
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
  Future<void> leaveActivity({required activityId, required userId}) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      await _firestore.collection('activities').doc(activityId).update({
        'members': FieldValue.arrayRemove([userId])
      });
      await _firestore.collection('users').doc(userId).update({
        'ongoingActivities': FieldValue.arrayRemove([activityId])
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
  Future<void> completeActivity({required activityId, required userId}) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      await _firestore.collection('users').doc(userId).update({
        'completedActivities': FieldValue.arrayUnion([activityId])
      });
      await _firestore.collection('users').doc(userId).update({
        'ongoingActivities': FieldValue.arrayRemove([activityId])
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
  Future<void> sendRequest({required activityId, required userId}) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      await _firestore.collection('activities').doc(activityId).update({
        'pendingRequests': FieldValue.arrayUnion([userId])
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
  Future<void> removeRequest({required activityId, required userId}) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      await _firestore.collection('activities').doc(activityId).update({
        'pendingRequests': FieldValue.arrayRemove([userId])
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
  Future<void> updateActivityStatus(
      {required String activityId, required ActivityStatus status}) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      await _firestore
          .collection('activities')
          .doc(activityId)
          .update({'status': status.name});
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
  Future<void> addComment({required activityId, required comment}) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      final commentRef = _firestore
          .collection('activities')
          .doc(activityId)
          .collection('comments')
          .doc();

      var commentModel = (comment as CommentModel).copyWith(
        id: commentRef.id,
      );

      await commentRef.set(commentModel.toMap());
    } on FirebaseException catch (e) {
      throw ServerException(
          message: e.message ?? 'Unknown error occured', statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Stream<List<CommentModel>> getComments(String activityId) {
    try {
      DataSourceUtils.authorizeUser(_auth);
      final commentsStream = _firestore
          .collection('activities')
          .doc(activityId)
          .collection('comments')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => CommentModel.fromMap(doc.data()))
            .toList();
      });
      return commentsStream.handleError((error) {
        if (error is FirebaseException) {
          throw ServerException(
            message: error.message ?? 'Unknown error occurred',
            statusCode: error.code,
          );
        } else {
          throw ServerException(message: error.toString(), statusCode: '505');
        }
      });
    } on FirebaseException catch (e) {
      return Stream.error(
        ServerException(
          message: e.message ?? 'Unknown error occurred',
          statusCode: e.code,
        ),
      );
    } on ServerException catch (e) {
      return Stream.error(e);
    } catch (e) {
      return Stream.error(
        ServerException(
          message: e.toString(),
          statusCode: '505',
        ),
      );
    }
  }

  @override
  Future<void> likeComment({required activityId, required commentId}) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      _firestore
          .collection('activities')
          .doc(activityId)
          .collection('comments')
          .doc(commentId)
          .update({'likes': FieldValue.increment(1)});
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
  Future<void> removeComment({required activityId, required commentId}) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      _firestore
          .collection('activities')
          .doc(activityId)
          .collection('comments')
          .doc(commentId)
          .delete();
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
