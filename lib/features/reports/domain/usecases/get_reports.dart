import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/reports/domain/entities/report.dart';
import 'package:social_ease_app/features/reports/domain/repositories/report_repo.dart';

class GetReports extends StreamUsecaseWithoutParams<List<Report>> {
  const GetReports(this._repo);

  final ReportRepo _repo;

  @override
  ResultStream<List<Report>> call() => _repo.getReports();
}
