import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../features/auth/cubit/auth_cubit.dart';
import '../../shared/widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        print('🏠 HomeScreen: Auth state changed to: ${state.status}');
        
        if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? AppStrings.errorOccurred),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(AppStrings.appName, style: AppTextStyles.heading28Bold),
          backgroundColor: AppColors.background,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: AppColors.textDarkest),
              onPressed: () => _showLogoutDialog(context),
            ),
          ],
        ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: AppColors.primaryButton,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 60, color: AppColors.white),
            ),
            const SizedBox(height: 32),
            Text(
              AppStrings.welcomeToVibeHub,
              style: AppTextStyles.heading28Bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return Text(
                  'Hello, ${state.user ?? 'User'}!',
                  style: AppTextStyles.subheader16Regular,
                  textAlign: TextAlign.center,
                );
              },
            ),
            const SizedBox(height: 32),
            Text(
              AppStrings.youreLoggedIn,
              style: AppTextStyles.subheader16Regular,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return CustomButton(
                  text: AppStrings.logoutButton,
                  isLoading: state.status == AuthStatus.loading,
                  onPressed: state.status == AuthStatus.loading 
                      ? null 
                      : () => _showLogoutDialog(context),
                  backgroundColor: AppColors.textLight,
                  textColor: AppColors.textWhite,
                );
              },
            ),
          ],
        ),
      ),
    ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            AppStrings.logoutConfirmTitle,
            style: AppTextStyles.heading28Bold,
          ),
          content: Text(
            AppStrings.logoutConfirmMessage,
            style: AppTextStyles.subheader16Regular,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppStrings.cancelButton,
                style: AppTextStyles.subheader16Bold.copyWith(
                  color: AppColors.textLight,
                ),
              ),
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return CustomButton(
                  text: AppStrings.logoutButton,
                  isLoading: state.status == AuthStatus.loading,
                  onPressed: state.status == AuthStatus.loading ? null : () {
                    Navigator.of(context).pop();
                    context.read<AuthCubit>().signOut();
                  },
                  backgroundColor: AppColors.error,
                  textColor: AppColors.white,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
