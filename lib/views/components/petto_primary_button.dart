import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Botão principal do Petto.
///
/// Componente reutilizável usado nas ações primárias das telas
/// (login, cadastro, salvar, comprar, etc.).
class PettoPrimaryButton extends StatelessWidget {
  const PettoPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
  });

  /// Texto exibido no botão.
  final String label;

  /// Callback executado ao toque no botão.
  final VoidCallback? onPressed;

  /// Indica se o botão está exibindo estado de carregamento.
  final bool isLoading;

  /// Ícone exibido antes do texto.
  final IconData? icon;

  /// Estica o botão para ocupar toda a largura disponível.
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        disabledBackgroundColor: AppColors.primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.white,
              ),
            )
          : Row(
              mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(label),
              ],
            ),
    );

    if (!fullWidth) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}
