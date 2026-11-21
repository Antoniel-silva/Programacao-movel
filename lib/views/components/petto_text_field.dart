import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Campo de texto padrão do Petto.
///
/// Componente reutilizável usado nos formulários das telas
/// (login, cadastro, perfil, pet, post, etc.).
class PettoTextField extends StatelessWidget {
  const PettoTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.onChanged,
    this.maxLines = 1,
    this.textInputAction,
  });

  /// Rótulo exibido acima do campo.
  final String? label;

  /// Texto de sugestão exibido dentro do campo.
  final String? hint;

  /// Controlador do campo de texto.
  final TextEditingController? controller;

  /// Oculta o texto digitado (senhas).
  final bool obscureText;

  /// Tipo de teclado exibido.
  final TextInputType? keyboardType;

  /// Função de validação do campo.
  final FormFieldValidator<String>? validator;

  /// Ícone exibido no início do campo.
  final IconData? prefixIcon;

  /// Callback executado a cada alteração do texto.
  final ValueChanged<String>? onChanged;

  /// Quantidade de linhas exibidas no campo.
  final int maxLines;

  /// Ação exibida no teclado.
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          maxLines: obscureText ? 1 : maxLines,
          textInputAction:
              textInputAction ??
              (maxLines > 1 ? TextInputAction.newline : TextInputAction.next),
          cursorColor: AppColors.primary,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.textSecondary)
                : null,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
