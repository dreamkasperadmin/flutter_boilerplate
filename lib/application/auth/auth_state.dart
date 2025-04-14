part of 'auth_cubit.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState(
      {required bool isLoading,
      required bool isSuccessful,
      required bool isFailed,
      required bool noUse,
      required bool enableSubmit,
      required bool obscurePassword,
      required String errorMessage,
      required String errorEmail,
      required String errorPassword,
      required TextEditingController emailController,
      required TextEditingController passwordController,
      required AuthRepository authRepository,
      required AppStateNotifier appStateNotifier}) = _AuthState;

  factory AuthState.initial({required AppStateNotifier appStateNotifier,
  required String appUrl}) =>
      AuthState(
          noUse: false,
          isLoading: false,
          isFailed: false,
          isSuccessful: false,
          enableSubmit: false,
          obscurePassword: true,
          errorEmail: '',
          errorPassword: '',
          errorMessage: '',
          emailController: TextEditingController(),
          passwordController: TextEditingController(),
          authRepository: IAuthRepository(appUrl: appUrl),
          appStateNotifier: appStateNotifier);
}
