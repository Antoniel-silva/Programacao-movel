/// Constantes gerais do aplicativo Petto.
abstract class AppConstants {
  AppConstants._();

  /// Nome exibido no aplicativo.
  static const String appName = 'Petto';

  /// Duração exibida na SplashScreen antes da navegação inicial.
  static const Duration splashDuration = Duration(seconds: 2);

  /// Padding padrão utilizado nas telas.
  static const double defaultPadding = 16.0;

  // Localização padrão do mapa (São Paulo) usada quando a
  // posição do usuário não está disponível.
  static const double defaultLatitude = -23.5505;
  static const double defaultLongitude = -46.6333;

  /// Zoom inicial do mapa de exploração.
  static const double mapInitialZoom = 12;

  /// Zoom ao centralizar em um local.
  static const double mapPlaceZoom = 16;

  /// Raio de busca padrão (em metros).
  static const double defaultSearchRadius = 2000;

  /// Opções de raio de busca oferecidas no filtro (em metros).
  static const List<double> searchRadiusOptions = <double>[
    500,
    1000,
    2000,
    5000,
  ];
}
