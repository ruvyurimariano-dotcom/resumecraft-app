import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum ButtonVariant { primary, secondary, outline, danger, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height = 50,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == ButtonVariant.outline || variant == ButtonVariant.text
                    ? AppColors.primary
                    : Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ] else if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );

    final buttonStyle = switch (variant) {
      ButtonVariant.primary => ElevatedButton.styleFrom(
          backgroundColor: isDark ? AppColors.primaryLight : AppColors.primary,
          foregroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          minimumSize: Size(width ?? double.infinity, height),
          padding: padding,
        ),
      ButtonVariant.secondary => FilledButton.styleFrom(
          backgroundColor: isDark ? const Color(0xFF1E293B) : AppColors.primaryContainer,
          foregroundColor: isDark ? AppColors.primaryLight : AppColors.onPrimaryContainer,
          minimumSize: Size(width ?? double.infinity, height),
          padding: padding,
        ),
      ButtonVariant.outline => OutlinedButton.styleFrom(
          foregroundColor: isDark ? AppColors.primaryLight : AppColors.primary,
          side: BorderSide(
            color: isDark ? AppColors.outlineDark : AppColors.outlineLight,
            width: 1.2,
          ),
          minimumSize: Size(width ?? double.infinity, height),
          padding: padding,
        ),
      ButtonVariant.danger => ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: Colors.white,
          minimumSize: Size(width ?? double.infinity, height),
          padding: padding,
        ),
      ButtonVariant.text => TextButton.styleFrom(
          foregroundColor: isDark ? AppColors.primaryLight : AppColors.primary,
          minimumSize: Size(width ?? 0, height),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        ),
    };

    return SizedBox(
      width: width,
      height: height,
      child: variant == ButtonVariant.text
          ? TextButton(
              onPressed: isLoading ? null : onPressed,
              style: buttonStyle,
              child: content,
            )
          : variant == ButtonVariant.outline
              ? OutlinedButton(
                  onPressed: isLoading ? null : onPressed,
                  style: buttonStyle,
                  child: content,
                )
              : ElevatedButton(
                  onPressed: isLoading ? null : onPressed,
                  style: buttonStyle,
                  child: content,
                ),
    );
  }
}
