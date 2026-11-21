import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Campo de busca padrão do Petto.
///
/// Componente reutilizável usado nas telas de listagem
/// (pets, feed, explore, pet shop, walkers, etc.).
class PettoSearchField extends StatelessWidget {
  const PettoSearchField({
    super.key,
    this.hint = 'Buscar',
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.borderRadius = 12,
  });

  /// Texto de sugestão exibido dentro do campo.
  final String hint;

  /// Controlador do campo de busca.
  final TextEditingController? controller;

  /// Callback executado a cada alteração do texto.
  final ValueChanged<String>? onChanged;

  /// Callback executado ao confirmar a busca (teclado).
  final ValueChanged<String>? onSubmitted;

  /// Raio de borda do campo.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      cursorColor: AppColors.primary,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: AppColors.primaryLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: AppColors.primaryLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
