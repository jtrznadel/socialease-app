import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/res/media_res.dart';

import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';

class ActivityMemberTile extends StatefulWidget {
  final String memberId;

  const ActivityMemberTile({Key? key, required this.memberId})
      : super(key: key);

  @override
  _ActivityMemberTileState createState() => _ActivityMemberTileState();
}

class _ActivityMemberTileState extends State<ActivityMemberTile> {
  LocalUser? user;

  @override
  void initState() {
    super.initState();
    context.read<ActivityCubit>().getUser(widget.memberId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActivityCubit, ActivityState>(
        listener: (context, state) {
          if (state is UserLoaded) {
            setState(() {
              user = state.user;
            });
          }
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: user?.profilePic != null
                ? NetworkImage(user!.profilePic!) as ImageProvider
                : const AssetImage(MediaRes.defaultAvatarImage),
          ),
          title: Text(
              user?.fullName ?? 'Unknown'), // Załóżmy, że User ma pole fullName
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.report),
                onPressed: () {
                  // Obsługa zgłoszenia użytkownika
                  // TODO: Implementuj zgłaszanie użytkownika
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  // Obsługa dodawania punktów użytkownikowi
                  // TODO: Implementuj dodawanie punktów
                },
              ),
            ],
          ),
        ));
  }
}
