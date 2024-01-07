import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/enums/report_enum.dart';
import 'package:social_ease_app/core/usecases/usecases.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/reports/domain/repositories/report_repo.dart';

class ChangeReportStatus
    extends FutureUsecaseWithParams<void, ChangeReportStatusParams> {
  const ChangeReportStatus(this._repo);

  final ReportRepo _repo;

  @override
  ResultFuture<void> call(ChangeReportStatusParams params) => _repo
      .changeReportStatus(reportId: params.reportId, status: params.status);
}

class ChangeReportStatusParams extends Equatable {
  const ChangeReportStatusParams({
    required this.reportId,
    required this.status,
  });

  final String reportId;
  final ReportStatus status;

  @override
  List<Object?> get props => [reportId, status];
}
