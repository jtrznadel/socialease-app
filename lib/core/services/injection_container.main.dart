part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initAuth();
  await _initOnBoarding();
  await _initActivity();
  await _initChat();
  await _initNotifications();
  await _initPoints();
  await _initReports();
  await _initUser();
}

Future<void> _initReports() async {
  sl
    ..registerFactory(() => ReportCubit(
          addReport: sl(),
          removeReport: sl(),
          changeReportStatus: sl(),
          getReports: sl(),
        ))
    ..registerLazySingleton(() => AddReport(sl()))
    ..registerLazySingleton(() => RemoveReport(sl()))
    ..registerLazySingleton(() => ChangeReportStatus(sl()))
    ..registerLazySingleton(() => GetReports(sl()))
    ..registerLazySingleton<ReportRepo>(() => ReportRepoImpl(sl()))
    ..registerLazySingleton<ReportRemoteDataSource>(
      () => ReportRemoteDataSourceImpl(
        firestore: sl(),
        auth: sl(),
      ),
    );
}

Future<void> _initPoints() async {
  sl
    ..registerFactory(() => PointsCubit(
          addPoints: sl(),
          subPoints: sl(),
          updateLevel: sl(),
          getPoints: sl(),
          getLevel: sl(),
          getAllTimeRanking: sl(),
          getMonthlyRanking: sl(),
        ))
    ..registerLazySingleton(() => AddPoints(sl()))
    ..registerLazySingleton(() => SubPoints(sl()))
    ..registerLazySingleton(() => UpdateLevel(sl()))
    ..registerLazySingleton(() => GetPoints(sl()))
    ..registerLazySingleton(() => GetLevel(sl()))
    ..registerLazySingleton(() => GetAllTimeRanking(sl()))
    ..registerLazySingleton(() => GetMonthlyRanking(sl()))
    ..registerLazySingleton<PointsRepo>(() => PointsRepoImpl(sl()))
    ..registerLazySingleton<PointsRemoteDataSrc>(
      () => PointsRemoteDataSrcImpl(firestore: sl(), auth: sl()),
    );
}

Future<void> _initNotifications() async {
  sl
    ..registerFactory(() => NotificationCubit(
          clear: sl(),
          clearAll: sl(),
          sendNotification: sl(),
          sendNotificationToUser: sl(),
          getNotifications: sl(),
          markAsRead: sl(),
        ))
    ..registerLazySingleton(() => Clear(sl()))
    ..registerLazySingleton(() => ClearAll(sl()))
    ..registerLazySingleton(() => SendNotification(sl()))
    ..registerLazySingleton(() => SendNotificationToUser(sl()))
    ..registerLazySingleton(() => GetNotifications(sl()))
    ..registerLazySingleton(() => MarkAsRead(sl()))
    ..registerLazySingleton<NotificationRepository>(
        () => NotificationRepoImpl(sl()))
    ..registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(firestore: sl(), auth: sl()),
    );
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

Future<void> _initUser() async {
  sl
    ..registerFactory(
      () => UserCubit(
        getUserById: sl(),
      ),
    )
    ..registerLazySingleton(() => user.GetUserById(sl()))
    ..registerLazySingleton<UserRepo>(() => UserRepoImpl(sl()))
    ..registerLazySingleton<UserRemoteDataSrc>(
      () => UserRemoteDataSrcImpl(firestore: sl(), auth: sl()),
    );
}

Future<void> _initActivity() async {
  sl
    ..registerFactory(
      () => ActivityCubit(
        addActivity: sl(),
        removeActivity: sl(),
        updateActivity: sl(),
        getActivities: sl(),
        getUserById: sl(),
        joinActivity: sl(),
        leaveActivity: sl(),
        completeActivity: sl(),
        sendRequest: sl(),
        removeRequest: sl(),
        updateActivityStatus: sl(),
        addComment: sl(),
        removeComment: sl(),
        likeComment: sl(),
        getComments: sl(),
      ),
    )
    ..registerLazySingleton(() => AddActivity(sl()))
    ..registerLazySingleton(() => RemoveActivity(sl()))
    ..registerLazySingleton(() => UpdateActivity(sl()))
    ..registerLazySingleton(() => GetActivities(sl()))
    ..registerLazySingleton(() => ac.GetUserById(sl()))
    ..registerLazySingleton(() => JoinActivity(sl()))
    ..registerLazySingleton(() => LeaveActivity(sl()))
    ..registerLazySingleton(() => CompleteActivity(sl()))
    ..registerLazySingleton(() => SendRequest(sl()))
    ..registerLazySingleton(() => RemoveRequest(sl()))
    ..registerLazySingleton(() => UpdateActivityStatus(sl()))
    ..registerLazySingleton(() => AddComment(sl()))
    ..registerLazySingleton(() => RemoveComment(sl()))
    ..registerLazySingleton(() => LikeComment(sl()))
    ..registerLazySingleton(() => GetComments(sl()))
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
