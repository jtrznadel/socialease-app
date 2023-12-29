import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/points/domain/entities/ranking_position.dart';

class RankingPositionModel extends RankingPosition {
  const RankingPositionModel({
    required super.userId,
    required super.points,
    required super.position,
  });

  const RankingPositionModel.empty()
      : this(
          userId: '',
          position: 9999,
          points: 0,
        );

  RankingPositionModel.fromMap(Map<String, dynamic> map)
      : this(
          userId: map['userId'] as String,
          position: map['position'] as int,
          points: map['points'] as int,
        );

  RankingPositionModel copyWith({
    String? userId,
    int? position,
    int? points,
  }) {
    return RankingPositionModel(
        userId: userId ?? this.userId,
        points: points ?? this.points,
        position: position ?? this.position);
  }

  DataMap toMap() {
    return {
      'userId': userId,
      'position': position,
      'points': points,
    };
  }
}
