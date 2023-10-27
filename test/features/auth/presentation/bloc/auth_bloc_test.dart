import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_ease_app/core/errors/failures.dart';
import 'package:social_ease_app/features/auth/data/models/user_model.dart';
import 'package:social_ease_app/features/auth/domain/usecases/forgot_password.dart';
import 'package:social_ease_app/features/auth/domain/usecases/sign_in.dart';
import 'package:social_ease_app/features/auth/domain/usecases/sign_up.dart';
import 'package:social_ease_app/features/auth/domain/usecases/update_user.dart';
import 'package:social_ease_app/features/auth/presentation/bloc/auth_bloc.dart';
import '';

class MockSignIn extends Mock implements SignIn {}

class MockSignUp extends Mock implements SignUp {}

class MockForgotPassword extends Mock implements ForgotPassword {}

class MockUpdateUser extends Mock implements UpdateUser {}

void main() {
  late SignIn signIn;
  late SignUp signUp;
  late ForgotPassword forgotPassword;
  late UpdateUser updateUser;
  late AuthBloc authBloc;

  final tSignUpParams = SignUpParams.empty();
  final tUpdateUserParams = UpdateUserParams.empty();
  final tSignInParams = SignInParams.empty();

  setUp(() {
    signIn = MockSignIn();
    signUp = MockSignUp();
    forgotPassword = MockForgotPassword();
    updateUser = MockUpdateUser();
    authBloc = AuthBloc(
        signIn: signIn,
        signUp: signUp,
        forgotPassword: forgotPassword,
        updateUser: updateUser);
  });

  setUpAll(() {
    registerFallbackValue(tSignInParams);
    registerFallbackValue(tSignUpParams);
    registerFallbackValue(tUpdateUserParams);
  });

  tearDown(() => authBloc.close());

  test('initialState should be [AuthInitial]', () {
    expect(authBloc.state, const AuthInitial());
  });

  const tServerFailure = ServerFailure(
      message: 'user-not-found', statusCode: 'There is no user record');
  group('SignInEvent', () {
    final tUser = LocalUserModel.empty();
    blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, SignedIn] when [SignInEvent] is added.',
        build: () {
          when(() => signIn(any())).thenAnswer((_) async => Right(tUser));
          return authBloc;
        },
        act: (bloc) => bloc.add(
              SignInEvent(
                email: tSignInParams.email,
                password: tSignInParams.password,
              ),
            ),
        expect: () => [const AuthLoading(), SignedIn(tUser)],
        verify: (_) {
          verify(() => signIn(tSignInParams)).called(1);
          verifyNoMoreInteractions(signIn);
        });

    blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthError] when signIn fails',
        build: () {
          when(() => signIn(any()))
              .thenAnswer((_) async => const Left(tServerFailure));
          return authBloc;
        },
        act: (bloc) => bloc.add(
              SignInEvent(
                email: tSignInParams.email,
                password: tSignInParams.password,
              ),
            ),
        expect: () => [
              const AuthLoading(),
              AuthError(tServerFailure.errorMessage),
            ],
        verify: (_) {
          verify(() => signIn(tSignInParams)).called(1);
          verifyNoMoreInteractions(signIn);
        });
  });

  group('SignUpEvent', () {
    blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, SignedUp] when SignedUpEvent is added and SignUp is succeeds',
        build: () {
          when(() => signUp(any())).thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(
              SignUpEvent(
                  email: tSignUpParams.email,
                  password: tSignUpParams.password,
                  fullName: tSignUpParams.fullName),
            ),
        expect: () => [
              const AuthLoading(),
              const SignedUp(),
            ],
        verify: (_) {
          verify(() => signUp(tSignUpParams)).called(1);
          verifyNoMoreInteractions(signUp);
        });

    blocTest(
        'should emit [AuthLoading, AuthError] when SignUpEvent is added and SignUp fails',
        build: () {
          when(() => signUp(any()))
              .thenAnswer((_) async => const Left(tServerFailure));
          return authBloc;
        },
        act: (bloc) => bloc.add(
              SignUpEvent(
                  email: tSignUpParams.email,
                  password: tSignUpParams.password,
                  fullName: tSignUpParams.fullName),
            ),
        expect: () => [
              const AuthLoading(),
              AuthError(tServerFailure.errorMessage),
            ],
        verify: (_) {
          verify(() => signUp(tSignUpParams)).called(1);
          verifyNoMoreInteractions(signUp);
        });
  });

  group('ForgotPasswordEvent', () {
    blocTest(
        'should emit [AuthLoading, ForgotPasswordSent] when ForgotPasswordEvent is added and ForgotPassword succeeds',
        build: () {
          when(() => forgotPassword(any()))
              .thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(const ForgotPasswordEvent(email: 'email')),
        expect: () => [const AuthLoading(), const ForgotPasswordSent()],
        verify: (_) {
          verify(
            () => forgotPassword('email'),
          ).called(1);
          verifyNoMoreInteractions(forgotPassword);
        });

    blocTest(
        'should emit [AuthLoading, AuthError] when ForgotPasswordEvent is added and ForgotPassword fails',
        build: () {
          when(() => forgotPassword(any()))
              .thenAnswer((_) async => const Left(tServerFailure));
          return authBloc;
        },
        act: (bloc) => bloc.add(
              const ForgotPasswordEvent(email: 'email'),
            ),
        expect: () => [
              const AuthLoading(),
              AuthError(tServerFailure.errorMessage),
            ],
        verify: (_) {
          verify(() => forgotPassword('email')).called(1);
          verifyNoMoreInteractions(signUp);
        });
  });

  group('UpdateUserEvent', () {
    blocTest(
        'should emit [AuthLoading, UserUpdated] when UpdateUserEvent is added and UpdateUser succeeds',
        build: () {
          when(() => updateUser(any()))
              .thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(
              UpdateUserEvent(
                updateAction: tUpdateUserParams.action,
                userData: tUpdateUserParams.userdata,
              ),
            ),
        expect: () => [
              const AuthLoading(),
              const UserUpdated(),
            ],
        verify: (_) {
          verify(() => updateUser(tUpdateUserParams)).called(1);
          verifyNoMoreInteractions(updateUser);
        });

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when UpdateUserEvent is added and '
      'UpdateUser fails',
      build: () {
        when(() => updateUser(any())).thenAnswer(
          (_) async => const Left(tServerFailure),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(
          updateAction: tUpdateUserParams.action,
          userData: tUpdateUserParams.userdata,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => updateUser(tUpdateUserParams)).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );
  });
}
