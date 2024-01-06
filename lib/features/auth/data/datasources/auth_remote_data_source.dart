import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:social_ease_app/core/enums/account_level.dart';
import 'package:social_ease_app/core/enums/update_user.dart';
import 'package:social_ease_app/core/errors/exceptions.dart';
import 'package:social_ease_app/core/utils/constants.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/auth/data/models/user_model.dart';
import 'package:social_ease_app/features/auth/domain/entites/social_media_links.dart';
import 'package:social_ease_app/features/points/data/models/ranking_position_model.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<void> forgotPassword(String email);

  Future<LocalUserModel> signIn(
      {required String email, required String password});

  Future<void> signUp(
      {required String email,
      required String password,
      required String fullName});

  Future<void> updateUser(
      {required UpdateUserAction action, required dynamic userData});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(
      {required FirebaseAuth authClient,
      required FirebaseFirestore cloudStoreClient,
      required FirebaseStorage dbClient})
      : _authClient = authClient,
        _cloudStoreClient = cloudStoreClient,
        _dbClient = dbClient;

  final FirebaseAuth _authClient;
  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbClient;

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _authClient.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
          message: e.message ?? 'Error Occured', statusCode: e.code);
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<LocalUserModel> signIn(
      {required String email, required String password}) async {
    try {
      final result = await _authClient.signInWithEmailAndPassword(
          email: email, password: password);
      final user = result.user;
      if (user == null) {
        throw const ServerException(
            message: 'Please try again late', statusCode: 'Unknown error');
      }
      var userData = await _getUserData(user.uid);

      if (userData.exists) {
        return LocalUserModel.fromMap(userData.data()!);
      }
      //upload the user
      await _setUserData(user, email);
      userData = await _getUserData(user.uid);
      return LocalUserModel.fromMap(userData.data()!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
          message: e.message ?? 'Error Occured', statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<void> signUp(
      {required String email,
      required String password,
      required String fullName}) async {
    try {
      final userCred = await _authClient.createUserWithEmailAndPassword(
          email: email, password: password);
      await userCred.user?.updateDisplayName(fullName);
      await userCred.user?.updatePhotoURL(kDefaultAvatar);
      await _setUserData(_authClient.currentUser!, email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
          message: e.message ?? 'Error Occured', statusCode: e.code);
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<void> updateUser(
      {required UpdateUserAction action, required userData}) async {
    try {
      switch (action) {
        case UpdateUserAction.email:
          await _authClient.currentUser?.updateEmail(userData as String);
          await _updateUserData({'email': userData});
        case UpdateUserAction.displayName:
          await _authClient.currentUser?.updateDisplayName(userData as String);
          await _updateUserData({'fullName': userData});
        case UpdateUserAction.profileAvatar:
          final ref = _dbClient
              .ref()
              .child('profile_avatars/${_authClient.currentUser?.uid}');
          await ref.putFile(userData as File);
          final url = await ref.getDownloadURL();
          await _authClient.currentUser?.updatePhotoURL(url);
          await _updateUserData({'profilePic': url});
        case UpdateUserAction.password:
          if (_authClient.currentUser?.email == null) {
            throw const ServerException(
                message: 'User does not exist',
                statusCode: 'Insufficient Permission');
          }
          final newData = jsonDecode(userData as String) as DataMap;
          await _authClient.currentUser?.reauthenticateWithCredential(
              EmailAuthProvider.credential(
                  email: _authClient.currentUser!.email!,
                  password: newData['oldPassword'] as String));
          await _authClient.currentUser
              ?.updatePassword(newData['newPassword'] as String);
        case UpdateUserAction.bio:
          await _updateUserData({'bio': userData as String});
        case UpdateUserAction.completeActivity:
          await _updateUserData({
            'completedActivities': FieldValue.arrayUnion([userData])
          });
      }
    } on FirebaseException catch (e) {
      throw ServerException(
          message: e.message ?? 'Error Occured', statusCode: e.code);
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 505);
    }
  }

  Future<DocumentSnapshot<DataMap>> _getUserData(String uid) async {
    return _cloudStoreClient.collection('users').doc(uid).get();
  }

  Future<void> _setUserData(User user, String fallbackEmail) async {
    await _cloudStoreClient
        .collection('users')
        .doc(user.uid)
        .set(LocalUserModel(
          uid: user.uid,
          email: user.email ?? fallbackEmail,
          points: 0,
          accountLevel: AccountLevel.rookie,
          socialMediaLinks: SocialMediaLinks.empty(),
          fullName: user.displayName ?? '',
          profilePic: user.photoURL ?? '',
          groups: const [],
          createdActivities: const [],
          ongoingActivities: const [],
        ).toMap());

    await _cloudStoreClient
        .collection('rankings')
        .doc('all-time')
        .collection('users')
        .doc(user.uid)
        .set(const RankingPositionModel.empty()
            .copyWith(
              userId: user.uid,
            )
            .toMap());
  }

  Future<void> _updateUserData(DataMap data) async {
    await _cloudStoreClient
        .collection('users')
        .doc(_authClient.currentUser?.uid)
        .update(data);
  }
}
