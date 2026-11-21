import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Estrelas de avaliação do Petto.
///
/// Componente reutilizável usado para exibir a nota de walkers,
/// produtos e pontos de encontro.
class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.maxStars = 5,
    this.size = 16,
  });

  /// Nota exibida (de 0 até [maxStars]).
  final double rating;

  /// Quantidade máxima de estrelas.
  final int maxStars;

  /// Tamanho de cada estrela.
  final double size;

  @override
  Widget build(BuildContext context) {
    // TODO: implementar a exibição das estrelas de avaliação.
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.primaryLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'RatingStars',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
