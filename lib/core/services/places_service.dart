import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../models/pet_place.dart';
import '../../../models/place_category.dart';
import '../../../models/place_filter.dart';
import '../constants/app_env.dart';

/// Erro lançado quando a busca de locais falha.
class PlacesException implements Exception {
  const PlacesException(this.message);

  /// Mensagem de erro exibida ao usuário.
  final String message;

  @override
  String toString() => message;
}

/// Serviço de busca de locais usando a API do Google Places (v1).
///
/// Requer a `GOOGLE_API_KEY` configurada no arquivo `.env`
/// com a Places API (New) habilitada.
class PlacesService {
  PlacesService({http.Client? client, this.apiKey})
    : _client = client ?? http.Client();

  static const _baseUrl = 'https://places.googleapis.com/v1';
  static const _languageCode = 'pt-BR';

  static const _searchFieldMask =
      'places.id,places.displayName,places.formattedAddress,places.location,'
      'places.rating,places.userRatingCount,places.types,places.primaryType';

  static const _detailsFieldMask =
      'id,displayName,formattedAddress,location,rating,userRatingCount,types,'
      'primaryType,formattedPhoneNumber,websiteUri,currentOpeningHours,'
      'googleMapsUri';

  final http.Client _client;

  /// Chave usada nas chamadas. Quando informada, substitui a do `.env`
  /// (usado nos testes).
  final String? apiKey;

  String get _resolvedKey =>
      apiKey ?? (AppEnv.isLoaded ? AppEnv.googleApiKey : '');

  /// Busca locais próximos a uma coordenada.
  Future<List<PetPlace>> searchNearby({
    required double latitude,
    required double longitude,
    required PlaceFilter filter,
  }) async {
    final body = <String, dynamic>{
      'languageCode': _languageCode,
      'maxResultCount': 20,
      'includedTypes': filter.category == null
          ? PlaceCategory.allSearchTypes
          : <String>[filter.category!.googleType],
      'locationRestriction': <String, dynamic>{
        'circle': <String, dynamic>{
          'center': <String, dynamic>{
            'latitude': latitude,
            'longitude': longitude,
          },
          'radius': filter.radiusMeters,
        },
      },
    };

    final places = await _post(
      path: 'places:searchNearby',
      body: body,
      fieldMask: _searchFieldMask,
    );
    return places;
  }

  /// Busca locais por texto, priorizando a região da coordenada informada.
  Future<List<PetPlace>> searchText({
    required String query,
    required double latitude,
    required double longitude,
    required double radius,
  }) async {
    final body = <String, dynamic>{
      'languageCode': _languageCode,
      'textQuery': query,
      'maxResultCount': 20,
      'locationBias': <String, dynamic>{
        'circle': <String, dynamic>{
          'center': <String, dynamic>{
            'latitude': latitude,
            'longitude': longitude,
          },
          'radius': radius,
        },
      },
    };

    return _post(
      path: 'places:searchText',
      body: body,
      fieldMask: _searchFieldMask,
    );
  }

  /// Busca os detalhes completos de um local pelo place id.
  Future<PetPlace> getDetails(String placeId) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/places/$placeId?languageCode=$_languageCode'),
      headers: <String, String>{
        'X-Goog-Api-Key': _resolvedKey,
        'X-Goog-FieldMask': _detailsFieldMask,
      },
    );

    if (response.statusCode != 200) {
      throw PlacesException(_messageFrom(response));
    }

    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) {
      throw PlacesException('Resposta inválida do Google Places.');
    }
    return PetPlace.fromPlacesApi(body);
  }

  Future<List<PetPlace>> _post({
    required String path,
    required Map<String, dynamic> body,
    required String fieldMask,
  }) async {
    if (_resolvedKey.isEmpty) {
      throw const PlacesException(
        'GOOGLE_API_KEY não configurada. Preencha o arquivo .env.',
      );
    }

    final response = await _client.post(
      Uri.parse('$_baseUrl/$path'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': _resolvedKey,
        'X-Goog-FieldMask': fieldMask,
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw PlacesException(_messageFrom(response));
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) return const <PetPlace>[];

    final places = decoded['places'];
    if (places is! List) return const <PetPlace>[];

    return places
        .whereType<Map<String, dynamic>>()
        .map(PetPlace.fromPlacesApi)
        .toList();
  }

  /// Extrai a mensagem de erro retornada pela API do Google.
  String _messageFrom(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic>) {
        final error = body['error'];
        if (error is Map && error['message'] is String) {
          return error['message'] as String;
        }
      }
    } catch (_) {
      // Resposta sem corpo interpretável: usa a mensagem padrão.
    }
    return 'Falha na busca de locais (HTTP ${response.statusCode}).';
  }
}
