/// Categorias de locais pet friendly exibidos no mapa.
enum PlaceCategory {
  park('Parques', 'park'),
  petStore('Pet Shops', 'pet_store'),
  veterinary('Veterinários', 'veterinary_care'),
  cafe('Cafés', 'cafe'),
  restaurant('Restaurantes', 'restaurant'),
  hotel('Hotéis', 'lodging'),
  other('Outros', 'point_of_interest');

  const PlaceCategory(this.label, this.googleType);

  /// Nome exibido nos filtros da tela de exploração.
  final String label;

  /// Tipo usado na busca do Google Places.
  final String googleType;

  /// Tipos usados na busca quando nenhuma categoria é selecionada.
  static List<String> get allSearchTypes => <String>[
    for (final category in values)
      if (category != PlaceCategory.other) category.googleType,
  ];

  /// Retorna a categoria a partir dos tipos informados pelo Google.
  static PlaceCategory fromTypes(List<String> types) {
    for (final category in values) {
      if (types.contains(category.googleType)) {
        return category;
      }
    }
    return PlaceCategory.other;
  }
}
