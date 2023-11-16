import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_ease_app/features/chat/domain/usecases/join_group.dart';

import 'chat_repository.mock.dart';

void main() {
  late MockChatRepository repo;
  late JoinGroup usecase;

  setUp(() {
    repo = MockChatRepository();
    usecase = JoinGroup(repo);
  });

  const tJoinGroupParams = JoinGroupParams.empty();

  test('should call [ChatRepository.joinGroup]', () async {
    when(() => repo.joinGroup(
            groupId: any(named: 'groupId'), userId: any(named: 'userId')))
        .thenAnswer((_) async => const Right(null));

    final result = await usecase(tJoinGroupParams);
    expect(result, const Right<dynamic, void>(null));
    verify(() => repo.joinGroup(
        groupId: tJoinGroupParams.groupId,
        userId: tJoinGroupParams.userId)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
