import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/models/email.dart';
import '../../../core/models/password.dart';
import '../../../shared/widgets/custom_text_form_field.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/google_signin_button.dart';
import '../../../shared/widgets/or_divider.dart';
import '../../../shared/animations/slide_page_route.dart';
import '../../../shared/animations/animated_form_field.dart';
import '../../../screens/home_screen.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/login_form_cubit.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.headerBackground,
      resizeToAvoidBottomInset: true,
      body: MultiBlocProvider(
        providers: [BlocProvider(create: (_) => LoginFormCubit())],
        child: const LoginView(),
      ),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? AppStrings.errorOccurred),
              backgroundColor: AppColors.error,
            ),
          );
        } else if (state.status == AuthStatus.authenticated) {
          // Navigate to home screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    // Full screen background image
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.headerBackground,
                        ),
                        child: Opacity(
                          opacity: 0.7,
                          child: Image.asset(
                            AppStrings.backgroundImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    // Content overlay
                    Column(
                      children: [
                        // Header with rocket illustration and logo
                        const HeaderSection(),
                        // Login form content with rounded corners
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadowLight,
                                  blurRadius: 10,
                                  offset: const Offset(0, -5),
                                ),
                              ],
                            ),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(22, 20, 22, 16),
                              child: LoginFormSection(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final totalHeight = 200 + statusBarHeight; // Reduced from 240 to 200 for more content space

    return SizedBox(
      height: totalHeight,
      width: double.infinity,
      child: Stack(
        children: [
          // Rocket illustration positioned below status bar
          Positioned(
            left: 0,
            right: 0,
            top: statusBarHeight + 20,
            bottom: 40,
            child: Center(
                child: Image.asset(
                  AppStrings.rocketImage,
                  width: 200,
                  height: 160,
                  fit: BoxFit.contain,
                ),
              ),
          ),

          // Logo positioned in status bar area
          Positioned(
            top: statusBarHeight + 16,
            right: 24,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryButton,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  AppStrings.starIcon,
                  width: 24,
                  height: 24,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginFormSection extends StatelessWidget {
  const LoginFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title Section
        AnimatedFormField(
          delay: const Duration(milliseconds: 200),
          child: Column(
            children: [
              Text(
                AppStrings.welcomeBack,
                style: AppTextStyles.heading28Bold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.loginSubtitle,
                style: AppTextStyles.subheader16Regular,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12), // Reduced from 16

        // Form Fields
        const LoginForm(),

        const SizedBox(height: 16), // Reduced from 20

        // Login Button
        AnimatedFormField(
          delay: const Duration(milliseconds: 800),
          child: const LoginButton(),
        ),

        const SizedBox(height: 16), // Reduced from 20

        // Or Divider
        AnimatedFormField(
          delay: const Duration(milliseconds: 850),
          child: OrDivider(text: AppStrings.orContinueWith),
        ),

        const SizedBox(height: 16), // Reduced from 20

        // Google Sign In Button
        AnimatedFormField(
          delay: const Duration(milliseconds: 900),
          child: GoogleSignInButton(
            onPressed: () {
              // Handle Google sign in
              // TODO: Implement Google sign in logic
            },
          ),
        ),

        const SizedBox(height: 16), // Reduced from 20

        // Forgot Password
        AnimatedFormField(
          delay: const Duration(milliseconds: 950),
          child: TextButton(
            onPressed: () {
              // Handle forgot password
            },
            child: Text(AppStrings.forgotPassword, style: AppTextStyles.subheader16Bold),
          ),
        ),

        const SizedBox(height: 16), // Reduced from 24

        // Register Link
        AnimatedFormField(
          delay: const Duration(milliseconds: 1000),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16), // Added bottom padding for safety
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  SlidePageRoute(
                    child: const SignupScreen(),
                    direction: AxisDirection.right,
                  ),
                );
              },
              child: RichText(
                text: TextSpan(
                  text: AppStrings.noAccount,
                  style: AppTextStyles.subheader16Regular.copyWith(
                    color: AppColors.textDarkest,
                  ),
                  children: [
                    TextSpan(text: AppStrings.registerLink, style: AppTextStyles.linkText),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginFormCubit, LoginFormState>(
      builder: (context, state) {
        return Column(
          children: [
            // Email Field
            AnimatedFormField(
              delay: const Duration(milliseconds: 400),
              child: CustomTextFormField(
                label: AppStrings.emailLabel,
                hintText: AppStrings.emailHint,
                initialValue: state.email.value,
                onChanged: (value) {
                  context.read<LoginFormCubit>().emailChanged(value);
                },
                errorText: state.email.displayError?.text,
              ),
            ),
            const SizedBox(height: 16),

            // Password Field
            AnimatedFormField(
              delay: const Duration(milliseconds: 600),
              child: CustomTextFormField(
                label: AppStrings.passwordLabel,
                hintText: AppStrings.passwordHint,
                obscureText: !state.isPasswordVisible,
                initialValue: state.password.value,
                onChanged: (value) {
                  context.read<LoginFormCubit>().passwordChanged(value);
                },
                errorText: state.password.displayError?.text,
                suffixIcon: IconButton(
                  icon: Icon(
                    state.isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColors.textLight,
                  ),
                  onPressed: () {
                    context.read<LoginFormCubit>().togglePasswordVisibility();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginFormCubit, LoginFormState>(
      builder: (context, formState) {
        return BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            return CustomButton(
              text: AppStrings.loginButton,
              isLoading: authState.status == AuthStatus.loading,
              onPressed: formState.isValid
                  ? () {
                      context.read<AuthCubit>().signIn(
                        formState.email.value,
                        formState.password.value,
                      );
                    }
                  : null,
            );
          },
        );
      },
    );
  }
}
