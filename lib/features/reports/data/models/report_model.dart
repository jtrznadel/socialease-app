import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_ease_app/core/enums/report_enum.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/reports/domain/entities/report.dart';

class ReportModel extends Report {
  const ReportModel({
    required super.id,
    required super.sentBy,
    required super.reportedUserId,
    super.reportedActivityId,
    required super.type,
    required super.priority,
    required super.category,
    required super.explanation,
    required super.sentAt,
    required super.status,
  });

  ReportModel.empty()
      : this(
          id: '_empty_id',
          sentBy: '_empty_sentBy',
          reportedUserId: '_empty_reportedId',
          reportedActivityId: null,
          priority: 1,
          type: ReportType.activityReport,
          category: ReportCategory.spamContent,
          explanation: '_empty_explanation',
          sentAt: DateTime.now(),
          status: ReportStatus.waiting,
        );

  ReportModel.fromMap(DataMap map)
      : super(
          id: map['id'] as String,
          sentBy: map['sentBy'] as String,
          reportedUserId: map['reportedUserId'] as String,
          reportedActivityId: map['reportedActivityId'],
          type: ReportType.values.byName(map['type']),
          priority: map['priority'] as int,
          category: ReportCategory.values.byName(map['category']),
          explanation: map['explanation'] as String,
          sentAt: (map['sentAt'] as Timestamp).toDate(),
          status: ReportStatus.values.byName(map['status']),
        );

  ReportModel copyWith({
    String? id,
    String? sentBy,
    String? reportedUserId,
    String? reportedActivityId,
    ReportType? type,
    int? priority,
    ReportCategory? category,
    String? explanation,
    DateTime? sentAt,
    ReportStatus? status,
  }) {
    return ReportModel(
      id: id ?? this.id,
      sentBy: sentBy ?? this.sentBy,
      reportedUserId: reportedUserId ?? this.reportedUserId,
      reportedActivityId: reportedActivityId ?? this.reportedActivityId,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      explanation: explanation ?? this.explanation,
      sentAt: sentAt ?? this.sentAt,
      status: status ?? this.status,
    );
  }

  DataMap toMap() => {
        'id': id,
        'sentBy': sentBy,
        'reportedUserId': reportedUserId,
        'reportedActivityId': reportedActivityId,
        'type': type.name,
        'priority': priority,
        'category': category.name,
        'explanation': explanation,
        'sentAt': sentAt,
        'status': status.name,
      };
}
