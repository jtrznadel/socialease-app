import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/domain/repositories/activity_repository.dart';
import 'package:social_ease_app/features/activity/domain/usecases/add_activity.dart';
import 'package:social_ease_app/features/activity/domain/usecases/get_activities.dart';

import 'activity_repo.mock.dart';

void main() {
  late ActivityRepository repo;
  late GetActivities usecase;

  setUp(() {
    repo = MockActivityRepo();
    usecase = GetActivities(repo);
  });

  test('should get activities from the repo', () async {
    // arange
    when(() => repo.getActivities()).thenAnswer((_) async => const Right([]));

    // act
    final result = await usecase();

    //assert
    expect(result, const Right<dynamic, List<Activity>>([]));
    verify(() => repo.getActivities()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
