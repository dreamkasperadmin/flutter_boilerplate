import 'package:boilerplate_example/domain/core/configs/injection.dart';
import 'package:boilerplate_example/domain/core/constants/other_constants.dart';
import 'package:boilerplate_example/domain/core/services/navigation_service/navigation_service.dart';
import 'package:boilerplate_example/domain/core/services/navigation_service/routers/route_names.dart';
import 'package:boilerplate_example/presentation/core/widgets/custom_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../application/auth/auth_cubit.dart';
import '../../domain/core/configs/app_config.dart';
import '../../domain/core/constants/asset_constants.dart';
import '../../domain/core/constants/string_constants.dart';
import '../core/widgets/custom_button.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appUrl = AppConfig.of(context)!.appUrl;
    final appStateNotifier = Provider.of<AppStateNotifier>(context);
    return BlocProvider(
      create:
          (context) => AuthCubit(
            AuthState.initial(
              appUrl: appUrl,
              appStateNotifier: appStateNotifier,
            ),
          ),
      child: AuthScreenConsumer(),
    );
  }
}

class AuthScreenConsumer extends StatelessWidget {
  const AuthScreenConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.isSuccessful) {
          navigator<NavigationService>().navigateTo(
            CoreRoutes.mainNavRoute,
            isClearStack: true,
          );
          context.read<AuthCubit>().emitFromAnywhere(
            state: state.copyWith(isSuccessful: false),
          );
        } else if (state.isFailed) {
          if (state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).colorScheme.error,
                content: Text(state.errorMessage),
                duration: const Duration(seconds: 2),
              ),
            );
            context.read<AuthCubit>().emitFromAnywhere(
              state: state.copyWith(isFailed: false, errorMessage: ''),
            );
          }
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state.isLoading,
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: AuthScreenConstants.titlePart1,
                            style:  Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontWeight: FontWeight.w700,
                              fontSize: 24.sp,
                            ),
                          ),
                          TextSpan(
                            text: AuthScreenConstants.titlePart2,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 24.sp,
                            ),
                          ),
                          TextSpan(
                            text: AuthScreenConstants.titlePart3,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontWeight: FontWeight.w700,
                              fontSize: 24.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      AuthScreenConstants.subTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.tertiaryFixed,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    CustomTextField(
                      inputWithLabel: true,
                      labelText: AuthScreenConstants.emailId,
                      hintText: AuthScreenConstants.emailIdHint,
                      controller: state.emailController,
                      addLabelSide: false,
                      
                       errorText: state.errorEmail.isNotEmpty
                                ? state.errorEmail
                                : null,
                      onChanged: (value) {
                        BlocProvider.of<AuthCubit>(context).onChangeEmail(
                          email: value
                        );
                      },
                    ),
                    SizedBox(height: 1.h),
                    CustomTextField(
                      inputWithLabel: true,
                      obscureText: state.obscurePassword,
                      labelText: AuthScreenConstants.password,
                      hintText: AuthScreenConstants.passwordHintText,
                      controller: state.passwordController,
                      suffixIconTap: () {
                        BlocProvider.of<AuthCubit>(context).emitFromAnywhere(
                          state: state.copyWith(
                            obscurePassword: !state.obscurePassword,
                          ),
                        );
                      },
                       errorText: state.errorPassword.isNotEmpty
                                ? state.errorPassword
                                : null,
                      suffixIcon: SvgPicture.asset(
                        !state.obscurePassword
                            ? AssetConstants.hidePassword
                            : AssetConstants.unHidePassword,
                        fit: BoxFit.cover,
                        alignment: Alignment.centerRight,
                      ),
                      addLabelSide: false,
                      onChanged: (value) {
                        BlocProvider.of<AuthCubit>(context).onChangePassword(
                          password: value
                        );
                      },
                    ),
          
                    Spacer(),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 2.h,
                            horizontal: 0.w,
                          ),
                          child: CustomButton(
                            text: AuthScreenConstants.login,
                            function: () {
                              FocusScope.of(context).unfocus();
                              BlocProvider.of<AuthCubit>(context).login();
                            },
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: AuthScreenConstants.termsAndConditionsText,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                              color: Theme.of(context).colorScheme.onTertiary,
                            ),
                            children: [
                              TextSpan(
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () async {
                                        final Uri url = Uri.parse(
                                          OtherConstants.termsOfUseLink,
                                        );
                                        if (await canLaunchUrl(url)) {
                                          launchUrl(url);
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: ErrorConstants.failedToLaunchUrl,
                                          );
                                        }
                                      },
                                text: AuthScreenConstants.termsAndConditions,
                                  
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontSize: 14.sp,
                                  color: Theme.of(context).colorScheme.onTertiary,
                                  decorationColor:
                                      Theme.of(context).colorScheme.onTertiary,
                                  decoration: TextDecoration.combine([
                                    TextDecoration.underline,
                                  ]),
                                ),
                              ),
                              TextSpan(
                                text: AuthScreenConstants.and,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  color: Theme.of(context).colorScheme.onTertiary,
                                ),
                              ),
                              TextSpan(
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () async {
                                        final Uri url = Uri.parse(
                                          OtherConstants.privacyStatementLink,
                                        );
                                        if (await canLaunchUrl(url)) {
                                          launchUrl(url);
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: ErrorConstants.failedToLaunchUrl,
                                          );
                                        }
                                      },
                                text: AuthScreenConstants.privacyPolicy,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontSize: 14.sp,
                                  color: Theme.of(context).colorScheme.onTertiary,
                                  decorationColor:
                                      Theme.of(context).colorScheme.onTertiary,
                                  decoration: TextDecoration.combine([
                                    TextDecoration.underline,
                                  ]),
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
               
                  ],
                ),
              ),
            ),
           ),
        );
      },
    );
  }
}
