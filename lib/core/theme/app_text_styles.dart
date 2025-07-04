import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Heading styles
  static TextStyle heading28Bold = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColors.textDarkest,
  );

  // Subheader styles
  static TextStyle subheader16Regular = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textLight,
  );

  static TextStyle subheader16White = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textWhite,
  );

  static TextStyle subheader16Bold = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.6,
    color: AppColors.textDarkest,
  );

  // Paragraph styles
  static TextStyle paragraph14Bold = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.6,
    color: AppColors.textDarkest,
  );

  // Input field styles
  static TextStyle inputText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textDarkest,
  );

  // Button text styles
  static TextStyle buttonText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textWhite,
  );

  // Link text styles
  static TextStyle linkText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.6,
    color: AppColors.primaryRegister,
  );
}
