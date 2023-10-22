import 'package:social_ease_app/core/utils/typedefs.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';

class LocalUserModel extends LocalUser {
  const LocalUserModel(
      {required super.uid,
      required super.email,
      required super.points,
      required super.fullName,
      super.profileAvatar,
      super.bio,
      super.groupIds});

  factory LocalUserModel.empty() {
    return const LocalUserModel(uid: '', email: '', points: 0, fullName: '');
  }

  factory LocalUserModel.fromMap(DataMap map) {
    return LocalUserModel(
        uid: map['uid'] as String,
        email: map['email'] as String,
        points: (map['points'] as num).toInt(),
        fullName: map['fullName'] as String,
        profileAvatar: map['profileAvatar'] as String?,
        bio: map['bio'] as String?,
        groupIds: (map['groupIds'] as List<dynamic>).cast<String>());
  }

  LocalUserModel copyWith(
      {String? uid,
      String? email,
      int? points,
      String? fullName,
      String? profileAvatar,
      String? bio,
      List<String>? groupIds}) {
    return LocalUserModel(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        points: points ?? this.points,
        fullName: fullName ?? this.fullName,
        profileAvatar: profileAvatar ?? this.profileAvatar,
        bio: bio ?? this.bio,
        groupIds: groupIds ?? this.groupIds);
  }

  DataMap toMap() {
    return {
      'uid': uid,
      'email': email,
      'points': points,
      'fullName': fullName,
      'profileAvatar': profileAvatar,
      'bio': bio,
      'groupIds': groupIds
    };
  }
}
