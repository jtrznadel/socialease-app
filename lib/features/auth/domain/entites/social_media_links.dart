import 'package:equatable/equatable.dart';

class SocialMediaLinks extends Equatable {
  final String instagram;
  final String twitter;
  final String facebook;
  final String linkedin;

  const SocialMediaLinks(
      {required this.instagram,
      required this.twitter,
      required this.facebook,
      required this.linkedin});

  factory SocialMediaLinks.empty() {
    return const SocialMediaLinks(
      instagram: '',
      twitter: '',
      facebook: '',
      linkedin: '',
    );
  }

  factory SocialMediaLinks.fromMap(Map<String, dynamic> map) {
    return SocialMediaLinks(
      instagram: map['instagram'] as String? ?? '',
      twitter: map['twitter'] as String? ?? '',
      facebook: map['facebook'] as String? ?? '',
      linkedin: map['linkedin'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'instagram': instagram,
      'twitter': twitter,
      'facebook': facebook,
      'linkedin': linkedin,
    };
  }

  @override
  List<Object?> get props => [instagram, twitter, facebook, linkedin];
}
