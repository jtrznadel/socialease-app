import 'package:equatable/equatable.dart';

class RankingPosition extends Equatable {
  const RankingPosition(
      {required this.userId, required this.position, required this.points});

  const RankingPosition.empty()
      : this(
          points: 0,
          userId: '',
          position: 9999,
        );

  final String userId;
  final int position;
  final int points;
  @override
  List<Object> get props => [userId, points];
}
