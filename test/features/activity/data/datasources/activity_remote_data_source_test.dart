import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:social_ease_app/features/activity/data/datasources/activity_remote_data_source.dart';
import 'package:social_ease_app/features/activity/data/models/activity_model.dart';

void main() {
  late ActivityRemoteDataSource remoteDataSource;
  late FakeFirebaseFirestore firestore;
  late MockFirebaseAuth auth;
  late MockFirebaseStorage storage;

  setUp(() async {
    firestore = FakeFirebaseFirestore();
    final user = MockUser(
      uid: 'uid',
      email: 'email',
      displayName: 'displayName',
    );
    final googleSignIn = MockGoogleSignIn();
    final signInAccount = await googleSignIn.signIn();
    final googleAuth = await signInAccount!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    auth = MockFirebaseAuth(mockUser: user);
    await auth.signInWithCredential(credential);
    storage = MockFirebaseStorage();
    remoteDataSource = ActivityRemoteDataSourceImpl(
        firestore: firestore, storage: storage, auth: auth);
  });

  group('addActivity', () {
    test('should add the given activity to the firestore collection', () async {
      // Arange
      final activity = ActivityModel.empty();

      // Act
      await remoteDataSource.addActivity(activity);

      // Assert
      final firestoreData = await firestore.collection('activities').get();
      expect(firestoreData.docs.length, 1);

      final activityRef = firestoreData.docs.first;
      expect(activityRef.data()['id'], activityRef.id);

      final groupData = await firestore.collection('groups').get();
      expect(groupData.docs.length, 1);

      final groupRef = groupData.docs.first;
      expect(groupRef.data()['id'], groupRef.id);

      expect(activityRef.data()['groupId'], groupRef.id);
      expect(groupRef.data()['activityId'], activityRef.id);
    });
  });

  group('getActivites', () {
    test('should return a List<Activity> when the call is successful',
        () async {
      // Arange
      final firstDate = DateTime.now();
      final secondDate = DateTime.now().add(const Duration(seconds: 30));
      final expectedActivities = [
        ActivityModel.empty().copyWith(createdAt: firstDate),
        ActivityModel.empty()
            .copyWith(createdAt: secondDate, id: '1', title: 'Activity 1'),
      ];
      for (final activity in expectedActivities) {
        await firestore.collection('activities').add(activity.toMap());
      }
      // Act

      final result = await remoteDataSource.getActivities();

      // Assert
      expect(result, expectedActivities);
    });
  });
}
