import 'package:flutter/material.dart';
import 'package:social_ease_app/core/common/views/loading_view.dart';
import 'package:social_ease_app/core/common/widgets/content_empty.dart';
import 'package:social_ease_app/core/enums/report_enum.dart';
import 'package:social_ease_app/features/dashboard/presentation/utils/dashboard_utils.dart';
import 'package:social_ease_app/features/profile/presentation/widgets/profile_action_button.dart';
import 'package:social_ease_app/features/reports/data/models/report_model.dart';
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
  late Stream<List<ReportModel>> _reportsStream;

  @override
  void initState() {
    super.initState();
    _reportsStream = DashboardUtils.reportsStream;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _reportsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView();
          } else if (snapshot.hasError) {
            return const ContentEmpty(text: 'No reports found');
          } else if (snapshot.hasData) {
            List<ReportModel> reports = snapshot.data!;
            reports.removeWhere(
                (report) => report.status == ReportStatus.verified);

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
          } else {
            return const SizedBox();
          }
        });
  }
}
