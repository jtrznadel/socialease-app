import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_ease_app/features/chat/domain/entities/message.dart';
import 'package:social_ease_app/features/chat/domain/usecases/send_message.dart';

import 'chat_repository.mock.dart';

void main() {
  late MockChatRepository repo;
  late SendMessage usecase;

  final tMessage = Message.empty();

  setUp(() {
    repo = MockChatRepository();
    usecase = SendMessage(repo);
    registerFallbackValue(tMessage);
  });

  test('should call sendMessage on repo with the given message', () async {
    when(() => repo.sendMessage(any()))
        .thenAnswer((_) async => const Right(null));

    await usecase(tMessage);
    verify(() => repo.sendMessage(tMessage)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
