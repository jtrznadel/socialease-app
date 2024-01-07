import 'package:social_ease_app/core/enums/report_enum.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/reports/domain/entities/report.dart';

abstract class ReportRepo {
  const ReportRepo();

  ResultFuture<void> addReport(Report report);
  ResultFuture<void> removeReport(String reportId);
  ResultFuture<void> changeReportStatus(
      {required String reportId, required ReportStatus status});
  ResultStream<List<Report>> getReports();
}
