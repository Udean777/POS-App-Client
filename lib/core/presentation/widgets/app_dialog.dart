import 'package:flutter/material.dart';
import 'package:client/core/presentation/widgets/app_button.dart';
import 'package:client/src/theme/app_theme.dart';

class AppDialog extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const AppDialog({
    super.key,
    required this.child,
    this.borderRadius = 28.0,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      elevation: 0,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}

class AppDialogs {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: '',
      barrierColor: AppColors.shadow.withValues(alpha: 0.4),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => child,
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  static Future<bool?> showConfirm({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = "Confirm",
    String cancelText = "Batal",
    bool isDanger = false,
  }) {
    return show<bool>(
      context: context,
      child: AppDialog(
        padding: const EdgeInsets.all(24),
        child: Builder(
          builder: (dialogContext) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDanger ? Icons.warning_amber_rounded : Icons.info_outline,
                size: 48,
                color: isDanger ? AppColors.danger : AppColors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(dialogContext).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: AppTextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      text: cancelText,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      variant: isDanger
                          ? AppButtonVariant.danger
                          : AppButtonVariant.primary,
                      onPressed: () => Navigator.pop(dialogContext, true),
                      text: confirmText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = "Tutup",
  }) {
    return show<void>(
      context: context,
      child: AppDialog(
        padding: const EdgeInsets.all(24),
        child: Builder(
          builder: (dialogContext) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                size: 64,
                color: AppColors.success,
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: Theme.of(dialogContext).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              AppButton(
                onPressed: () => Navigator.pop(dialogContext),
                text: buttonText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
