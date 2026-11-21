import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Título de seção do Petto.
///
/// Componente reutilizável usado para separar blocos de conteúdo
/// nas telas (ex.: "Meus pets", "Populares", "Recentes").
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  /// Texto do título da seção.
  final String title;

  /// Rótulo da ação exibida à direita (opcional).
  final String? actionLabel;

  /// Callback executado ao toque na ação.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    // TODO: implementar o layout do título de seção.
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.primaryLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'SectionTitle',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
