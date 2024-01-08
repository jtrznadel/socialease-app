import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/enums/report_enum.dart';
import 'package:social_ease_app/core/utils/core_utils.dart';
import 'package:social_ease_app/features/profile/presentation/widgets/profile_action_button.dart';
import 'package:social_ease_app/features/reports/presentation/cubit/report_cubit.dart';
import 'package:social_ease_app/features/reports/presentation/views/reports_management_screen.dart';

class ReportsManagementButton extends StatefulWidget {
  const ReportsManagementButton({
    super.key,
  });

  @override
  State<ReportsManagementButton> createState() =>
      _ReportsManagementButtonState();
}

class _ReportsManagementButtonState extends State<ReportsManagementButton> {
  @override
  void initState() {
    context.read<ReportCubit>().getReports();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        if (state is ReportError) {
          CoreUtils.showSnackBar(context, state.message);
          return ProfileActionButton(
              label: 'Not Available', icon: Icons.error, onPressed: () {});
        } else if (state is ReportLoaded) {
          final reports = state.reports
              .where((report) => report.status == ReportStatus.waiting)
              .toList()
            ..sort((a, b) => a.priority.compareTo(b.priority));

          return ProfileActionButton(
              label: 'Reports Management',
              numberToCheck: reports.isNotEmpty ? reports.length : null,
              icon: Icons.report,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  ReportsManagementScreen.routeName,
                  arguments: reports,
                );
              });
        }
        return const SizedBox.shrink();
      },
    );
  }
}
