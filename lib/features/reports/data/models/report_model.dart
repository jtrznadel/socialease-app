import 'package:social_ease_app/core/enums/report_enum.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/reports/domain/entities/report.dart';

class ReportModel extends Report {
  const ReportModel({
    required super.id,
    required super.sentBy,
    required super.reportedId,
    required super.type,
    required super.category,
    required super.explanation,
    required super.sentAt,
    required super.status,
  });

  ReportModel.empty()
      : this(
          id: '_empty_id',
          sentBy: '_empty_sentBy',
          reportedId: '_empty_reportedId',
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
          reportedId: map['reportedId'] as String,
          type: ReportType.values.byName(map['type']),
          category: ReportCategory.values.byName(map['category']),
          explanation: map['explanation'] as String,
          sentAt: (map['sentAt']),
          status: ReportStatus.values.byName(map['status']),
        );

  ReportModel copyWith({
    String? id,
    String? sentBy,
    String? reportedId,
    ReportType? type,
    ReportCategory? category,
    String? explanation,
    DateTime? sentAt,
    ReportStatus? status,
  }) {
    return ReportModel(
      id: id ?? this.id,
      sentBy: sentBy ?? this.sentBy,
      reportedId: reportedId ?? this.reportedId,
      type: type ?? this.type,
      category: category ?? this.category,
      explanation: explanation ?? this.explanation,
      sentAt: sentAt ?? this.sentAt,
      status: status ?? this.status,
    );
  }

  DataMap toMap() => {
        'id': id,
        'sentBy': sentBy,
        'reportedId': reportedId,
        'type': type.name,
        'category': category.name,
        'explanation': explanation,
        'sentAt': sentAt,
        'status': status.name,
      };
}
