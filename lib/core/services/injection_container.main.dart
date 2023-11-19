part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initAuth();
  await _initOnBoarding();
  await _initActivity();
  await _initChat();
}

Future<void> _initChat() async {
  sl
    ..registerFactory(
      () => ChatCubit(
        getGroups: sl(),
        getMessages: sl(),
        getUserById: sl(),
        joinGroup: sl(),
        leaveGroup: sl(),
        sendMessage: sl(),
      ),
    )
    ..registerLazySingleton(() => GetGroups(sl()))
    ..registerLazySingleton(() => GetMessages(sl()))
    ..registerLazySingleton(() => GetUserById(sl()))
    ..registerLazySingleton(() => JoinGroup(sl()))
    ..registerLazySingleton(() => LeaveGroup(sl()))
    ..registerLazySingleton(() => SendMessage(sl()))
    ..registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(sl()))
    ..registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(firestore: sl(), auth: sl()),
    );
}

Future<void> _initActivity() async {
  sl
    ..registerFactory(
      () => ActivityCubit(
        addActivity: sl(),
        getActivities: sl(),
      ),
    )
    ..registerLazySingleton(() => AddActivity(sl()))
    ..registerLazySingleton(() => GetActivities(sl()))
    ..registerLazySingleton<ActivityRepository>(
        () => ActivityRepositoryImpl(sl()))
    ..registerLazySingleton<ActivityRemoteDataSource>(
        () => ActivityRemoteDataSourceImpl(
              auth: sl(),
              storage: sl(),
              firestore: sl(),
            ));
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
