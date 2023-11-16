import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_ease_app/core/errors/failures.dart';
import 'package:social_ease_app/features/chat/data/models/group_model.dart';
import 'package:social_ease_app/features/chat/domain/entities/group.dart';
import 'package:social_ease_app/features/chat/domain/usecases/get_groups.dart';

import 'chat_repository.mock.dart';

void main() {
  late MockChatRepository repo;
  late GetGroups usecase;

  setUp(() {
    repo = MockChatRepository();
    usecase = GetGroups(repo);
  });

  test('should emit [List<Group>] from the [ChatRepository]', () async {
    final expectedGroups = [
      const GroupModel.empty()
          .copyWith(id: '1', name: 'Group1', activityId: '1'),
      const GroupModel.empty()
          .copyWith(id: '2', name: 'Group2', activityId: '11'),
    ];

    when(() => repo.getGroups()).thenAnswer(
      (_) => Stream.value(
        Right(expectedGroups),
      ),
    );

    final stream = usecase();
    expect(
      stream,
      emitsInOrder([Right<Failure, List<Group>>(expectedGroups)]),
    );
    verify(() => repo.getGroups()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
