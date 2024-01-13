import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/activity/domain/entities/comment.dart';

class CommentModel extends ActivityComment {
  const CommentModel({
    required super.id,
    required super.content,
    required super.createdAt,
    required super.createdBy,
    required super.likes,
  });

  CommentModel.empty()
      : this(
          id: '_empty.id',
          content: 'empty_content',
          createdAt: DateTime.now(),
          createdBy: '_empty.createdBy',
          likes: 0,
        );

  CommentModel.fromMap(DataMap map)
      : super(
          id: map['id'] as String,
          content: map['content'] as String,
          createdAt: (map['createdAt'] as Timestamp).toDate(),
          createdBy: map['createdBy'] as String,
          likes: map['likes'] as int,
        );

  CommentModel copyWith({
    String? id,
    String? content,
    String? createdBy,
    DateTime? createdAt,
    int? likes,
  }) {
    return CommentModel(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      likes: likes ?? this.likes,
    );
  }

  DataMap toMap() => {
        'id': id,
        'content': content,
        'createdBy': createdBy,
        'createdAt': createdAt,
        'likes': likes,
      };
}
