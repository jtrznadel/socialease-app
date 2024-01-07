import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_ease_app/core/enums/report_enum.dart';
import 'package:social_ease_app/core/errors/exceptions.dart';
import 'package:social_ease_app/core/utils/datasource_utils.dart';
import 'package:social_ease_app/features/reports/data/models/report_model.dart';
import 'package:social_ease_app/features/reports/domain/entities/report.dart';

abstract class ReportRemoteDataSource {
  const ReportRemoteDataSource();

  Future<void> addReport(Report report);
  Future<void> removeReport(String reportId);
  Future<void> changeReportStatus({
    required String reportId,
    required ReportStatus status,
  });
  Stream<List<ReportModel>> getReports();
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  const ReportRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  @override
  Future<void> changeReportStatus(
      {required String reportId, required ReportStatus status}) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      await _firestore
          .collection('reports')
          .doc(reportId)
          .update({'status': status.name});
    } on FirebaseException catch (e) {
      throw ServerException(
          message: e.message ?? 'Unknown error occured', statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Stream<List<ReportModel>> getReports() {
    try {
      DataSourceUtils.authorizeUser(_auth);
      final reportsStream =
          _firestore.collection('reports').snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => ReportModel.fromMap(doc.data()))
            .toList();
      });
      return reportsStream.handleError((error) {
        if (error is FirebaseException) {
          throw ServerException(
            message: error.message ?? 'Unknown error occurred',
            statusCode: error.code,
          );
        } else {
          throw ServerException(message: error.toString(), statusCode: '505');
        }
      });
    } on FirebaseException catch (e) {
      return Stream.error(
        ServerException(
          message: e.message ?? 'Unknown error occurred',
          statusCode: e.code,
        ),
      );
    } on ServerException catch (e) {
      return Stream.error(e);
    } catch (e) {
      return Stream.error(
        ServerException(
          message: e.toString(),
          statusCode: '505',
        ),
      );
    }
  }

  @override
  Future<void> removeReport(String reportId) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      await _firestore.collection('reports').doc(reportId).delete();
    } on FirebaseException catch (e) {
      throw ServerException(
          message: e.message ?? 'Unknown error occured', statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<void> addReport(Report report) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);

      final reportRef = _firestore.collection('reports').doc();

      var reportModel = (report as ReportModel).copyWith(
        id: reportRef.id,
      );
      await reportRef.set(reportModel.toMap());
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }
}
