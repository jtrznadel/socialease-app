import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/enums/activity_category.dart';

class Activity extends Equatable {
  const Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    this.startDate,
    this.endDate,
    required this.category,
    required this.groupId,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.tags,
    required this.members,
    required this.pendingRequests,
    required this.latitude,
    required this.longitude,
    required this.likedBy,
    this.status = "toBeVerified",
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
          members: const [],
          likedBy: const [],
          pendingRequests: const [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          createdBy: '_empty.createdBy',
          longitude: 0.0,
          latitude: 0.0,
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
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime updatedAt;
  final String createdBy;
  final List<String> members;
  final List<String> pendingRequests;
  final List<String> likedBy;
  final double longitude;
  final double latitude;

  @override
  List<Object?> get props => [id];
}
