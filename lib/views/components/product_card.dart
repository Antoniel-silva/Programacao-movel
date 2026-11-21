import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Card de produto do Petto.
///
/// Componente reutilizável usado na Pet Shop e no carrinho.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    this.imageUrl,
    this.onTap,
  });

  /// Nome do produto.
  final String name;

  /// Preço formatado exibido no card.
  final String price;

  /// URL da imagem do produto.
  final String? imageUrl;

  /// Callback executado ao toque no card.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // TODO: implementar o layout do card de produto.
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.primaryLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'ProductCard',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
