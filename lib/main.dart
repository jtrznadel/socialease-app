import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/providers/activity_of_the_day_notifier.dart';
import 'package:social_ease_app/core/common/app/providers/explore_activities_type_notifier.dart';
import 'package:social_ease_app/core/common/app/providers/user_provider.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/core/services/router.dart';
import 'package:social_ease_app/features/dashboard/presentation/providers/dashboard_controller.dart';
import 'package:social_ease_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

  await init();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DashboardController()),
        ChangeNotifierProvider(create: (_) => ActivityOfTheDayNotifier()),
        ChangeNotifierProvider(create: (_) => ExploreActivitiesTypeNotifier()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '.socialEase',
        theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            colorScheme: ColorScheme.fromSwatch(accentColor: Colors.white),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(color: Colors.transparent),
            scaffoldBackgroundColor: Colors.white),
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
