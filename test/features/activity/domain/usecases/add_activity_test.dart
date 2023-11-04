import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/domain/repositories/activity_repository.dart';
import 'package:social_ease_app/features/activity/domain/usecases/add_activity.dart';

import 'activity_repo.mock.dart';

void main() {
  late ActivityRepository repo;
  late AddActivity usecase;

  final tActivity = Activity.empty();

  setUp(() {
    repo = MockActivityRepo();
    usecase = AddActivity(repo);
    registerFallbackValue(tActivity);
  });

  test('should call [ActivityRepository.addActivity]', () async {
    // arange
    when(() => repo.addActivity(any()))
        .thenAnswer((_) async => const Right(null));
    // act
    await usecase.call(tActivity);
    // assert
    verify(() => repo.addActivity(tActivity)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
