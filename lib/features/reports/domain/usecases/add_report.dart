import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/reports/domain/entities/report.dart';
import 'package:social_ease_app/features/reports/domain/repositories/report_repo.dart';

class AddReport extends FutureUsecaseWithParams<void, Report> {
  const AddReport(this._repo);

  final ReportRepo _repo;

  @override
  ResultFuture<void> call(Report params) => _repo.addReport(params);
}
