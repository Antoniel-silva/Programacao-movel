import 'package:flutter/foundation.dart';

import '../../core/services/places_service.dart';
import '../../models/meeting_point.dart';
import '../../models/pet_place.dart';

/// Controlador da tela de detalhes do local / ponto de encontro.
class MeetingPointDetailsController extends ChangeNotifier {
  MeetingPointDetailsController({PlacesService? placesService})
    : _placesService = placesService ?? PlacesService();

  final PlacesService _placesService;

  bool _disposed = false;

  /// Local exibido (quando os detalhes vêm do Google Places).
  PetPlace? place;

  /// Ponto de encontro exibido (quando cadastrado pelo usuário).
  MeetingPoint? meetingPoint;

  /// Indica que os detalhes adicionais estão sendo carregados.
  bool isLoading = false;

  /// Mensagem de erro ao carregar os detalhes adicionais.
  String? errorMessage;

  /// Carrega os detalhes de um local do mapa.
  ///
  /// Os dados básicos são exibidos imediatamente e os detalhes
  /// adicionais (telefone, horário, etc.) são buscados em seguida.
  Future<void> loadPlace(PetPlace place) async {
    this.place = place;
    meetingPoint = null;
    errorMessage = null;
    isLoading = true;
    _notify();

    try {
      this.place = await _placesService.getDetails(place.id);
    } on PlacesException catch (error) {
      // Mantém os dados básicos e informa a falha.
      errorMessage = error.message;
    } catch (_) {
      errorMessage = 'Não foi possível carregar os detalhes do local.';
    }

    isLoading = false;
    _notify();
  }

  /// Exibe os dados de um ponto de encontro cadastrado no Petto.
  void showMeetingPoint(MeetingPoint point) {
    meetingPoint = point;
    place = null;
    isLoading = false;
    errorMessage = null;
    _notify();
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
