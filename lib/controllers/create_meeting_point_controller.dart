import 'package:flutter/material.dart';

import '../../core/services/meeting_point_store.dart';
import '../../models/meeting_point.dart';

/// Controlador da tela de cadastro de ponto de encontro.
class CreateMeetingPointController {
  CreateMeetingPointController({MeetingPointStore? meetingPointStore})
    : _meetingPointStore = meetingPointStore ?? MeetingPointStore();

  final MeetingPointStore _meetingPointStore;

  /// Campo de nome do ponto de encontro.
  final TextEditingController nameController = TextEditingController();

  /// Campo de descrição do ponto de encontro.
  final TextEditingController descriptionController = TextEditingController();

  /// Campo de endereço do ponto de encontro (opcional).
  final TextEditingController addressController = TextEditingController();

  /// Valida o nome informado.
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o nome do ponto de encontro';
    }
    return null;
  }

  /// Valida a descrição informada.
  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe uma descrição para o ponto de encontro';
    }
    return null;
  }

  /// Salva o ponto de encontro com a localização informada pela tela.
  Future<MeetingPoint> save({
    required double latitude,
    required double longitude,
  }) async {
    final address = addressController.text.trim();
    final point = MeetingPoint(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      address: address.isEmpty ? 'Localização informada no mapa' : address,
      latitude: latitude,
      longitude: longitude,
      createdAt: DateTime.now(),
    );

    await _meetingPointStore.add(point);
    return point;
  }

  /// Libera os campos de texto.
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
  }
}
