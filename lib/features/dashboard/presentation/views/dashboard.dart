import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/provides/user_provider.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/features/auth/data/models/user_model.dart';
import 'package:social_ease_app/features/dashboard/providers/dashboard_controller.dart';
import 'package:social_ease_app/features/dashboard/utils/dashboard_utils.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  static const routeName = '/dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final icons = <IconData>[
    Icons.home,
    Icons.person,
    Icons.home,
    Icons.home,
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LocalUserModel>(
        stream: DashboardUtils.userDataStream,
        builder: (_, snapshot) {
          if (snapshot.hasData && snapshot.data is LocalUserModel) {
            context.read<UserProvider>().user = snapshot.data;
          }
          return Consumer<DashboardController>(builder: (_, controller, __) {
            return Scaffold(
              body: IndexedStack(
                index: controller.currentIndex,
                children: controller.screens,
              ),

              bottomNavigationBar: AnimatedBottomNavigationBar(
                icons: const [
                  Icons.home_rounded,
                  Icons.explore_rounded,
                  Icons.forum_rounded,
                  Icons.person_2_rounded,
                ],
                activeIndex: controller.currentIndex,
                gapLocation: GapLocation.none,
                notchSmoothness: NotchSmoothness.defaultEdge,
                onTap: controller.changeIndex,
                backgroundColor: AppColors.primaryColor,
                leftCornerRadius: 30,
                rightCornerRadius: 30,
                iconSize: 28,
                height: 50,
                splashColor: AppColors.secondaryColor,
                activeColor: Colors.white,
                inactiveColor: Colors.black,
              ),
              // bottomNavigationBar: BottomNavigationBar(
              //   currentIndex: controller.currentIndex,
              //   showSelectedLabels: false,
              //   backgroundColor: Colors.white,
              //   elevation: 6,
              //   onTap: controller.changeIndex,
              //   items: [
              //     BottomNavigationBarItem(
              //       label: '',
              //       icon: Icon(
              //         controller.currentIndex == 0
              //             ? Icons.home
              //             : Icons.home_filled,
              //         color: controller.currentIndex == 0
              //             ? AppColors.primaryColor
              //             : Colors.grey,
              //       ),
              //     ),
              //     BottomNavigationBarItem(
              //       label: '',
              //       icon: Icon(
              //         controller.currentIndex == 1
              //             ? Icons.home
              //             : Icons.home_filled,
              //         color: controller.currentIndex == 1
              //             ? AppColors.primaryColor
              //             : Colors.grey,
              //       ),
              //     ),
              //     BottomNavigationBarItem(
              //       label: '',
              //       icon: Icon(
              //         controller.currentIndex == 2
              //             ? Icons.home
              //             : Icons.home_filled,
              //         color: controller.currentIndex == 2
              //             ? AppColors.primaryColor
              //             : Colors.grey,
              //       ),
              //     ),
              //     BottomNavigationBarItem(
              //       label: '',
              //       icon: Icon(
              //         controller.currentIndex == 3
              //             ? Icons.home
              //             : Icons.home_filled,
              //         color: controller.currentIndex == 3
              //             ? AppColors.primaryColor
              //             : Colors.grey,
              //       ),
              //     ),
              //     BottomNavigationBarItem(
              //       label: '',
              //       icon: Icon(
              //         controller.currentIndex == 4
              //             ? Icons.home
              //             : Icons.home_filled,
              //         color: controller.currentIndex == 4
              //             ? AppColors.primaryColor
              //             : Colors.grey,
              //       ),
              //     ),
              //   ],
              // ),
            );
          });
        });
  }
}
