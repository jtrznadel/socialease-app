import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_ease_app/core/errors/exceptions.dart';
import 'package:social_ease_app/core/utils/datasource_utils.dart';
import 'package:social_ease_app/features/auth/data/models/user_model.dart';

abstract class UserRemoteDataSrc {
  const UserRemoteDataSrc();
  Future<LocalUserModel> getUserById(String userId);
}

class UserRemoteDataSrcImpl implements UserRemoteDataSrc {
  const UserRemoteDataSrcImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

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
}
