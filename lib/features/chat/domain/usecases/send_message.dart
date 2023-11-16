import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/chat/domain/entities/message.dart';
import 'package:social_ease_app/features/chat/domain/repositories/chat_repository.dart';

class SendMessage extends FutureUsecaseWithParams<void, Message> {
  const SendMessage(this._repo);

  final ChatRepository _repo;

  @override
  ResultFuture<void> call(Message params) => _repo.sendMessage(params);
}
