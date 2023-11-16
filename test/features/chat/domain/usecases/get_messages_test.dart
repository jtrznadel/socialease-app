import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_ease_app/core/errors/failures.dart';
import 'package:social_ease_app/features/chat/domain/entities/message.dart';
import 'package:social_ease_app/features/chat/domain/usecases/get_messages.dart';

import 'chat_repository.mock.dart';

void main() {
  late MockChatRepository repo;
  late GetMessages usecase;

  setUp(() {
    repo = MockChatRepository();
    usecase = GetMessages(repo);
  });

  test('should emit [List<Message>] from the [ChatRepository]', () async {
    final expectedMessages = [
      Message(
          id: '1',
          senderId: '1',
          message: 'Hello',
          groupId: '1',
          timestamp: DateTime.now()),
      Message(
          id: '2',
          senderId: '2',
          message: 'Hello',
          groupId: '1',
          timestamp: DateTime.now()),
    ];
    when(() => repo.getMessages(any()))
        .thenAnswer((_) => Stream.value(Right(expectedMessages)));

    final stream = usecase('groupId');
    expect(
      stream,
      emitsInOrder([Right<Failure, List<Message>>(expectedMessages)]),
    );
    verify(() => repo.getMessages('groupId')).called(1);
    verifyNoMoreInteractions(repo);
  });
}
