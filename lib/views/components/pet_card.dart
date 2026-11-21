import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Card de pet do Petto.
///
/// Componente reutilizável usado na listagem de pets
/// e nas seções da HomeScreen.
class PetCard extends StatelessWidget {
  const PetCard({
    super.key,
    required this.name,
    this.subtitle,
    this.imageUrl,
    this.onTap,
  });

  /// Nome do pet.
  final String name;

  /// Texto complementar (raça, idade, etc.).
  final String? subtitle;

  /// URL da foto do pet.
  final String? imageUrl;

  /// Callback executado ao toque no card.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // TODO: implementar o layout do card de pet.
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.primaryLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('PetCard', style: TextStyle(color: AppColors.textSecondary)),
    );
  }
}
