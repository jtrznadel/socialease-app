import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/enums/report_enum.dart';
import 'package:social_ease_app/core/errors/failures.dart';
import 'package:social_ease_app/features/reports/domain/entities/report.dart';
import 'package:social_ease_app/features/reports/domain/usecases/add_report.dart';
import 'package:social_ease_app/features/reports/domain/usecases/change_report_status.dart';
import 'package:social_ease_app/features/reports/domain/usecases/get_reports.dart';
import 'package:social_ease_app/features/reports/domain/usecases/remove_report.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit({
    required AddReport addReport,
    required RemoveReport removeReport,
    required ChangeReportStatus changeReportStatus,
    required GetReports getReports,
  })  : _addReport = addReport,
        _removeReport = removeReport,
        _changeReportStatus = changeReportStatus,
        _getReports = getReports,
        super(ReportInitial());
  final AddReport _addReport;
  final RemoveReport _removeReport;
  final ChangeReportStatus _changeReportStatus;
  final GetReports _getReports;

  StreamSubscription<Either<Failure, List<Report>>>? reportsSubscription;

  Future<void> addReport(Report report) async {
    emit(const AddingReport());
    final result = await _addReport(report);
    result.fold(
      (failure) => emit(ReportError(failure.errorMessage)),
      (_) => emit(const ReportAdded()),
    );
  }

  Future<void> removeReport(String reportId) async {
    emit(const RemovingReport());
    final result = await _removeReport(reportId);
    result.fold(
      (failure) => emit(ReportError(failure.errorMessage)),
      (_) => emit(const ReportAdded()),
    );
  }

  Future<void> changeReportStatus({
    required String reportId,
    required ReportStatus status,
  }) async {
    emit(const UpdatingReportStatus());
    final result = await _changeReportStatus(
        ChangeReportStatusParams(reportId: reportId, status: status));
    result.fold(
      (failure) => emit(ReportError(failure.errorMessage)),
      (_) => emit(const ReportStatusUpdated()),
    );
  }

  void getReports() {
    emit(const LoadingReports());
    reportsSubscription = _getReports().listen(
      (result) {
        result.fold(
          (failure) => emit(ReportError(failure.errorMessage)),
          (reports) => emit(ReportLoaded(reports)),
        );
      },
      onError: (error) {
        emit(ReportError(error.toString()));
      },
    );
  }
}
