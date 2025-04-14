import 'package:bloc/bloc.dart';
import 'package:boilerplate_example/domain/auth/auth_repository.dart';
import 'package:boilerplate_example/domain/core/configs/app_config.dart';
import 'package:boilerplate_example/domain/core/configs/helpers/generic_helpers.dart';
import 'package:boilerplate_example/domain/core/constants/string_constants.dart';
import 'package:boilerplate_example/infrastructure/auth/i_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(super.initialState);

  void emitFromAnywhere({required AuthState state}) {
    emit(state);
  }

  Future<void> onChangeEmail({required String email}) async {
    final emailAddress = email.trim();
    bool isEmailValid = GenericHelpers().isValidEmail(emailAddress);
    String errorEmailAddress = '';
    if (isEmailValid) {
      errorEmailAddress = '';
    } else {
      errorEmailAddress = ErrorConstants.invalidEmail;
    }
    emit(
      state.copyWith(
        isFailed: false,
        isSuccessful: false,
        isLoading: false,
        errorEmail: errorEmailAddress,
      ),
    );
  }

  void onChangePassword({required String password}) {
    RegExp upperCaseRegex = RegExp(r'(?=.*[A-Z])');
    RegExp digitRegex = RegExp(r'(?=.*[0-9])');
    RegExp specialCharRegex = RegExp(
      r'(?=.*[!@#\$%\^&\*\(\)\-_\+=\[\]\{\}\|;:"<>,./?])',
    );
    bool isPasswordValid =
        password.length >= 8 &&
        upperCaseRegex.hasMatch(password) &&
        digitRegex.hasMatch(password) &&
        specialCharRegex.hasMatch(password);
    if (isPasswordValid) {
      emit(
        state.copyWith(
          isFailed: false,
          isSuccessful: false,
          isLoading: false,
          errorPassword: '',
        ),
      );
    } else {
      emit(
        state.copyWith(
          isFailed: false,
          isSuccessful: false,
          isLoading: false,
          errorPassword: GenericHelpers.getErrorPasswordMessage(password),
        ),
      );
    }
  }

  void login() async {
    final email = state.emailController.text.trim().toLowerCase();
    final password = state.passwordController.text.trim();

    bool isEmailValid =
        GenericHelpers().isValidEmail(email) && state.errorEmail.isEmpty;
    RegExp upperCaseRegex = RegExp(r'(?=.*[A-Z])');
    RegExp digitRegex = RegExp(r'(?=.*[0-9])');
    RegExp specialCharRegex = RegExp(
      r'(?=.*[!@#\$%\^&\*\(\)\-_\+=\[\]\{\}\|;:"<>,./?])',
    );
    bool isPasswordValid =
        password.length >= 8 &&
        upperCaseRegex.hasMatch(password) &&
        digitRegex.hasMatch(password) &&
        specialCharRegex.hasMatch(password);

    if (isEmailValid && isPasswordValid) {
      emit(state.copyWith(isLoading: true));
      await Future.delayed(const Duration(seconds: 1));
      state.appStateNotifier.updateAfterAuthChange(isAuthorized: true);
      await Future.delayed(const Duration(milliseconds: 250));
      emit(
        state.copyWith(
          isLoading: false,
          isFailed: false,
          isSuccessful: true,
          appStateNotifier: state.appStateNotifier,
        ),
      );
    } else {
      String updatedErrorEmail =
          (state.errorEmail.isNotEmpty)
              ? state.errorEmail
              : ErrorConstants.emailError;

      if (!isEmailValid && !isPasswordValid) {
        emit(
          state.copyWith(
            isFailed: false,
            isSuccessful: false,
            isLoading: false,
            enableSubmit: false,
            errorEmail: updatedErrorEmail,
            errorPassword: ErrorConstants.enterValidPassword,
          ),
        );
      } else if (!isEmailValid) {
        emit(
          state.copyWith(
            isFailed: false,
            isSuccessful: false,
            isLoading: false,
            enableSubmit: false,
            errorPassword: '',
            errorEmail: updatedErrorEmail,
          ),
        );
      } else if (!isPasswordValid) {
        emit(
          state.copyWith(
            isFailed: false,
            isSuccessful: false,
            isLoading: false,
            enableSubmit: false,
            errorEmail: '',
            errorPassword: GenericHelpers.getErrorPasswordMessage(password),
          ),
        );
      }
    }
  }
}
