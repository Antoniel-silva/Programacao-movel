import 'package:flutter/material.dart';

/// Cores básicas do Petto.
///
/// Nenhuma cor deve ser declarada diretamente nas telas:
/// sempre referenciar as constantes definidas aqui.
abstract class AppColors {
  /// Cor principal do aplicativo (vermelho alaranjado escuro).
  static const Color primary = Color(0xFFC1440E);

  /// Versão escura da cor principal.
  static const Color primaryDark = Color(0xFF8F330D);

  /// Versão clara da cor principal.
  static const Color primaryLight = Color(0xFFE8734A);

  /// Cor secundária (destaques e ações).
  static const Color secondary = Color(0xFFF4A261);

  /// Cor de fundo padrão das telas.
  static const Color background = Color(0xFFFBF5F2);

  /// Cor de superfície (cards e superfícies elevadas).
  static const Color surface = Color(0xFFFFFFFF);

  /// Cor do texto principal.
  static const Color textPrimary = Color(0xFF2B1A12);

  /// Cor do texto secundário.
  static const Color textSecondary = Color(0xFF8A6A5C);

  /// Cor de erro.
  static const Color error = Color(0xFFB3261E);

  /// Branco puro.
  static const Color white = Color(0xFFFFFFFF);

  /// Preto puro.
  static const Color black = Color(0xFF000000);
}
