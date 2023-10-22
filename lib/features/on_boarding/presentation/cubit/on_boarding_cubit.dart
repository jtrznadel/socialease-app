import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_ease_app/features/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:social_ease_app/features/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit(
      {required CacheFirstTimer cacheFirstTimer,
      required CheckIfUserIsFirstTimer checkIfUserIsFirstTimer})
      : _cacheFirstTimer = cacheFirstTimer,
        _checkIfUserIsFirstTimer = checkIfUserIsFirstTimer,
        super(OnBoardingInitial());

  final CacheFirstTimer _cacheFirstTimer;
  final CheckIfUserIsFirstTimer _checkIfUserIsFirstTimer;

  Future<void> cacheFirstTimer() async {
    emit(const CachingFirstTimer());
    // await Future.delayed(const Duration(seconds: 2));
    final result = await _cacheFirstTimer();
    result.fold((failure) => emit(OnBoardingError(failure.errorMessage)),
        (_) => emit(const UserCached()));
  }

  Future<void> checkIfUserIsFirstTimer() async {
    emit(const CheckingIfUserIsFirstTimer());
    // await Future.delayed(const Duration(seconds: 2));
    final result = await _checkIfUserIsFirstTimer();

    result.fold(
      (failure) => emit(const OnBoardingStatus(isFirstTimer: true)),
      (status) => emit(OnBoardingStatus(isFirstTimer: status)),
    );
  }
}
