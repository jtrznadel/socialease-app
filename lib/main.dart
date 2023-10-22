import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/core/services/router.dart';
import 'package:social_ease_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '.socialEase',
      theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme:
              ColorScheme.fromSwatch(accentColor: AppColors.primaryColor),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(color: Colors.transparent),
          scaffoldBackgroundColor: Colors.white),
      onGenerateRoute: generateRoute,
    );
  }
}
