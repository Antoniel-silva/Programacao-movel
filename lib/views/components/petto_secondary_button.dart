import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Botão secundário (contorno) do Petto.
///
/// Componente reutilizável usado em ações secundárias das telas
/// (cancelar, voltar, alternar tela, etc.).
class PettoSecondaryButton extends StatelessWidget {
  const PettoSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  /// Texto exibido no botão.
  final String label;

  /// Callback executado ao toque no botão.
  final VoidCallback? onPressed;

  /// Ícone exibido antes do texto.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    // TODO: implementar o estilo e o comportamento do botão secundário.
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'PettoSecondaryButton',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
