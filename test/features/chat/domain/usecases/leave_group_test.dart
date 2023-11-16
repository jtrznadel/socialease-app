import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_ease_app/features/chat/domain/usecases/leave_group.dart';

import 'chat_repository.mock.dart';

void main() {
  late MockChatRepository repo;
  late LeaveGroup usecase;

  setUp(() {
    repo = MockChatRepository();
    usecase = LeaveGroup(repo);
  });

  const tLeaveGroupParams = LeaveGroupParams.empty();

  test('should call [ChatRepository.leaveGroup]', () async {
    when(() => repo.leaveGroup(
            groupId: any(named: 'groupId'), userId: any(named: 'userId')))
        .thenAnswer((_) async => const Right(null));

    final result = await usecase(tLeaveGroupParams);
    expect(result, const Right<dynamic, void>(null));
    verify(() => repo.leaveGroup(
        groupId: tLeaveGroupParams.groupId,
        userId: tLeaveGroupParams.userId)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
