import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Card de ponto de encontro do Petto.
///
/// Componente reutilizável usado na tela de exploração (mapa)
/// e nos detalhes do ponto de encontro.
class MeetingPointCard extends StatelessWidget {
  const MeetingPointCard({
    super.key,
    required this.title,
    required this.address,
    this.onTap,
  });

  /// Nome do ponto de encontro.
  final String title;

  /// Endereço do ponto de encontro.
  final String address;

  /// Callback executado ao toque no card.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // TODO: implementar o layout do card de ponto de encontro.
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.primaryLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'MeetingPointCard',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
