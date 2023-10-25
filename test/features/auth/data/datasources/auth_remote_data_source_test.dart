import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_ease_app/core/enums/update_user.dart';
import 'package:social_ease_app/core/errors/exceptions.dart';
import 'package:social_ease_app/core/utils/constants.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:social_ease_app/features/auth/data/models/user_model.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';

class MockFirebasaStorage extends Mock implements FirebaseStorage {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockAuthCredential extends Mock implements AuthCredential {}

class MockUser extends Mock implements User {
  String _uid = 'Test uid';

  @override
  String get uid => _uid;

  set uid(String value) {
    if (_uid != value) _uid = value;
  }
}

class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential([User? user]) : _user = user;
  User? _user;

  @override
  User? get user => _user;

  set user(User? user) {
    if (_user != user) _user = user;
  }
}

void main() {
  late FirebaseFirestore cloudStoreClient;
  late FirebaseAuth authClient;
  late MockFirebaseStorage dbClient;
  late AuthRemoteDataSource dataSource;
  late MockUser mockUser;
  late DocumentReference<DataMap> documentReference;
  late UserCredential userCredential;
  final tUser = LocalUserModel.empty();

  setUpAll(() async {
    authClient = MockFirebaseAuth();
    cloudStoreClient = FakeFirebaseFirestore();
    documentReference = cloudStoreClient.collection('users').doc();
    documentReference.set(
      tUser.copyWith(uid: documentReference.id).toMap(),
    );
    dbClient = MockFirebaseStorage();
    mockUser = MockUser()..uid = documentReference.id;
    userCredential = MockUserCredential(mockUser);
    dataSource = AuthRemoteDataSourceImpl(
        authClient: authClient,
        cloudStoreClient: cloudStoreClient,
        dbClient: dbClient);

    when(() => authClient.currentUser).thenReturn(mockUser);
  });

  const tPassword = 'Test Password';
  const tFullName = 'Test Full Name';
  const tEmail = 'test@example.com';
  const tBio = 'Test Bio';
  final tPhotoUrl = File('assets/images/on_boarding_image_1.png');
  final tFirebaseAuthException = FirebaseAuthException(
    code: 'user-not-found',
    message: 'There is no user record',
  );

  group('forgotPassword', () {
    test('should complete successfully when no [Exception] is thrown',
        () async {
      when(() => authClient.sendPasswordResetEmail(email: any(named: 'email')))
          .thenAnswer((_) async => Future.value());
      final call = dataSource.forgotPassword(tEmail);
      expect(call, completes);
      verify(() => authClient.sendPasswordResetEmail(email: tEmail)).called(1);
    });

    test(
        'should throw [ServerException] when [FirebaseAuthException] is thrown',
        () async {
      when(() => authClient.sendPasswordResetEmail(email: any(named: 'email')))
          .thenThrow(tFirebaseAuthException);
      final call = dataSource.forgotPassword;
      expect(() => call(tEmail), throwsA(isA<ServerException>()));
      verify(() => authClient.sendPasswordResetEmail(email: tEmail)).called(1);
    });
  });

  group('signIn', () {
    test(
      'should return [LocalUserModel] when no [Exception] is thrown',
      () async {
        when(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => userCredential);

        final result =
            await dataSource.signIn(email: tEmail, password: tPassword);
        expect(result.uid, userCredential.user!.uid);
        expect(result.points, 0);
        verify(
          () => authClient.signInWithEmailAndPassword(
              email: tEmail, password: tPassword),
        ).called(1);
        verifyNoMoreInteractions(authClient);
      },
    );

    test('should throw [ServerException] when user is null after signing in',
        () async {
      final emptyUserCredential = MockUserCredential();
      when(
        () => authClient.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => emptyUserCredential);
      final call = dataSource.signIn;
      expect(() => call(email: tEmail, password: tPassword),
          throwsA(isA<ServerException>()));
      verify(
        () => authClient.signInWithEmailAndPassword(
            email: tEmail, password: tPassword),
      ).called(1);
      verifyNoMoreInteractions(authClient);
    });

    test('should throw [ServerException] when [FirebaseAuthExcepion] is thrown',
        () async {
      when(
        () => authClient.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(tFirebaseAuthException);

      final call = dataSource.signIn;
      expect(
        () => call(email: tEmail, password: tPassword),
        throwsA(isA<ServerException>()),
      );
      verify(
        () => authClient.signInWithEmailAndPassword(
            email: tEmail, password: tPassword),
      ).called(1);
      verifyNoMoreInteractions(authClient);
    });
  });

  group('signUp', () {
    test('should complete successfully when no [Exception] is thrown',
        () async {
      when(
        () => authClient.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => userCredential);
      when(() => userCredential.user?.updateDisplayName(any())).thenAnswer(
        (_) async => Future.value(),
      );

      when(
        () => userCredential.user?.updatePhotoURL(any()),
      ).thenAnswer(
        (_) async => Future.value(),
      );

      final call = dataSource.signUp(
          email: tEmail, password: tPassword, fullName: tFullName);
      expect(call, completes);
      verify(() => authClient.createUserWithEmailAndPassword(
          email: tEmail, password: tPassword)).called(1);
      await untilCalled(
        () => userCredential.user?.updateDisplayName(any()),
      );
      await untilCalled(() => userCredential.user?.updatePhotoURL(any()));
      verify(
        () => userCredential.user?.updateDisplayName(tFullName),
      ).called(1);
      verify(
        () => userCredential.user?.updatePhotoURL(kDefaultAvatar),
      ).called(1);
      verifyNoMoreInteractions(authClient);
    });

    test('should throw [ServerException] when [FirebaseAuthExcepion] is thrown',
        () async {
      when(
        () => authClient.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(tFirebaseAuthException);

      final call = dataSource.signUp;
      expect(
        () => call(email: tEmail, password: tPassword, fullName: tFullName),
        throwsA(isA<ServerException>()),
      );
      verify(() => authClient.createUserWithEmailAndPassword(
          email: tEmail, password: tPassword)).called(1);
    });
  });

  group('updateUser', () {
    registerFallbackValue(MockAuthCredential());
    test(
        'should updates user\'s fullName successfully when no [Exception] is thrown',
        () async {
      when(() => mockUser.updateDisplayName(any()))
          .thenAnswer((_) async => Future.value);

      await dataSource.updateUser(
          action: UpdateUserAction.displayName, userData: tFullName);
      verify(
        () => mockUser.updateDisplayName(tFullName),
      ).called(1);
      verifyNever(
        () => mockUser.updateEmail(any()),
      );
      verifyNever(
        () => mockUser.updatePassword(any()),
      );
      verifyNever(
        () => mockUser.updatePhotoURL(any()),
      );

      final userData =
          await cloudStoreClient.collection('users').doc(mockUser.uid).get();
      expect(userData.data()!['fullName'], tFullName);
    });

    test(
        'should updates user\'s email successfully when no [Exception] is thrown',
        () async {
      when(() => mockUser.updateEmail(any()))
          .thenAnswer((_) async => Future.value);
      await dataSource.updateUser(
          action: UpdateUserAction.email, userData: tEmail);

      verify(
        () => mockUser.updateEmail(tEmail),
      ).called(1);

      verifyNever(
        () => mockUser.updatePassword(any()),
      );
      verifyNever(
        () => mockUser.updatePhotoURL(any()),
      );
      verifyNever(
        () => mockUser.updateDisplayName(any()),
      );

      final userData =
          await cloudStoreClient.collection('users').doc(mockUser.uid).get();
      expect(userData.data()!['email'], tEmail);
    });

    test(
        'should update users\'s password successfully when no [Exception] is thrown',
        () async {
      when(
        () => mockUser.updatePassword(any()),
      ).thenAnswer((_) async => Future.value());
      when(() => mockUser.reauthenticateWithCredential(any()))
          .thenAnswer((_) async => userCredential);

      when(
        () => mockUser.email,
      ).thenReturn(tEmail);

      await dataSource.updateUser(
          action: UpdateUserAction.password,
          userData: jsonEncode(
              {'oldPassword': 'oldPassword', 'newPassword': tPassword}));

      verify(() => mockUser.updatePassword(tPassword));
      verifyNever(() => mockUser.updateEmail(any()));
      verifyNever(() => mockUser.updateDisplayName(any()));
      verifyNever(() => mockUser.updatePhotoURL(any()));

      final user = await cloudStoreClient
          .collection('users')
          .doc(documentReference.id)
          .get();
      expect(user.data()!['password'], null);
    });

    test(
        'should updates users\'s bio successfully when no [Exception] is thrown',
        () async {
      await dataSource.updateUser(action: UpdateUserAction.bio, userData: tBio);
      final userData = await cloudStoreClient
          .collection('users')
          .doc(documentReference.id)
          .get();
      expect(userData.data()!['bio'], tBio);
    });

    test('should update user\'s pic successfully when no [Exception] is thrown',
        () async {
      when(() => mockUser.updatePhotoURL(any()))
          .thenAnswer((_) async => Future.value());
      await dataSource.updateUser(
          action: UpdateUserAction.profileAvatar, userData: tPhotoUrl);
      verify(
        () => mockUser.updatePhotoURL(any()),
      ).called(1);
      verifyNever(() => mockUser.updateDisplayName(any()));
      verifyNever(() => mockUser.updateEmail(any()));
      verifyNever(() => mockUser.updatePassword(any()));
      expect(dbClient.storedFilesMap.isNotEmpty, isTrue);
    });

    //   test('should throw [ServerException] when [FirebaseException] is thrown',
    //       () async {
    //     when(() => mockUser.updateDisplayName(any()))
    //         .thenThrow(tFirebaseAuthException);
    //     final call = dataSource.updateUser;
    //     expect(
    //         () => call(action: UpdateUserAction.displayName, userData: tFullName),
    //         throwsA(isA<ServerException>()));
    //     verify(
    //       () => mockUser.updateDisplayName(tFullName),
    //     ).called(1);

    //     verifyNoMoreInteractions(mockUser);
    //   });
  });
}
