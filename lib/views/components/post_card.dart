import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Card de post do Petto.
///
/// Componente reutilizável usado no feed e na criação de posts.
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.authorName,
    required this.content,
    this.authorImageUrl,
    this.imageUrl,
    this.onTap,
  });

  /// Nome do autor do post.
  final String authorName;

  /// Conteúdo do post.
  final String content;

  /// URL da foto do autor.
  final String? authorImageUrl;

  /// URL da imagem do post.
  final String? imageUrl;

  /// Callback executado ao toque no card.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // TODO: implementar o layout do card de post.
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.primaryLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('PostCard', style: TextStyle(color: AppColors.textSecondary)),
    );
  }
}
