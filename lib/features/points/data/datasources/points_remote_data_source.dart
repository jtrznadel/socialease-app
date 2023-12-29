import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_ease_app/core/enums/account_level.dart';
import 'package:social_ease_app/core/errors/exceptions.dart';
import 'package:social_ease_app/core/utils/datasource_utils.dart';
import 'package:social_ease_app/features/points/data/models/ranking_position_model.dart';
import 'package:social_ease_app/features/points/domain/entities/ranking_position.dart';

abstract class PointsRemoteDataSrc {
  const PointsRemoteDataSrc();

  Future<void> addPoints({required String userId, required int points});
  Future<void> subPoints({required String userId, required int points});
  Future<void> updateLevel({required String userId});
  Stream<int> getPoints({required String userId});
  Stream<AccountLevel> getLevel({required String userId});
  Stream<List<RankingPositionModel>> getAllTimeRanking();
  Stream<List<RankingPositionModel>> getMonthlyRanking();
  Future<void> updateRanking();
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
      final now = DateTime.now();
      final yearMonth = '${now.year}-${now.month}';
      await DataSourceUtils.authorizeUser(_auth);
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'points': FieldValue.increment(points)});

      await _firestore
          .collection('rankings')
          .doc('all-time')
          .collection('users')
          .doc(userId)
          .update({
        'points': FieldValue.increment(points),
      });

      final monthlyRankingRef = _firestore
          .collection('rankings')
          .doc('monthly')
          .collection(yearMonth)
          .doc(userId);
      final monthlyRankingDoc = await monthlyRankingRef.get();
      if (monthlyRankingDoc.exists) {
        await monthlyRankingRef.update({
          'points': FieldValue.increment(points),
        });
        await updateRanking();
      } else {
        await monthlyRankingRef.set(const RankingPositionModel.empty()
            .copyWith(
              userId: userId,
              points: points,
            )
            .toMap());
        await updateRanking();
      }
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
      await _firestore
          .collection('rankings')
          .doc('all-time')
          .collection('users')
          .doc(userId)
          .update({
        'points': updatedPoints,
      });
      final now = DateTime.now();
      final yearMonth = '${now.year}-${now.month}';
      final monthlyRankingRef = _firestore
          .collection('rankings')
          .doc('monthly')
          .collection(yearMonth)
          .doc(userId);
      final monthlyRankingDoc = await monthlyRankingRef.get();
      if (monthlyRankingDoc.exists) {
        await monthlyRankingRef.update({
          'points': updatedPoints,
        });
        await updateRanking();
      } else {
        await monthlyRankingRef.set(const RankingPositionModel.empty()
            .copyWith(
              userId: userId,
              points: points,
            )
            .toMap());
        await updateRanking();
      }
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

  @override
  Stream<List<RankingPositionModel>> getAllTimeRanking() {
    try {
      DataSourceUtils.authorizeUser(_auth);
      final rankingStream = _firestore
          .collection('rankings')
          .doc('all-time')
          .collection('users')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => RankingPositionModel.fromMap(doc.data()))
            .toList();
      });
      return rankingStream.handleError((error) {
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
  Stream<List<RankingPositionModel>> getMonthlyRanking() {
    try {
      final now = DateTime.now();
      final yearMonthDoc = '${now.year}-${now.month}';
      DataSourceUtils.authorizeUser(_auth);
      final rankingStream = _firestore
          .collection('rankings')
          .doc('monthly')
          .collection(yearMonthDoc)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => RankingPositionModel.fromMap(doc.data()))
            .toList();
      });
      return rankingStream.handleError((error) {
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
  Future<void> updateRanking() async {
    try {
      final now = DateTime.now();
      final yearMonthDoc = '${now.year}-${now.month}';
      final allTimeRankingRef =
          _firestore.collection('rankings').doc('all-time').collection('users');
      final monthlyRankingRef = _firestore
          .collection('rankings')
          .doc('monthly')
          .collection(yearMonthDoc);

      // Pobierz zaktualizowane dane z Firestore
      QuerySnapshot allTimeRankingSnapshot =
          await allTimeRankingRef.orderBy('points', descending: true).get();
      QuerySnapshot monthlyRankingSnapshot =
          await monthlyRankingRef.orderBy('points', descending: true).get();

      List<DocumentSnapshot> allTimeRanking = allTimeRankingSnapshot.docs;
      List<DocumentSnapshot> monthlyRanking = monthlyRankingSnapshot.docs;

      // Zaktualizuj pozycje dla wszystkich użytkowników
      await updatePositions(allTimeRankingRef, allTimeRanking);
      await updatePositions(monthlyRankingRef, monthlyRanking);
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

AccountLevel determineAccountLevel(int points) {
  for (var level in AccountLevel.values) {
    if (points >= level.minRange && points <= level.maxRange) {
      return level;
    }
  }
  return AccountLevel.rookie;
}

Future<void> updatePositions(
    CollectionReference rankingRef, List<DocumentSnapshot> ranking) async {
  for (int i = 0; i < ranking.length; i++) {
    String id = ranking[i].id;
    int newPosition = i + 1;

    // Zaktualizuj pozycję
    await rankingRef.doc(id).update({'position': newPosition});
  }
}
