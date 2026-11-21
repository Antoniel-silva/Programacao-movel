import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Estado vazio do Petto.
///
/// Componente reutilizável usado quando uma lista ou tela
/// não possui dados para exibir (sem pets, sem posts, carrinho vazio, etc.).
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.pets,
    this.actionLabel,
    this.onAction,
  });

  /// Título exibido no estado vazio.
  final String title;

  /// Mensagem complementar.
  final String? message;

  /// Ícone exibido acima do título.
  final IconData icon;

  /// Rótulo do botão de ação (opcional).
  final String? actionLabel;

  /// Callback executado ao toque na ação.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: AppColors.primary),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.textPrimary),
          ),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
