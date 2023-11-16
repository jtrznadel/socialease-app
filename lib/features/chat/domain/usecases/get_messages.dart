import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/chat/domain/entities/message.dart';
import 'package:social_ease_app/features/chat/domain/repositories/chat_repository.dart';

class GetMessages extends StreamUsecaseWithParams<List<Message>, String> {
  const GetMessages(this._repo);

  final ChatRepository _repo;

  @override
  ResultStream<List<Message>> call(String params) => _repo.getMessages(params);
}
