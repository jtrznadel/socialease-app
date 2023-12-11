import 'package:social_ease_app/core/enums/account_level.dart';
import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/auth/domain/entites/social_media_links.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';

class LocalUserModel extends LocalUser {
  const LocalUserModel({
    required super.uid,
    required super.email,
    required super.points,
    required super.fullName,
    required super.accountLevel,
    required super.socialMediaLinks,
    super.profilePic,
    super.bio,
    super.groups,
    super.ongoingActivities,
    super.doneActivities,
  });

  factory LocalUserModel.empty() {
    return LocalUserModel(
      uid: '',
      email: '',
      accountLevel: AccountLevel.rookie,
      socialMediaLinks: SocialMediaLinks.empty(),
      points: 0,
      fullName: '',
    );
  }

  factory LocalUserModel.fromMap(DataMap map) {
    return LocalUserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      points: (map['points'] as num).toInt(),
      accountLevel: AccountLevel.values.byName(map['accountLevel']),
      socialMediaLinks: SocialMediaLinks.fromMap(map['socialMediaLinks'] ?? {}),
      fullName: map['fullName'] as String,
      profilePic: map['profilePic'] as String?,
      bio: map['bio'] as String?,
      groups: (map['groups'] as List<dynamic>).cast<String>(),
      doneActivities: (map['doneActivities'] as List<dynamic>).cast<String>(),
      ongoingActivities:
          (map['ongoingActivities'] as List<dynamic>).cast<String>(),
    );
  }

  LocalUserModel copyWith({
    String? uid,
    String? email,
    int? points,
    String? fullName,
    String? profilePic,
    AccountLevel? accountLevel,
    SocialMediaLinks? socialMediaLinks,
    String? bio,
    List<String>? groups,
    List<String>? ongoingActivities,
    List<String>? doneActivities,
  }) {
    return LocalUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      points: points ?? this.points,
      accountLevel: accountLevel ?? this.accountLevel,
      socialMediaLinks: socialMediaLinks ?? this.socialMediaLinks,
      fullName: fullName ?? this.fullName,
      profilePic: profilePic ?? this.profilePic,
      bio: bio ?? this.bio,
      groups: groups ?? this.groups,
      ongoingActivities: ongoingActivities ?? this.ongoingActivities,
      doneActivities: doneActivities ?? this.doneActivities,
    );
  }

  DataMap toMap() {
    return {
      'uid': uid,
      'email': email,
      'points': points,
      'fullName': fullName,
      'accountLevel': accountLevel.name,
      'socialMediaLinks': socialMediaLinks.toMap(),
      'profilePic': profilePic,
      'bio': bio,
      'groups': groups,
      'ongoingActivities': ongoingActivities,
      'doneActivities': doneActivities,
    };
  }
}
