import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/chat/domain/entities/group.dart';
import 'package:social_ease_app/features/chat/domain/repositories/chat_repository.dart';

class GetGroups extends StreamUsecaseWithoutParams<List<Group>> {
  const GetGroups(this._repo);

  final ChatRepository _repo;

  @override
  ResultStream<List<Group>> call() => _repo.getGroups();
}
