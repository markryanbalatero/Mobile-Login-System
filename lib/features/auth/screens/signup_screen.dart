import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/models/name.dart';
import '../../../core/models/email.dart';
import '../../../core/models/password.dart';
import '../../../shared/widgets/custom_text_form_field.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/signup_success_overlay.dart';
import '../../../shared/animations/slide_page_route.dart';
import '../../../shared/animations/animated_form_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/signup_form_cubit.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.headerBackground,
      resizeToAvoidBottomInset: true,
      body: MultiBlocProvider(
        providers: [BlocProvider(create: (_) => SignupFormCubit())],
        child: const SignupView(),
      ),
    );
  }
}

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        print('📝 SignupView: listenWhen - previous: ${previous.status}, current: ${current.status}');
        return current.status == AuthStatus.error;
      },
      listener: (context, state) {
        print('📝 SignupView: Listener triggered with state: ${state.status}');
        
        if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? AppStrings.errorOccurred),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      buildWhen: (previous, current) {
        if (current.status == AuthStatus.unauthenticated) {
          print('📝 SignupView: buildWhen - skipping rebuild for unauthenticated state (should show LoginScreen)');
          return false;
        }
        
        return true;
      },
      builder: (context, state) {
        print('📝 SignupView: Builder called with state: ${state.status}');
        
        if (state.status == AuthStatus.loading || state.status == AuthStatus.signupSuccess) {
          return SignupSuccessOverlay(
            onComplete: () {
              print('🎉 SignupView: Success overlay completed, completing signup flow');
              context.read<AuthCubit>().completeSignupFlow();
            },
          );
        }
        
        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.headerBackground,
                          ),
                          child: Opacity(
                            opacity: 0.7,
                            child: Image.asset(
                              'assets/images/bg.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      Column(
                        children: [
                          const HeaderSection(),
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
                                padding: EdgeInsets.fromLTRB(22, 24, 22, 24),
                                child: SignupFormSection(),
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
        );
      },
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final totalHeight = 260 + statusBarHeight;

    return SizedBox(
      height: totalHeight,
      width: double.infinity,
      child: Stack(
        children: [
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

class SignupFormSection extends StatelessWidget {
  const SignupFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedFormField(
          delay: const Duration(milliseconds: 200),
          child: Column(
            children: [
              Text(
                'Join VibeHub!',
                style: AppTextStyles.heading28Bold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Create your account to get started',
                style: AppTextStyles.subheader16Regular,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        const SignupForm(),

        const SizedBox(height: 20),

        AnimatedFormField(
          delay: const Duration(milliseconds: 1000),
          child: const SignupButton(),
        ),

        const Spacer(),

        AnimatedFormField(
          delay: const Duration(milliseconds: 1100),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                SlidePageRoute(
                  child: const LoginScreen(),
                  direction: AxisDirection.left,
                ),
              );
            },
            child: RichText(
              text: TextSpan(
                text: "Already have an account? ",
                style: AppTextStyles.subheader16Regular.copyWith(
                  color: AppColors.textDarkest,
                ),
                children: [
                  TextSpan(text: 'Log In', style: AppTextStyles.linkText),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupFormCubit, SignupFormState>(
      builder: (context, state) {
        return Column(
          children: [
            AnimatedFormField(
              delay: const Duration(milliseconds: 400),
              child: CustomTextFormField(
                label: 'Full name',
                hintText: 'Full name',
                initialValue: state.name.value,
                onChanged: (value) {
                  context.read<SignupFormCubit>().nameChanged(value);
                },
                errorText: state.name.displayError?.text,
              ),
            ),
            const SizedBox(height: 16),

            AnimatedFormField(
              delay: const Duration(milliseconds: 600),
              child: CustomTextFormField(
                label: 'Email',
                hintText: 'Email',
                initialValue: state.email.value,
                onChanged: (value) {
                  context.read<SignupFormCubit>().emailChanged(value);
                },
                errorText: state.email.displayError?.text,
              ),
            ),
            const SizedBox(height: 16),

            AnimatedFormField(
              delay: const Duration(milliseconds: 800),
              child: CustomTextFormField(
                label: 'Password',
                hintText: 'Password',
                obscureText: !state.isPasswordVisible,
                initialValue: state.password.value,
                onChanged: (value) {
                  context.read<SignupFormCubit>().passwordChanged(value);
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
                    context.read<SignupFormCubit>().togglePasswordVisibility();
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

class SignupButton extends StatelessWidget {
  const SignupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupFormCubit, SignupFormState>(
      builder: (context, formState) {
        return BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            final isProcessing = authState.status == AuthStatus.loading || 
                                authState.status == AuthStatus.signupSuccess;
            
            return CustomButton(
              text: 'Get Started',
              isLoading: false,
              onPressed: formState.isValid && !isProcessing
                  ? () {
                      context.read<AuthCubit>().signUp(
                        formState.email.value,
                        formState.password.value,
                        formState.name.value,
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
