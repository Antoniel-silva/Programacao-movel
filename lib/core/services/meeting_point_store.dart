import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/meeting_point.dart';

/// Armazena localmente os pontos de encontro cadastrados no Petto.
///
/// A persistência é feita com [SharedPreferences] até que o backend
/// do Petto esteja disponível.
class MeetingPointStore {
  static const _storageKey = 'petto.meeting_points';

  /// Carrega todos os pontos de encontro cadastrados.
  Future<List<MeetingPoint>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return const <MeetingPoint>[];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const <MeetingPoint>[];
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(MeetingPoint.fromJson)
          .toList();
    } catch (_) {
      // Dados corrompidos: considera como lista vazia.
      return const <MeetingPoint>[];
    }
  }

  /// Adiciona um ponto de encontro ao armazenamento local.
  Future<void> add(MeetingPoint point) async {
    final points = await loadAll();
    points.add(point);
    await _saveAll(points);
  }

  Future<void> _saveAll(List<MeetingPoint> points) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(points.map((point) => point.toJson()).toList()),
    );
  }
}
