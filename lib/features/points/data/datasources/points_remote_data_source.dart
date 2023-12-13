import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_ease_app/core/enums/account_level.dart';
import 'package:social_ease_app/core/errors/exceptions.dart';
import 'package:social_ease_app/core/utils/datasource_utils.dart';

abstract class PointsRemoteDataSrc {
  const PointsRemoteDataSrc();

  Future<void> addPoints({required String userId, required int points});
  Future<void> subPoints({required String userId, required int points});
  Future<void> updateLevel({required String userId});
  Stream<int> getPoints({required String userId});
  Stream<AccountLevel> getLevel({required String userId});
}

class PointsRemoteDataSrcImpl implements PointsRemoteDataSrc {
  const PointsRemoteDataSrcImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  @override
  Future<void> addPoints({required String userId, required int points}) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'points': FieldValue.increment(points)});
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
  Future<void> subPoints({required String userId, required int points}) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      final userSnapshot =
          await _firestore.collection('users').doc(userId).get();
      int currentPoints = userSnapshot.get('points') ?? 0;
      int updatedPoints = (currentPoints - points).clamp(0, currentPoints);
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'points': updatedPoints});
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
  Future<void> updateLevel({required String userId}) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      final userSnapshot =
          await _firestore.collection('users').doc(userId).get();
      int currentPoints = userSnapshot.get('points') ?? 0;
      AccountLevel currentLevel = determineAccountLevel(currentPoints);
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'accointLevel': currentLevel.label});
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
  Stream<AccountLevel> getLevel({required String userId}) {
    try {
      DataSourceUtils.authorizeUser(_auth);
      Stream<AccountLevel> levelStream = _firestore
          .collection('users')
          .doc(userId)
          .snapshots()
          .map((snapshot) {
        return snapshot.get('accountLevel') ?? 'rookie';
      });
      return levelStream.handleError((dynamic error) {
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
  Stream<int> getPoints({required String userId}) {
    try {
      DataSourceUtils.authorizeUser(_auth);
      Stream<int> pointsStream = _firestore
          .collection('users')
          .doc(userId)
          .snapshots()
          .map((snapshot) {
        return snapshot.get('points') ?? 0;
      });
      return pointsStream.handleError((dynamic error) {
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
}

AccountLevel determineAccountLevel(int points) {
  for (var level in AccountLevel.values) {
    if (points >= level.minRange && points <= level.maxRange) {
      return level;
    }
  }
  return AccountLevel.rookie;
}
