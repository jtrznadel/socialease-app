import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:social_ease_app/core/enums/report_enum.dart';
import 'package:social_ease_app/core/errors/exceptions.dart';
import 'package:social_ease_app/core/errors/failures.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/reports/data/datasources/report_remote_data_source.dart';
import 'package:social_ease_app/features/reports/data/models/report_model.dart';
import 'package:social_ease_app/features/reports/domain/entities/report.dart';
import 'package:social_ease_app/features/reports/domain/repositories/report_repo.dart';

class ReportRepoImpl implements ReportRepo {
  const ReportRepoImpl(this._remoteDataSource);

  final ReportRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<void> changeReportStatus(
      {required String reportId, required ReportStatus status}) async {
    try {
      await _remoteDataSource.changeReportStatus(
          reportId: reportId, status: status);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultStream<List<Report>> getReports() {
    return _remoteDataSource.getReports().transform(StreamTransformer<
                List<ReportModel>, Either<Failure, List<Report>>>.fromHandlers(
            handleError: (error, stackTrace, sink) {
          if (error is ServerException) {
            sink.add(
              Left(
                ServerFailure(
                    message: error.message, statusCode: error.statusCode),
              ),
            );
          } else {
            sink.add(
              Left(
                ServerFailure(message: error.toString(), statusCode: 500),
              ),
            );
          }
        }, handleData: (reports, sink) {
          sink.add(Right(reports));
        }));
  }

  @override
  ResultFuture<void> removeReport(String reportId) async {
    try {
      await _remoteDataSource.removeReport(reportId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> addReport(Report report) async {
    try {
      await _remoteDataSource.addReport(report);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
