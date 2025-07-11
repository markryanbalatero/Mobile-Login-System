import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../features/auth/cubit/auth_cubit.dart';

class SignupSuccessOverlay extends StatefulWidget {
  final VoidCallback? onComplete;
  
  const SignupSuccessOverlay({
    super.key,
    this.onComplete,
  });

  @override
  State<SignupSuccessOverlay> createState() => _SignupSuccessOverlayState();
}

class _SignupSuccessOverlayState extends State<SignupSuccessOverlay>
    with TickerProviderStateMixin {
  late AnimationController _loadingController;
  late AnimationController _successController;
  late Animation<double> _loadingAnimation;
  late Animation<double> _successScaleAnimation;
  late Animation<double> _successOpacityAnimation;
  
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    
    _loadingController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    _successController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.linear,
    ));
    
    _successScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    ));
    
    _successOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.easeIn,
    ));
    
    _loadingController.repeat();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final authCubit = context.read<AuthCubit>();
        final currentState = authCubit.state;
        
        if (currentState.status == AuthStatus.signupSuccess && !_showSuccess) {
          debugPrint('🎉 SignupSuccessOverlay: Already in signupSuccess state, handling immediately');
          _handleSignupSuccess();
        }
      }
    });
  }

  void _handleSignupSuccess() async {
    if (_showSuccess) return;
    
    print('🎉 SignupSuccessOverlay: Transitioning to success state');
    
    _loadingController.stop();
    setState(() {
      _showSuccess = true;
    });
    
    _successController.forward();
    
    await Future.delayed(const Duration(milliseconds: 2000));
    
    if (mounted) {
      widget.onComplete?.call();
    }
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        return current.status == AuthStatus.signupSuccess && !_showSuccess;
      },
      listener: (context, state) {
        if (state.status == AuthStatus.signupSuccess) {
          _handleSignupSuccess();
        }
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.background.withOpacity(0.95),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: !_showSuccess
                    ? _buildLoadingAnimation()
                    : _buildSuccessIcon(),
              ),
              
              const SizedBox(height: 24),
              
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: !_showSuccess
                    ? Text(
                        'Creating your account...',
                        key: const ValueKey('loading'),
                        style: AppTextStyles.heading20Bold,
                        textAlign: TextAlign.center,
                      )
                    : FadeTransition(
                        opacity: _successOpacityAnimation,
                        child: Column(
                          key: const ValueKey('success'),
                          children: [
                            Text(
                              AppStrings.accountCreatedSuccess,
                              style: AppTextStyles.heading20Bold.copyWith(
                                color: AppColors.success,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Redirecting to login...',
                              style: AppTextStyles.subheader16Regular,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingAnimation() {
    return Stack(
      alignment: Alignment.center,
      children: [
        RotationTransition(
          turns: _loadingAnimation,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryButton.withOpacity(0.3),
                width: 3,
              ),
            ),
            child: CustomPaint(
              painter: LoadingCirclePainter(
                color: AppColors.primaryButton,
                strokeWidth: 3,
              ),
            ),
          ),
        ),
        
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: AppColors.primaryButton,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_add,
            color: AppColors.white,
            size: 30,
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessIcon() {
    return ScaleTransition(
      scale: _successScaleAnimation,
      child: Container(
        width: 120,
        height: 120,
        decoration: const BoxDecoration(
          color: AppColors.success,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check,
          color: AppColors.white,
          size: 60,
        ),
      ),
    );
  }
}

class LoadingCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  LoadingCirclePainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      3.14159 / 2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
} 