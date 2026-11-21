import 'place_category.dart';

/// Local pet friendly encontrado no Google Places.
class PetPlace {
  const PetPlace({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.category = PlaceCategory.other,
    this.rating,
    this.reviewCount,
    this.phoneNumber,
    this.website,
    this.openingHours = const <String>[],
    this.googleMapsUri,
  });

  /// Identificador do local (place id do Google Places).
  final String id;

  /// Nome do local.
  final String name;

  /// Endereço do local.
  final String address;

  /// Latitude do local.
  final double latitude;

  /// Longitude do local.
  final double longitude;

  /// Categoria do local.
  final PlaceCategory category;

  /// Avaliação média (0 a 5).
  final double? rating;

  /// Quantidade de avaliações.
  final int? reviewCount;

  /// Telefone do local.
  final String? phoneNumber;

  /// Site do local.
  final String? website;

  /// Horários de funcionamento (um texto por dia da semana).
  final List<String> openingHours;

  /// Link do local no Google Maps.
  final String? googleMapsUri;

  /// Cria um [PetPlace] a partir de uma resposta da API do Google Places (v1).
  ///
  /// O parsing é tolerante: campos ausentes ou com formato inesperado
  /// não interrompem a leitura.
  factory PetPlace.fromPlacesApi(Map<String, dynamic> json) {
    final location = json['location'];
    final displayName = json['displayName'];
    final types = <String>[
      if (json['primaryType'] is String) json['primaryType'] as String,
      if (json['types'] is List) ...(json['types'] as List).whereType<String>(),
    ];

    return PetPlace(
      id: json['id'] is String ? json['id'] as String : '',
      name: displayName is Map && displayName['text'] is String
          ? displayName['text'] as String
          : 'Local sem nome',
      address: json['formattedAddress'] is String
          ? json['formattedAddress'] as String
          : 'Endereço não informado',
      latitude: location is Map && location['latitude'] is num
          ? (location['latitude'] as num).toDouble()
          : 0,
      longitude: location is Map && location['longitude'] is num
          ? (location['longitude'] as num).toDouble()
          : 0,
      category: PlaceCategory.fromTypes(types),
      rating: json['rating'] is num ? (json['rating'] as num).toDouble() : null,
      reviewCount: json['userRatingCount'] is int
          ? json['userRatingCount'] as int
          : null,
      phoneNumber: json['formattedPhoneNumber'] is String
          ? json['formattedPhoneNumber'] as String
          : null,
      website: json['websiteUri'] is String
          ? json['websiteUri'] as String
          : null,
      openingHours: _openingHoursFrom(json),
      googleMapsUri: json['googleMapsUri'] is String
          ? json['googleMapsUri'] as String
          : null,
    );
  }

  static List<String> _openingHoursFrom(Map<String, dynamic> json) {
    final currentOpeningHours = json['currentOpeningHours'];
    if (currentOpeningHours is Map &&
        currentOpeningHours['weekdayDescriptions'] is List) {
      return (currentOpeningHours['weekdayDescriptions'] as List)
          .whereType<String>()
          .toList();
    }
    return const <String>[];
  }
}
