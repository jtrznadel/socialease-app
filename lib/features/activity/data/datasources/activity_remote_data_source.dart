import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_ease_app/core/errors/exceptions.dart';
import 'package:social_ease_app/core/utils/datasource_utils.dart';
import 'package:social_ease_app/features/activity/data/models/activity_model.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/auth/data/models/user_model.dart';
import 'package:social_ease_app/features/chat/data/models/group_model.dart';

abstract class ActivityRemoteDataSource {
  const ActivityRemoteDataSource();
  Future<List<ActivityModel>> getActivities();
  Future<void> addActivity(Activity activity);
  Future<LocalUserModel> getUserById(String userId);
  Future<void> joinActivity({required activityId, required userId});
  Future<void> leaveActivity({required activityId, required userId});
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
          id: activityRef.id, groupId: groupRef.id, members: [user.uid]);
      if (activityModel.imageIsFile) {
        final imageRef = _storage.ref().child(
            'activities/${activityModel.id}/profile_image/${activityModel.title}-pfp');
        await imageRef.putFile(File(activityModel.image!)).then((value) async {
          final url = await value.ref.getDownloadURL();
          activityModel = activityModel.copyWith(image: url);
        });
      }

      await activityRef.set(activityModel.toMap());

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
  Future<List<ActivityModel>> getActivities() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const ServerException(
          message: 'User is not authenticated',
          statusCode: '401',
        );
      }

      return _firestore.collection('activities').get().then((value) =>
          value.docs.map((doc) => ActivityModel.fromMap(doc.data())).toList());
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
}
