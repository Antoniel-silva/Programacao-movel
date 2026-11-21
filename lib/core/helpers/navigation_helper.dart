import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

/// Auxilia na navegação entre as telas principais (barra inferior).
abstract class NavigationHelper {
  NavigationHelper._();

  /// Navega para a aba principal informada.
  ///
  /// Índices: 0 Início · 1 Explorar · 2 Publicar · 3 Loja · 4 Perfil.
  /// [currentIndex] evita recarregar a aba que já está aberta.
  static void goToMainTab(BuildContext context, int index, int currentIndex) {
    switch (index) {
      case 0:
        _goToRoot(context, AppRoutes.home, currentIndex == 0);
      case 1:
        _goToRoot(context, AppRoutes.exploreMap, currentIndex == 1);
      case 2:
        // Publicar é uma ação: abre a tela sobre a aba atual.
        Navigator.pushNamed(context, AppRoutes.createPost);
      case 3:
        _goToRoot(context, AppRoutes.petShop, currentIndex == 3);
      case 4:
        _goToRoot(context, AppRoutes.profile, currentIndex == 4);
    }
  }

  static void _goToRoot(BuildContext context, String route, bool alreadyThere) {
    if (alreadyThere) return;
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }
}
