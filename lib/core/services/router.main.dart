part of 'router.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      final prefs = sl<SharedPreferences>();
      return _pageBuilder((context) {
        if (prefs.getBool(kFirstTimerKey) ?? true) {
          return BlocProvider(
              create: (_) => sl<OnBoardingCubit>(),
              child: const OnBoardingScreen());
        } else if (sl<FirebaseAuth>().currentUser != null) {
          final user = sl<FirebaseAuth>().currentUser!;
          final localUser = LocalUserModel(
            uid: user.uid,
            email: user.email ?? '',
            points: 0,
            accountLevel: AccountLevel.rookie,
            socialMediaLinks: SocialMediaLinks.empty(),
            fullName: user.displayName ?? '',
          );
          context.userProvider.initUser(localUser);
          context.read<LocationProvider>().getCurrentPosition();
          return const Dashboard();
        } else {
          return BlocProvider(
            create: (_) => sl<AuthBloc>(),
            child: const SignInScreen(),
          );
        }
      }, settings: settings);
    case SignInScreen.routeName:
      return _pageBuilder(
          (_) => BlocProvider(
                create: (_) => sl<AuthBloc>(),
                child: const SignInScreen(),
              ),
          settings: settings);
    case SignUpScreen.routeName:
      return _pageBuilder(
          (_) => BlocProvider(
                create: (_) => sl<AuthBloc>(),
                child: const SignUpScreen(),
              ),
          settings: settings);
    case Dashboard.routeName:
      return _pageBuilder((_) => const Dashboard(), settings: settings);
    case RequestsManagementScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<ActivityCubit>(),
          child: const RequestsManagementScreen(),
        ),
        settings: settings,
      );
    case ActivitiesManagementScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<ActivityCubit>(),
          child: const ActivitiesManagementScreen(),
        ),
        settings: settings,
      );
    case ActivityDetailsScreen.routeName:
      return _pageBuilder(
          (_) => ActivityDetailsScreen(
              settings.arguments as ActivityDetailsArguments),
          settings: settings);
    case EditActivityScreen.routeName:
      return _pageBuilder(
          (_) => BlocProvider(
                create: (_) => sl<ActivityCubit>(),
                child: EditActivityScreen(settings.arguments as Activity),
              ),
          settings: settings);
    case ActivityMembersScreen.routeName:
      return _pageBuilder(
          (_) => ActivityMembersScreen(
              members: settings.arguments as List<String>),
          settings: settings);

    case '/forgot-password':
      return _pageBuilder((_) => const fui.ForgotPasswordScreen(),
          settings: settings);
    default:
      return _pageBuilder((_) => const PageUnderConstruction(),
          settings: settings);
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder: (_, animation, __, child) => FadeTransition(
      opacity: animation,
      child: child,
    ),
    pageBuilder: (context, _, __) => page(context),
  );
}
