import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_ease_app/core/errors/exceptions.dart';
import 'package:social_ease_app/core/errors/failures.dart';
import 'package:social_ease_app/features/activity/data/datasources/activity_remote_data_source.dart';
import 'package:social_ease_app/features/activity/data/models/activity_model.dart';
import 'package:social_ease_app/features/activity/data/repositories/activity_repository.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';

class MockActivityRemoteDataSource extends Mock
    implements ActivityRemoteDataSource {}

void main() {
  late ActivityRemoteDataSource remoteDataSource;
  late ActivityRepositoryImpl repositoryImpl;

  final tActivity = ActivityModel.empty();

  setUp(() {
    remoteDataSource = MockActivityRemoteDataSource();
    repositoryImpl = ActivityRepositoryImpl(remoteDataSource);
    registerFallbackValue(tActivity);
  });

  const tException =
      ServerException(message: 'Something went wrong', statusCode: '500');

  group('addActivity', () {
    test(
        'should complete successfully when call to remote data source is successfull',
        () async {
      when(() => remoteDataSource.addActivity(any())).thenAnswer(
        (_) async => Future.value(),
      );
      final result = await repositoryImpl.addActivity(tActivity);
      expect(result, const Right<dynamic, void>(null));
      verify(
        () => remoteDataSource.addActivity(tActivity),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should return [ServerFailure] when call to remote data source is unsuccessfull',
        () async {
      when(
        () => remoteDataSource.addActivity(any()),
      ).thenThrow(tException);
      final result = await repositoryImpl.addActivity(tActivity);
      expect(
          result, Left<Failure, void>(ServerFailure.fromException(tException)));
      verify(() => remoteDataSource.addActivity(tActivity)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('getActivites', () {
    test(
        'should return [List<Activity>] when call to remote data source is successfull',
        () async {
      when(
        () => remoteDataSource.getActivities(),
      ).thenAnswer(
        (_) async => [tActivity],
      );
      final result = await repositoryImpl.getActivities();
      expect(result, isA<Right<dynamic, List<Activity>>>());
      verify(() => remoteDataSource.getActivities()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'shoudl return [ServerFailure] when call to remote data source is unsuccessfull',
        () async {
      when(
        () => remoteDataSource.getActivities(),
      ).thenThrow(tException);
      final result = await repositoryImpl.getActivities();
      expect(
          result, Left<Failure, void>(ServerFailure.fromException(tException)));
      verify(
        () => remoteDataSource.getActivities(),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
