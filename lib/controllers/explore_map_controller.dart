import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../core/constants/app_constants.dart';
import '../core/helpers/location_helper.dart';
import '../core/services/meeting_point_store.dart';
import '../core/services/places_service.dart';
import '../models/meeting_point.dart';
import '../models/pet_place.dart';
import '../models/place_category.dart';
import '../models/place_filter.dart';

/// Controlador da tela de exploração (mapa).
///
/// Responsável pela localização do usuário, busca de locais
/// próximos, filtros e pontos de encontro cadastrados.
class ExploreMapController extends ChangeNotifier {
  ExploreMapController({
    PlacesService? placesService,
    MeetingPointStore? meetingPointStore,
  }) : _placesService = placesService ?? PlacesService(),
       _meetingPointStore = meetingPointStore ?? MeetingPointStore();

  final PlacesService _placesService;
  final MeetingPointStore _meetingPointStore;

  bool _disposed = false;
  int _searchVersion = 0;

  /// Indica que uma busca está em andamento.
  ///
  /// Começa como `true` porque a tela inicia a busca automaticamente.
  bool isLoading = true;

  /// Mensagem de erro da última busca (quando houver).
  String? errorMessage;

  /// Status do acesso à localização do usuário.
  LocationStatus? locationStatus;

  /// Posição atual do usuário (null quando indisponível).
  Position? userPosition;

  /// Locais encontrados na última busca.
  List<PetPlace> places = const <PetPlace>[];

  /// Pontos de encontro cadastrados pelo usuário.
  List<MeetingPoint> meetingPoints = const <MeetingPoint>[];

  /// Filtro atual da busca.
  PlaceFilter filter = const PlaceFilter();

  /// Texto de busca informado pelo usuário.
  String query = '';

  /// Rótulo da localização do usuário (bairro, cidade).
  String locationLabel = 'Sua localização atual';

  /// Versão da última busca concluída (para a tela reagir aos resultados).
  int get searchVersion => _searchVersion;

  /// Indica que a localização do usuário está disponível.
  bool get hasLocation => userPosition != null;

  /// Indica que a permissão de localização foi negada.
  bool get locationDenied =>
      locationStatus == LocationStatus.denied ||
      locationStatus == LocationStatus.deniedForever;

  /// Indica que os serviços de localização estão desativados.
  bool get locationServiceDisabled =>
      locationStatus == LocationStatus.serviceDisabled;

  /// Inicializa a tela: carrega os pontos de encontro,
  /// solicita a localização e busca os locais próximos.
  Future<void> initialize() async {
    try {
      await loadMeetingPoints();
    } catch (_) {
      // Armazenamento indisponível: segue com a lista vazia.
    }

    try {
      await requestLocation();
    } catch (_) {
      // Permissão indisponível: usa o centro padrão do mapa.
      locationStatus = LocationStatus.denied;
      _notify();
    }

    await search();
  }

  /// Recarrega os pontos de encontro do armazenamento local.
  Future<void> loadMeetingPoints() async {
    final points = await _meetingPointStore.loadAll();
    meetingPoints = points;
    _notify();
  }

  /// Solicita a permissão e obtém a posição atual do usuário.
  Future<void> requestLocation() async {
    locationStatus = await LocationHelper.requestPermission();
    _notify();

    if (locationStatus != LocationStatus.granted) return;

    try {
      userPosition = await LocationHelper.currentPosition();
    } catch (_) {
      // Tempo esgotado ou serviço indisponível: usa o centro padrão.
      userPosition = null;
    }
    _notify();

    final position = userPosition;
    if (position != null) {
      final label = await LocationHelper.reverseGeocode(
        position.latitude,
        position.longitude,
      );
      if (label != null && !_disposed) {
        locationLabel = label;
        _notify();
      }
    }
  }

  /// Texto de distância do usuário até a coordenada
  /// (ex.: "800 m de você", "1,2 km de você").
  ///
  /// Retorna null quando a localização do usuário está indisponível.
  String? distanceLabel(double latitude, double longitude) {
    final position = userPosition;
    if (position == null) return null;

    final meters = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      latitude,
      longitude,
    );

    if (meters < 1000) return '${meters.round()} m de você';

    final kilometers = meters / 1000;
    final value = kilometers >= 10
        ? kilometers.round().toString()
        : kilometers.toStringAsFixed(1).replaceAll('.', ',');
    return '$value km de você';
  }

  /// Tenta novamente obter a localização (botão na tela).
  Future<void> retryLocation() async {
    await requestLocation();
    if (userPosition != null) await search();
  }

  /// Abre as configurações de localização do dispositivo.
  Future<void> openLocationSettings() => LocationHelper.openLocationSettings();

  /// Abre as configurações do aplicativo (permissão negada).
  Future<void> openAppSettings() => LocationHelper.openAppSettings();

  double get _centerLatitude =>
      userPosition?.latitude ?? AppConstants.defaultLatitude;

  double get _centerLongitude =>
      userPosition?.longitude ?? AppConstants.defaultLongitude;

  /// Busca locais usando o filtro e a consulta atuais.
  Future<void> search() async {
    final searchId = ++_searchVersion;
    isLoading = true;
    errorMessage = null;
    _notify();

    try {
      final results = query.trim().isEmpty
          ? await _placesService.searchNearby(
              latitude: _centerLatitude,
              longitude: _centerLongitude,
              filter: filter,
            )
          : await _placesService.searchText(
              query: query.trim(),
              latitude: _centerLatitude,
              longitude: _centerLongitude,
              radius: filter.radiusMeters,
            );

      // Descarta resultados de buscas antigas.
      if (searchId != _searchVersion) return;

      places = results;
    } on PlacesException catch (error) {
      if (searchId != _searchVersion) return;
      places = const <PetPlace>[];
      errorMessage = error.message;
    } catch (_) {
      if (searchId != _searchVersion) return;
      places = const <PetPlace>[];
      errorMessage = 'Não foi possível buscar locais. Verifique sua conexão.';
    }

    isLoading = false;
    _notify();
  }

  /// Atualiza o texto de busca.
  ///
  /// Ao limpar o texto, restaura a busca por proximidade.
  Future<void> setQuery(String value) async {
    query = value;
    if (value.trim().isEmpty) {
      await search();
    } else {
      _notify();
    }
  }

  /// Executa a busca com o texto informado.
  Future<void> submitQuery() => search();

  /// Aplica a categoria selecionada nos filtros.
  void setCategory(PlaceCategory? category) {
    filter = PlaceFilter(category: category, radiusMeters: filter.radiusMeters);
    search();
  }

  /// Aplica o raio de busca selecionado nos filtros.
  void setRadius(double radiusMeters) {
    filter = PlaceFilter(category: filter.category, radiusMeters: radiusMeters);
    search();
  }

  /// Limpa os filtros de categoria e raio.
  void clearFilters() {
    filter = const PlaceFilter();
    search();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }
}
