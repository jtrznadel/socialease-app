import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/providers/user_provider.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/media_res.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, provider, __) {
        final user = provider.user;
        final image =
            user?.profileAvatar == null || user!.profileAvatar!.isEmpty
                ? null
                : user.profileAvatar;
        return Column(
          children: [
            image != null
                ? CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(image),
                  )
                : const Image(
                    height: 120,
                    image: AssetImage(
                      MediaRes.defaultAvatarImage,
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            Text(
              user?.fullName ?? 'No User',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            if (user?.bio != null && user!.bio!.isNotEmpty) ...[
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.width * .15),
                child: Text(
                  user.bio!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
            const SizedBox(
              height: 15,
            )
          ],
        );
      },
    );
  }
}
