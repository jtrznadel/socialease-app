import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/reports/domain/repositories/report_repo.dart';

class RemoveReport extends FutureUsecaseWithParams<void, String> {
  const RemoveReport(this._repo);

  final ReportRepo _repo;

  @override
  ResultFuture<void> call(String params) => _repo.removeReport(params);
}
