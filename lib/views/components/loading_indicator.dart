import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Indicador de carregamento do Petto.
///
/// Componente reutilizável usado nas telas que aguardam
/// dados ou processamento.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.message});

  /// Mensagem exibida junto ao indicador.
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}
