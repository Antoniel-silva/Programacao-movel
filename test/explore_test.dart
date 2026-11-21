import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:petto/core/services/places_service.dart';
import 'package:petto/models/meeting_point.dart';
import 'package:petto/models/pet_place.dart';
import 'package:petto/models/place_category.dart';
import 'package:petto/models/place_filter.dart';

void main() {
  group('PlaceCategory', () {
    test('identifica a categoria a partir dos tipos do Google', () {
      expect(PlaceCategory.fromTypes(<String>['park']), PlaceCategory.park);
      expect(
        PlaceCategory.fromTypes(<String>['pet_store', 'point_of_interest']),
        PlaceCategory.petStore,
      );
      expect(PlaceCategory.fromTypes(<String>['shop']), PlaceCategory.other);
    });

    test('tipos de busca excluem a categoria genérica', () {
      expect(
        PlaceCategory.allSearchTypes,
        isNot(contains('point_of_interest')),
      );
      expect(PlaceCategory.allSearchTypes, contains('park'));
    });
  });

  group('PetPlace.fromPlacesApi', () {
    test('faz o parse de uma resposta da API do Google Places', () {
      final place = PetPlace.fromPlacesApi(<String, dynamic>{
        'id': 'abc123',
        'displayName': <String, dynamic>{
          'text': 'Parque do Bairro',
          'languageCode': 'pt-BR',
        },
        'formattedAddress': 'Rua das Flores, 123 - São Paulo',
        'location': <String, dynamic>{'latitude': -23.55, 'longitude': -46.63},
        'rating': 4.7,
        'userRatingCount': 120,
        'types': <String>['park', 'point_of_interest'],
        'currentOpeningHours': <String, dynamic>{
          'weekdayDescriptions': <String>['domingo: 08:00–18:00'],
        },
      });

      expect(place.id, 'abc123');
      expect(place.name, 'Parque do Bairro');
      expect(place.address, 'Rua das Flores, 123 - São Paulo');
      expect(place.latitude, -23.55);
      expect(place.longitude, -46.63);
      expect(place.rating, 4.7);
      expect(place.reviewCount, 120);
      expect(place.category, PlaceCategory.park);
      expect(place.openingHours, hasLength(1));
    });

    test('tolera campos ausentes na resposta', () {
      final place = PetPlace.fromPlacesApi(<String, dynamic>{});

      expect(place.id, isEmpty);
      expect(place.name, 'Local sem nome');
      expect(place.category, PlaceCategory.other);
      expect(place.rating, isNull);
      expect(place.openingHours, isEmpty);
    });
  });

  group('MeetingPoint', () {
    test('faz o roundtrip para JSON', () {
      final point = MeetingPoint(
        id: '1',
        name: 'Praça do Bairro',
        description: 'Espaço pet friendly',
        address: 'Rua das Flores, 123',
        latitude: -23.55,
        longitude: -46.63,
        createdAt: DateTime(2026, 11, 20, 10, 30),
      );

      final restored = MeetingPoint.fromJson(point.toJson());

      expect(restored.id, point.id);
      expect(restored.name, point.name);
      expect(restored.description, point.description);
      expect(restored.address, point.address);
      expect(restored.latitude, point.latitude);
      expect(restored.longitude, point.longitude);
      expect(restored.createdAt, point.createdAt);
    });
  });

  group('PlacesService', () {
    test('busca locais próximos e faz o parse da resposta', () async {
      final client = MockClient((request) async {
        expect(request.url.toString(), contains('places:searchNearby'));
        expect(request.headers['X-Goog-Api-Key'], 'chave-teste');

        return http.Response(
          '{"places": [{"id": "p1", '
          '"displayName": {"text": "Pet Shop Amigo"}, '
          '"formattedAddress": "Av. Central, 10", '
          '"location": {"latitude": -23.5, "longitude": -46.6}, '
          '"types": ["pet_store"]}]}',
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = PlacesService(client: client, apiKey: 'chave-teste');
      final results = await service.searchNearby(
        latitude: -23.55,
        longitude: -46.63,
        filter: const PlaceFilter(),
      );

      expect(results, hasLength(1));
      expect(results.first.name, 'Pet Shop Amigo');
      expect(results.first.category, PlaceCategory.petStore);
    });

    test('lança PlacesException quando a chave não está configurada', () async {
      final service = PlacesService(
        client: MockClient((_) async => http.Response('', 200)),
        apiKey: '',
      );

      expect(
        () => service.searchNearby(
          latitude: 0,
          longitude: 0,
          filter: const PlaceFilter(),
        ),
        throwsA(isA<PlacesException>()),
      );
    });

    test('lança PlacesException quando a API retorna erro', () async {
      final client = MockClient(
        (_) async => http.Response(
          '{"error": {"message": "API key not valid"}}',
          403,
          headers: {'content-type': 'application/json'},
        ),
      );

      final service = PlacesService(client: client, apiKey: 'chave-teste');

      expect(
        () => service.searchText(
          query: 'pet friendly',
          latitude: 0,
          longitude: 0,
          radius: 1000,
        ),
        throwsA(
          isA<PlacesException>().having(
            (e) => e.message,
            'message',
            'API key not valid',
          ),
        ),
      );
    });
  });
}
