import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_ease_app/core/errors/failures.dart';
import 'package:social_ease_app/features/activity/data/models/activity_model.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/domain/usecases/add_activity.dart';
import 'package:social_ease_app/features/activity/domain/usecases/get_activities.dart';
import 'package:social_ease_app/features/activity/domain/usecases/get_user_by_id.dart';
import 'package:social_ease_app/features/activity/domain/usecases/join_activity.dart';
import 'package:social_ease_app/features/activity/domain/usecases/leave_activity.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';

class MockAddActivity extends Mock implements AddActivity {}

class MockGetActivities extends Mock implements GetActivities {}

class MockGetUser extends Mock implements GetUserById {}

class MockJoinActivity extends Mock implements JoinActivity {}

class MockLeaveActivity extends Mock implements LeaveActivity {}

void main() {
  late AddActivity addActivity;
  late GetActivities getActivities;
  late GetUserById getUserById;
  late ActivityCubit activityCubit;
  late JoinActivity joinActivity;
  late LeaveActivity leaveActivity;

  final tActivity = ActivityModel.empty();

  setUp(() {
    addActivity = MockAddActivity();
    getActivities = MockGetActivities();
    getUserById = MockGetUser();
    joinActivity = MockJoinActivity();
    leaveActivity = MockLeaveActivity();
    activityCubit = ActivityCubit(
      addActivity: addActivity,
      getActivities: getActivities,
      getUserById: getUserById,
      joinActivity: joinActivity,
      leaveActivity: leaveActivity,
    );
    registerFallbackValue(tActivity);
  });

  tearDown(() {
    activityCubit.close();
  });

  test('initial state should be [ActivityInitial]', () async {
    expect(activityCubit.state, ActivityInitial());
  });

  group('addActivity', () {
    blocTest<ActivityCubit, ActivityState>(
        'emits [AddingActivity, ActivityAdded] when addActivity is called',
        build: () {
          when(() => addActivity(any()))
              .thenAnswer((_) async => const Right(null));
          return activityCubit;
        },
        act: (cubit) => cubit.addActivity(tActivity),
        expect: () => [
              AddingActivity(),
              ActivityAdded(),
            ],
        verify: (_) {
          verify(() => addActivity(tActivity)).called(1);
          verifyNoMoreInteractions(addActivity);
        });

    blocTest('emits [AddingActivity, ActivityError] when addActivity fails',
        build: () {
          when(() => addActivity(any())).thenAnswer(
            (_) async => const Left(
              ServerFailure(message: 'Something went wrong', statusCode: '500'),
            ),
          );
          return activityCubit;
        },
        act: (cubit) => cubit.addActivity(tActivity),
        expect: () => [
              AddingActivity(),
              const ActivityError('500 Error: Something went wrong'),
            ],
        verify: (_) {
          verify(() => addActivity(tActivity)).called(1);
          verifyNoMoreInteractions(addActivity);
        });
  });

  group('getActivities', () {
    blocTest(
        'emits [LoadingActivities, ActivitiesLoaded] when getActivities is called',
        build: () {
          when(() => getActivities())
              .thenAnswer((_) async => Right([tActivity]));
          return activityCubit;
        },
        act: (cubit) => cubit.getActivities(),
        expect: () => [
              LoadingActivities(),
              ActivitiesLoaded([tActivity]),
            ],
        verify: (_) {
          verify(() => getActivities()).called(1);
          verifyNoMoreInteractions(getActivities);
        });
  });

  blocTest('emits [LoadingActivities, ActivityError] when getActivities fails',
      build: () {
        when(() => getActivities()).thenAnswer((_) async => const Left(
            ServerFailure(message: 'Something went wrong', statusCode: '500')));
        return activityCubit;
      },
      act: (cubit) => cubit.getActivities(),
      expect: () => [
            LoadingActivities(),
            const ActivityError('500 Error: Something went wrong'),
          ],
      verify: (_) {
        verify(() => getActivities()).called(1);
        verifyNoMoreInteractions(getActivities);
      });
}
