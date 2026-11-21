import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Barra de navegação inferior do Petto.
///
/// Componente reutilizável usado nas telas principais para alternar
/// entre as seções do aplicativo, com botão central de publicação.
class PettoBottomNavBar extends StatelessWidget {
  const PettoBottomNavBar({super.key, required this.currentIndex, this.onTap});

  /// Índice da aba atualmente selecionada.
  final int currentIndex;

  /// Callback executado ao toque em uma aba.
  ///
  /// Índices: 0 Início · 1 Explorar · 2 Publicar · 3 Loja · 4 Perfil.
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.primaryLight)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _NavItem(
                index: 0,
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: 'Início',
                selected: currentIndex == 0,
                onTap: onTap,
              ),
              _NavItem(
                index: 1,
                icon: Icons.location_on_outlined,
                selectedIcon: Icons.location_on,
                label: 'Explorar',
                selected: currentIndex == 1,
                onTap: onTap,
              ),
              _PublishItem(selected: currentIndex == 2, onTap: onTap),
              _NavItem(
                index: 3,
                icon: Icons.shopping_bag_outlined,
                selectedIcon: Icons.shopping_bag,
                label: 'Loja',
                selected: currentIndex == 3,
                onTap: onTap,
              ),
              _NavItem(
                index: 4,
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                label: 'Perfil',
                selected: currentIndex == 4,
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.index,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final int index;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;

    return Expanded(
      child: InkWell(
        onTap: () => onTap?.call(index),
        child: SizedBox(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(selected ? selectedIcon : icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PublishItem extends StatelessWidget {
  const _PublishItem({required this.selected, required this.onTap});

  final bool selected;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap?.call(2),
        child: SizedBox(
          height: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: -24,
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                    border: Border.all(color: AppColors.surface, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.white,
                    size: 30,
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                child: Text(
                  'Publicar',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
