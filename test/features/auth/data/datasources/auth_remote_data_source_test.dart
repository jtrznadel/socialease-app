import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:social_ease_app/features/auth/data/datasources/auth_remote_data_source.dart';

void main() {
  late FakeFirebaseFirestore cloudStoreClient;
  late MockFirebaseAuth authClient;
  late MockFirebaseStorage dbClient;
  late AuthRemoteDataSource dataSource;
  late MockUser mockUser;
  late UserCredential userCredential;

  setUpAll(() async {
    authClient = MockFirebaseAuth();
    cloudStoreClient = MockFirebaseFirestore();
    dbClient = MockFirebaseStorage();
    mockUser = MockUser();
    userCredential = MockUserCredential(mockUser);
    dataSource = AuthRemoteDataSourceImpl(authClient: authClient, cloudStoreClient: cloudStoreClient, dbClient: dbClient);
  });

  const tPassword = 'Test Password';
  const tFullName = 'Test Full Name';
  const tEmail = 'test@example.com';

  test('signUp')
}
