import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/enums/activity_category.dart';

class Activity extends Equatable {
  const Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.category,
    required this.groupId,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.tags,
    this.status = "new",
    this.image,
    this.imageIsFile = false,
  });

  Activity.empty()
      : this(
          id: '_empty.id',
          title: '_empty.title',
          description: '_empty.description',
          location: '_empty.location',
          category: ActivityCategory.charity,
          groupId: '_empty.groupId',
          tags: const [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          createdBy: '_empty.createdBy',
        );

  final String id;
  final String title;
  final String description;
  final String location;
  final ActivityCategory category;
  final String groupId;
  final List<String> tags;
  final String? image;
  final bool imageIsFile;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  @override
  List<Object?> get props => [id];
}
