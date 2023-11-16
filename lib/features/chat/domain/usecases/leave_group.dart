import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/chat/domain/repositories/chat_repository.dart';

class LeaveGroup extends FutureUsecaseWithParams<void, LeaveGroupParams> {
  const LeaveGroup(this._repo);

  final ChatRepository _repo;

  @override
  ResultFuture<void> call(LeaveGroupParams params) =>
      _repo.leaveGroup(groupId: params.groupId, userId: params.userId);
}

class LeaveGroupParams extends Equatable {
  const LeaveGroupParams({required this.groupId, required this.userId});

  const LeaveGroupParams.empty()
      : groupId = '',
        userId = '';

  final String groupId;
  final String userId;

  @override
  List<String> get props => [groupId, userId];
}
