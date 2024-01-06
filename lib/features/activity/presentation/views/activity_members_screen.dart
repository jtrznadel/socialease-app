import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/common/widgets/nested_back_button.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/activity/presentation/widgets/activity_member_tile.dart';

class ActivityMembersScreen extends StatelessWidget {
  const ActivityMembersScreen({super.key, required this.members});

  static const routeName = '/activity-members';

  final List<String> members;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const NestedBackButton(),
        title: const Text('Activity Members'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
          itemCount: members.length,
          itemBuilder: (BuildContext context, int index) {
            return BlocProvider(
              create: (context) => sl<ActivityCubit>(),
              child: ActivityMemberTile(memberId: members[index]),
            );
          },
        ),
      ),
    );
  }
}
