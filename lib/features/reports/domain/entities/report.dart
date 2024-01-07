import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/enums/report_enum.dart';

class Report extends Equatable {
  const Report({
    required this.id,
    required this.sentBy,
    required this.reportedId,
    required this.type,
    required this.category,
    required this.explanation,
    required this.sentAt,
    required this.status,
  });

  Report.empty()
      : id = '_empty_id',
        sentBy = '_empty_sentBy',
        reportedId = '_empty_reportedId',
        type = ReportType.activityReport,
        category = ReportCategory.spamContent,
        explanation = '_empty_explanation',
        sentAt = DateTime.now(),
        status = ReportStatus.waiting;

  final String id;
  final String sentBy;
  final String reportedId;
  final ReportType type;
  final ReportCategory category;
  final String explanation;
  final DateTime sentAt;
  final ReportStatus status;

  @override
  List<Object?> get props => [id];
}
