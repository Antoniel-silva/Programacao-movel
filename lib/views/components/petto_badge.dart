import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Badge de contagem do Petto.
///
/// Componente reutilizável usado para exibir contadores
/// (notificações, itens no carrinho, etc.).
class PettoBadge extends StatelessWidget {
  const PettoBadge({super.key, required this.count, this.child});

  /// Valor exibido no badge.
  final int count;

  /// Widget envolvido pelo badge.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    // TODO: implementar a exibição do contador sobre o widget filho.
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.primaryLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'PettoBadge',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
