import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/domain/entities/comment.dart';
import 'package:social_ease_app/features/activity/domain/repositories/activity_repository.dart';

class GetComments
    extends StreamUsecaseWithParams<List<ActivityComment>, String> {
  const GetComments(this._repo);

  final ActivityRepository _repo;

  @override
  ResultStream<List<ActivityComment>> call(String params) =>
      _repo.getComments(params);
}
