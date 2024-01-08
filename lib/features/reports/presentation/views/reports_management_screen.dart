import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/common/widgets/content_empty.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:social_ease_app/features/points/presentation/cubit/points_cubit.dart';
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
      body: widget.reports.isEmpty
          ? const ContentEmpty(text: 'There are not pending reports')
          : Padding(
              padding: const EdgeInsets.all(15),
              child: ListView.builder(
                itemCount: widget.reports.length,
                itemBuilder: (BuildContext context, int index) {
                  var report = widget.reports[index];
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
              ),
            ),
    );
  }
}
