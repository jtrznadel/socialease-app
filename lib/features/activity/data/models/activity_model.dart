import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_ease_app/core/enums/activity_category.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';

class ActivityModel extends Activity {
  const ActivityModel({
    required super.id,
    required super.title,
    required super.description,
    required super.location,
    required super.category,
    required super.createdAt,
    required super.updatedAt,
    required super.createdBy,
    required super.tags,
    super.image,
    super.imageIsFile = false,
  });

  ActivityModel.empty()
      : this(
          id: '_empty.id',
          title: '_empty.title',
          description: '_empty.description',
          location: '_empty.location',
          category: ActivityCategory.charity,
          tags: const [],
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
          createdAt: (map['createdAt'] as Timestamp).toDate(),
          updatedAt: (map['updatedAt'] as Timestamp).toDate(),
          createdBy: map['createdBy'] as String,
          tags: (map['tags'] as List<dynamic>).cast<String>(),
          image: map['image'] as String?,
        );

  ActivityModel copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    ActivityCategory? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    List<String>? tags,
    String? image,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      tags: tags ?? this.tags,
      image: image ?? this.image,
    );
  }

  DataMap toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'location': location,
        'category': category.name,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'createdBy': createdBy,
        'tags': tags,
        'image': image,
      };
}
