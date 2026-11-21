import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// Status do acesso à localização do usuário.
enum LocationStatus {
  /// Permissão concedida.
  granted,

  /// Serviços de localização desativados no dispositivo.
  serviceDisabled,

  /// Permissão negada pelo usuário (pode pedir novamente).
  denied,

  /// Permissão negada permanentemente (só pelo ajuste do sistema).
  deniedForever,
}

/// Auxilia na obtenção da permissão e da posição do usuário.
abstract class LocationHelper {
  LocationHelper._();

  /// Solicita a permissão de localização e informa o resultado.
  static Future<LocationStatus> requestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return LocationStatus.serviceDisabled;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return switch (permission) {
      LocationPermission.denied => LocationStatus.denied,
      LocationPermission.deniedForever => LocationStatus.deniedForever,
      _ => LocationStatus.granted,
    };
  }

  /// Retorna a posição atual do usuário.
  ///
  /// Lança uma exceção quando o tempo esgota ou o serviço falha.
  static Future<Position> currentPosition() {
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 20),
      ),
    );
  }

  /// Abre as configurações de localização do dispositivo.
  static Future<bool> openLocationSettings() =>
      Geolocator.openLocationSettings();

  /// Abre as configurações do aplicativo (para liberar permissão negada).
  static Future<bool> openAppSettings() => Geolocator.openAppSettings();

  /// Retorna um rótulo legível da localização (ex.: "Alto de Pinheiros,
  /// São Paulo"). Retorna null quando não é possível converter.
  static Future<String?> reverseGeocode(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await Geocoding().placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isEmpty) return null;

      final place = placemarks.first;
      final parts = <String>[
        if (place.subLocality != null && place.subLocality!.isNotEmpty)
          place.subLocality!,
        if (place.locality != null && place.locality!.isNotEmpty)
          place.locality!,
      ];
      if (parts.isNotEmpty) return parts.join(', ');

      final administrativeArea = place.administrativeArea;
      if (administrativeArea != null && administrativeArea.isNotEmpty) {
        return administrativeArea;
      }
      return null;
    } catch (_) {
      // Geocodificação indisponível (offline, sem serviço, etc.).
      return null;
    }
  }
}
