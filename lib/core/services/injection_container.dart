import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_ease_app/features/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:social_ease_app/features/on_boarding/data/repositories/on_boarding_repository_impl.dart';
import 'package:social_ease_app/features/on_boarding/domain/repositories/on_boarding_repository.dart';
import 'package:social_ease_app/features/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:social_ease_app/features/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:social_ease_app/features/on_boarding/presentation/cubit/on_boarding_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
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
