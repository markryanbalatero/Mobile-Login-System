import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.label,
    this.hintText,
    this.onChanged,
    this.obscureText = false,
    this.suffixIcon,
    this.errorText,
    this.initialValue,
  });

  final String label;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? errorText;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.paragraph14Bold),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: initialValue,
          obscureText: obscureText,
          onChanged: onChanged,
          style: AppTextStyles.inputText,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
            errorText: errorText,
          ),
        ),
      ],
    );
  }
}
