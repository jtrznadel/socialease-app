import 'package:equatable/equatable.dart';

class ActivityComment extends Equatable {
  const ActivityComment({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.createdBy,
    this.likes = 0,
  });

  ActivityComment.empty()
      : this(
          id: '_empty.id',
          content: 'empty_content',
          createdAt: DateTime.now(),
          createdBy: '_empty.createdBy',
          likes: 0,
        );

  final String id;
  final String content;
  final DateTime createdAt;
  final String createdBy;
  final int likes;

  @override
  List<Object?> get props => [id];
}
