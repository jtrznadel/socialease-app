import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_ease_app/core/enums/activity_category.dart';
import 'package:social_ease_app/core/enums/activity_status.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';

class ActivityModel extends Activity {
  const ActivityModel({
    required super.id,
    required super.title,
    required super.description,
    required super.location,
    required super.category,
    required super.groupId,
    required super.createdAt,
    required super.updatedAt,
    required super.createdBy,
    required super.tags,
    required super.members,
    required super.latitude,
    required super.longitude,
    super.status = "toBeVerified",
    super.image,
    super.imageIsFile = false,
    super.startDate,
    super.endDate,
  });

  ActivityModel.empty()
      : this(
          id: '_empty.id',
          title: '_empty.title',
          description: '_empty.description',
          location: '_empty.location',
          category: ActivityCategory.charity,
          groupId: '_empty.groupId',
          tags: const [],
          members: const [],
          latitude: 0.0,
          longitude: 0.0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          createdBy: '_empty.createdBy',
        );

  ActivityModel.fromMap(DataMap map)
      : super(
            id: map['id'] as String,
            title: map['title'] as String,
            description: map['description'] as String,
            location: map['location'] as String,
            category: ActivityCategory.values.byName(map['category']),
            groupId: map['groupId'] as String,
            createdAt: map['createdAt'] != null
                ? (map['createdAt'] as Timestamp).toDate()
                : DateTime.now(),
            updatedAt: map['updatedAt'] != null
                ? (map['updatedAt'] as Timestamp).toDate()
                : DateTime.now(),
            startDate: map['startDate'] != null
                ? (map['startDate'] as Timestamp).toDate()
                : DateTime.now(),
            endDate: map['endDate'] != null
                ? (map['endDate'] as Timestamp).toDate()
                : DateTime.now(),
            createdBy: map['createdBy'] as String,
            tags: (map['tags'] as List<dynamic>).cast<String>(),
            members: (map['members'] as List<dynamic>).cast<String>(),
            latitude: map['latitude'] != null ? map['latitude'] as double : 0.0,
            longitude:
                map['longitude'] != null ? map['longitude'] as double : 0.0,
            image: map['image'] as String?,
            status: map['status'] as String);

  ActivityModel copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    ActivityCategory? category,
    String? groupId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? startDate,
    DateTime? endDate,
    double? latitude,
    double? longitude,
    String? createdBy,
    List<String>? tags,
    List<String>? members,
    String? image,
    bool? imageIsFile,
    String? status,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      category: category ?? this.category,
      groupId: groupId ?? this.groupId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdBy: createdBy ?? this.createdBy,
      tags: tags ?? this.tags,
      members: members ?? this.members,
      image: image ?? this.image,
      imageIsFile: imageIsFile ?? this.imageIsFile,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  DataMap toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'location': location,
        'category': category.name,
        'groupId': groupId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'startDate': startDate,
        'endDate': endDate,
        'createdBy': createdBy,
        'tags': tags,
        'members': members,
        'latitude': latitude,
        'longitude': longitude,
        'image': image,
        'status': status,
      };
}
