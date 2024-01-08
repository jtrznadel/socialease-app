import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/enums/report_enum.dart';

class Report extends Equatable {
  const Report({
    required this.id,
    required this.sentBy,
    required this.reportedUserId,
    required this.type,
    required this.category,
    required this.explanation,
    required this.sentAt,
    required this.status,
    required this.priority,
    this.reportedActivityId,
  });

  Report.empty()
      : id = '_empty_id',
        sentBy = '_empty_sentBy',
        reportedUserId = '_empty_reportedUserId',
        reportedActivityId = null,
        type = ReportType.activityReport,
        category = ReportCategory.spamContent,
        explanation = '_empty_explanation',
        sentAt = DateTime.now(),
        priority = 1,
        status = ReportStatus.waiting;

  final String id;
  final String sentBy;
  final String reportedUserId;
  final String? reportedActivityId;
  final ReportType type;
  final ReportCategory category;
  final String explanation;
  final DateTime sentAt;
  final ReportStatus status;
  final int priority;

  @override
  List<Object?> get props => [id];
}
