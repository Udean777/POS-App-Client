import 'package:client/core/presentation/widgets/app_button.dart';
import 'package:flutter/material.dart';

class TransactionErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const TransactionErrorView({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              color: colorScheme.error,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Gagal memuat riwayat",
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 24),
          AppButton(
            isFullWidth: false,
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 20),
            text: "Coba Lagi",
          ),
        ],
      ),
    );
  }
}
