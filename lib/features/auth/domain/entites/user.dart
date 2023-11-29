import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/enums/account_level.dart';
import 'package:social_ease_app/features/auth/domain/entites/social_media_links.dart';

class LocalUser extends Equatable {
  const LocalUser(
      {required this.uid,
      required this.email,
      required this.points,
      required this.fullName,
      required this.accountLevel,
      required this.socialMediaLinks,
      this.profilePic,
      this.bio,
      this.groups = const []});

  factory LocalUser.empty() {
    return LocalUser(
        uid: '',
        email: '',
        profilePic: '',
        bio: '',
        fullName: '',
        groups: const [],
        accountLevel: AccountLevel.rookie,
        socialMediaLinks: SocialMediaLinks.empty(),
        points: 0);
  }

  final String uid;
  final String email;
  final String? profilePic;
  final String? bio;
  final int points;
  final String fullName;
  final AccountLevel accountLevel;
  final List<String> groups;
  final SocialMediaLinks socialMediaLinks;

  bool get isAdmin => email == 'admin@socialease.com';

  @override
  List<Object?> get props => [
        uid,
        email,
        profilePic,
        bio,
        points,
        fullName,
        accountLevel,
        groups.length,
        socialMediaLinks,
      ];

  @override
  String toString() {
    return 'LocalUSer{uid: $uid, email: $email, bio: $bio, level:${accountLevel.label}, points: $points, fullName: $fullName';
  }
}
