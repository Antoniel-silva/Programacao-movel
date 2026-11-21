import 'package:flutter/material.dart';

import '../../models/place_category.dart';

/// Ícones usados para representar cada categoria no mapa.
abstract class PlaceIconHelper {
  PlaceIconHelper._();

  /// Retorna o ícone da categoria informada.
  static IconData of(PlaceCategory category) {
    return switch (category) {
      PlaceCategory.park => Icons.park,
      PlaceCategory.petStore => Icons.storefront,
      PlaceCategory.veterinary => Icons.medical_services,
      PlaceCategory.cafe => Icons.local_cafe,
      PlaceCategory.restaurant => Icons.restaurant,
      PlaceCategory.hotel => Icons.hotel,
      PlaceCategory.other => Icons.place,
    };
  }
}
