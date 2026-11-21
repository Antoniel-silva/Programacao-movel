import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Card de walker do Petto.
///
/// Componente reutilizável usado na listagem e nos detalhes dos walkers.
class WalkerCard extends StatelessWidget {
  const WalkerCard({
    super.key,
    required this.name,
    this.subtitle,
    this.rating = 0,
    this.imageUrl,
    this.onTap,
  });

  /// Nome do walker.
  final String name;

  /// Texto complementar (ex.: distância, especialidade).
  final String? subtitle;

  /// Nota de avaliação do walker.
  final double rating;

  /// URL da foto do walker.
  final String? imageUrl;

  /// Callback executado ao toque no card.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // TODO: implementar o layout do card de walker.
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.primaryLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'WalkerCard',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
