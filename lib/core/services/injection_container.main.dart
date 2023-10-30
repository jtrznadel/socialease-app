part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initAuth();
  await _initOnBoarding();
}

Future<void> _initOnBoarding() async {
  final prefs = await SharedPreferences.getInstance();
  //Future --> OnBoarding
  //Bussiness Logic
  sl
    ..registerFactory(
      () => OnBoardingCubit(
        cacheFirstTimer: sl(),
        checkIfUserIsFirstTimer: sl(),
      ),
    )
    ..registerLazySingleton(() => CacheFirstTimer(sl()))
    ..registerLazySingleton(() => CheckIfUserIsFirstTimer(sl()))
    ..registerLazySingleton<OnBoardingRepository>(
        () => OnBoardingRepositoryImpl(sl()))
    ..registerLazySingleton<OnBoardingLocalDataSource>(
        () => OnBoardingLocalDataSourceImpl(sl()))
    ..registerLazySingleton(() => prefs);
}

Future<void> _initAuth() async {
  //Future --> Auth
  //Bussingess Logic
  sl
    ..registerFactory(
      () => AuthBloc(
        signIn: sl(),
        signUp: sl(),
        forgotPassword: sl(),
        updateUser: sl(),
      ),
    )
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => ForgotPassword(sl()))
    ..registerLazySingleton(() => UpdateUser(sl()))
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()))
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        authClient: sl(),
        cloudStoreClient: sl(),
        dbClient: sl(),
      ),
    )
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance);
}
