import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';
import 'package:social_ease_app/features/chat/domain/usecases/get_user_by_id.dart';

import 'chat_repository.mock.dart';

void main() {
  late MockChatRepository repo;
  late GetUserById usecase;

  setUp(() {
    repo = MockChatRepository();
    usecase = GetUserById(repo);
  });

  final tLocalUser = LocalUser.empty();

  test('should return [LocalUser] from [ChatRepository.getUserById]', () async {
    when(() => repo.getUserById(any()))
        .thenAnswer((_) async => Right(tLocalUser));
    final result = await usecase('userId');
    expect(result, Right<dynamic, LocalUser>(tLocalUser));
    verify(() => repo.getUserById('userId')).called(1);
    verifyNoMoreInteractions(repo);
  });
}
