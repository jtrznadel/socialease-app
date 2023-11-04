import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/data/models/activity_model.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final timestampData = {
    "_seconds": 1677483528,
    "_nanoseconds": 123456000,
  };
  final date =
      DateTime.fromMillisecondsSinceEpoch(timestampData['_seconds'] as int)
          .add(Duration(microseconds: timestampData['_nanoseconds'] as int));
  final timestamp = Timestamp.fromDate(date);
  final tActivityModel = ActivityModel.empty();
  final tMap = jsonDecode(fixture('activity.json')) as DataMap;
  tMap['createdAt'] = timestamp;
  tMap['updatedAt'] = timestamp;

  test('should be a subclass of [Activity] entity', () {
    expect(tActivityModel, isA<Activity>());
  });

  group('empty', () {
    test('should return a [ActivityModel] with empty data', () {
      final result = ActivityModel.empty();
      expect(result.title, '_empty.title');
    });
  });

  group('fromMap', () {
    test('should return a [ActivityModel] with the correct data', () async {
      final result = ActivityModel.fromMap(tMap);
      expect(result, equals(tActivityModel));
    });
  });

  group('toMap', () {
    test('should return a [Map] with the proper data', () async {
      final result = tActivityModel.toMap()
        ..remove('createdAt')
        ..remove('updatedAt');
      final map = DataMap.from(tMap)
        ..remove('createdAt')
        ..remove('updatedAt');
      expect(result, equals(map));
    });
  });

  group('copyWith', () {
    test('should return a [ActivityModel] with the new data', () async {
      final result = tActivityModel.copyWith(title: 'New title');
      expect(result.title, 'New title');
    });
  });
}
