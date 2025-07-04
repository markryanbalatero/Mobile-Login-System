import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../features/auth/cubit/auth_cubit.dart';
import '../../shared/widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('VibeHub', style: AppTextStyles.heading28Bold),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textDarkest),
            onPressed: () {
              context.read<AuthCubit>().signOut();
            },
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
              child: const Icon(Icons.check, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 32),
            Text(
              'Welcome to VibeHub!',
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
              'You have successfully logged in to your account.',
              style: AppTextStyles.subheader16Regular,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            CustomButton(
              text: 'Logout',
              onPressed: () {
                context.read<AuthCubit>().signOut();
              },
              backgroundColor: AppColors.textLight,
              textColor: AppColors.textWhite,
            ),
          ],
        ),
      ),
    );
  }
}
