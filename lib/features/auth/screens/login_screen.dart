import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/models/email.dart';
import '../../../core/models/password.dart';
import '../../../shared/widgets/custom_text_form_field.dart';
import '../../../shared/widgets/custom_button.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/login_form_cubit.dart';

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
              content: Text(state.errorMessage ?? 'An error occurred'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state.status == AuthStatus.authenticated) {
          // Navigate to home screen or show success
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
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
                          child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
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
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, -5),
                                ),
                              ],
                            ),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(22, 24, 22, 24),
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
    final totalHeight = 280 + statusBarHeight; // Reduced from 310 to 280

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
            bottom: 43,
            child: Center(
              child: Image.asset(
                'assets/images/rocket.png',
                width: 250,
                height: 200,
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
                  'assets/icons/star.png',
                  width: 24,
                  height: 24,
                  color: Colors.white,
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
        Column(
          children: [
            Text(
              'Welcome back!',
              style: AppTextStyles.heading28Bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Login to continue with VibeHub',
              style: AppTextStyles.subheader16Regular,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Form Fields
        const LoginForm(),

        const SizedBox(height: 20),

        // Login Button
        const LoginButton(),

        const SizedBox(height: 16),

        // Forgot Password
        TextButton(
          onPressed: () {
            // Handle forgot password
          },
          child: Text('Forgot password?', style: AppTextStyles.subheader16Bold),
        ),

        const Spacer(),

        // Register Link
        RichText(
          text: TextSpan(
            text: "Don't have an account? ",
            style: AppTextStyles.subheader16Regular.copyWith(
              color: AppColors.textDarkest,
            ),
            children: [
              TextSpan(text: 'Register', style: AppTextStyles.linkText),
            ],
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
            CustomTextFormField(
              label: 'Email',
              hintText: 'stanleycohen@gmail.com',
              initialValue: state.email.value,
              onChanged: (value) {
                context.read<LoginFormCubit>().emailChanged(value);
              },
              errorText: state.email.displayError?.text,
            ),
            const SizedBox(height: 16),

            // Password Field
            CustomTextFormField(
              label: 'Password',
              hintText: '•••••••••',
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
              text: 'Log In',
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
