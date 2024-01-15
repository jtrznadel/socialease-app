import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/common/views/loading_view.dart';
import 'package:social_ease_app/core/common/widgets/content_empty.dart';
import 'package:social_ease_app/core/enums/report_enum.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/features/dashboard/presentation/utils/dashboard_utils.dart';
import 'package:social_ease_app/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:social_ease_app/features/points/presentation/cubit/points_cubit.dart';
import 'package:social_ease_app/features/reports/data/models/report_model.dart';
import 'package:social_ease_app/features/reports/domain/entities/report.dart';
import 'package:social_ease_app/features/reports/presentation/cubit/report_cubit.dart';
import 'package:social_ease_app/features/reports/presentation/widgets/report_tile.dart';

class ReportsManagementScreen extends StatefulWidget {
  const ReportsManagementScreen(this.reports, {Key? key}) : super(key: key);

  static const routeName = '/reports-management';
  final List<Report> reports;

  @override
  State<ReportsManagementScreen> createState() =>
      _ReportsManagementScreenState();
}

class _ReportsManagementScreenState extends State<ReportsManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Reports Management',
            style: TextStyle(
              fontFamily: Fonts.poppins,
            ),
          ),
        ),
        body: StreamBuilder(
            stream: DashboardUtils.reportsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingView();
              } else if (snapshot.hasError) {
                return const ContentEmpty(
                    text: 'There are not pending reports');
              } else if (snapshot.hasData) {
                List<ReportModel> reports = snapshot.data!;
                reports.removeWhere(
                    (report) => report.status == ReportStatus.verified);

                if (reports.isNotEmpty) {
                  return ListView.builder(
                    itemCount: reports.length,
                    itemBuilder: (BuildContext context, int index) {
                      var report = reports[index];
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => sl<NotificationCubit>(),
                          ),
                          BlocProvider(
                            create: (context) => sl<PointsCubit>(),
                          ),
                          BlocProvider(
                            create: (context) => sl<ReportCubit>(),
                          ),
                        ],
                        child: ReportTile(
                          report: report,
                        ),
                      );
                    },
                  );
                }
                return const ContentEmpty(
                    text: 'There are not pending reports');
              } else {
                return const SizedBox();
              }
            }));
  }
}
