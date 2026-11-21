import 'place_category.dart';

/// Filtro aplicado na busca de locais próximos.
class PlaceFilter {
  const PlaceFilter({this.category, this.radiusMeters = 2000});

  /// Categoria selecionada (null = todas as categorias).
  final PlaceCategory? category;

  /// Raio da busca em metros.
  final double radiusMeters;
}
