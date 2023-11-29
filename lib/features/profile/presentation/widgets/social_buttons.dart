import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_ease_app/features/auth/domain/entites/social_media_links.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({
    super.key,
    required this.mediaLinks,
  });

  final SocialMediaLinks mediaLinks;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () async {
            final Uri url = Uri.parse(
                'https://stackoverflow.com/questions/63026234/url-launcher-canlaunch-launch-dont-work-on-ios-for-simple-url-scheme');
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          icon: const Icon(
            FontAwesomeIcons.instagram,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            FontAwesomeIcons.twitter,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            FontAwesomeIcons.facebookF,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            FontAwesomeIcons.linkedinIn,
          ),
        ),
      ],
    );
  }
}
