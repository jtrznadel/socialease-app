import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/auth/data/models/user_model.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tLocalUserModel = LocalUserModel.empty();

  test('should be a subclass of [LocalUser] entity',
      () => expect(tLocalUserModel, isA<LocalUser>()));

  final tMap = jsonDecode(fixture('user.json')) as DataMap;

  group('fromMap', () {
    test('should return a valid [LocalUserModel] from the map', () {
      // act
      final result = LocalUserModel.fromMap(tMap);

      expect(result, isA<LocalUserModel>());
      expect(result, equals(tLocalUserModel));
    });

    test('should throw an [Error] when the map is invalid', () {
      final map = DataMap.from(tMap)..remove('uid');

      const call = LocalUserModel.fromMap;
      expect(() => call(map), throwsA(isA<Error>()));
    });
  });

  group('toMap()', () {
    test('should return a valid [DataMap] from the model', () {
      final result = tLocalUserModel.toMap();
      expect(result, equals(tMap));
    });
  });

  group('copyWith()', () {
    test('should return a valid [LocalUserModel] with updated values', () {
      final result = tLocalUserModel.copyWith(uid: '2');
      expect(result.uid, '2');
    });
  });
}
