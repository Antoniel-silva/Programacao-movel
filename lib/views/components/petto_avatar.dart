import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Avatar padrão do Petto.
///
/// Componente reutilizável usado para exibir fotos de usuários,
/// pets, walkers e produtos, com fallback para iniciais.
class PettoAvatar extends StatelessWidget {
  const PettoAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.radius = 24,
  });

  /// URL da imagem exibida no avatar.
  final String? imageUrl;

  /// Iniciais exibidas quando não há imagem.
  final String? initials;

  /// Raio do avatar.
  final double radius;

  @override
  Widget build(BuildContext context) {
    // TODO: implementar a exibição da imagem com fallback de iniciais.
    return Container(
      alignment: Alignment.center,
      width: radius * 2,
      height: radius * 2,
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        shape: BoxShape.circle,
      ),
      child: Text(
        'PettoAvatar',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
