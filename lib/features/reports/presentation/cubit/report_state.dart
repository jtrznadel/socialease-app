part of 'report_cubit.dart';

sealed class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

final class ReportInitial extends ReportState {}

final class ReportError extends ReportState {
  const ReportError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

final class LoadingReports extends ReportState {
  const LoadingReports();
}

final class ReportLoaded extends ReportState {
  const ReportLoaded(this.reports);

  final List<Report> reports;

  @override
  List<Object> get props => [reports];
}

final class AddingReport extends ReportState {
  const AddingReport();
}

final class ReportAdded extends ReportState {
  const ReportAdded();
}

final class RemovingReport extends ReportState {
  const RemovingReport();
}

final class ReportRemoved extends ReportState {
  const ReportRemoved();
}

final class UpdatingReportStatus extends ReportState {
  const UpdatingReportStatus();
}

final class ReportStatusUpdated extends ReportState {
  const ReportStatusUpdated();
}
