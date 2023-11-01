import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser(
      {required this.uid,
      required this.email,
      required this.points,
      required this.fullName,
      this.profileAvatar,
      this.bio,
      this.groupIds = const []});

  factory LocalUser.empty() {
    return const LocalUser(
        uid: '',
        email: '',
        profileAvatar: '',
        bio: '',
        fullName: '',
        groupIds: [],
        points: 0);
  }

  final String uid;
  final String email;
  final String? profileAvatar;
  final String? bio;
  final int points;
  final String fullName;
  final List<String> groupIds;

  @override
  List<Object?> get props =>
      [uid, email, profileAvatar, bio, points, fullName, groupIds.length];

  @override
  String toString() {
    return 'LocalUSer{uid: $uid, email: $email, bio: $bio, points: $points, fullName: $fullName';
  }
}
