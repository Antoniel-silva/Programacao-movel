import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Variáveis de ambiente do Petto.
///
/// Os valores são lidos do arquivo `.env` na raiz do projeto,
/// que é carregado no `main()` antes do `runApp()`.
///
/// Nunca acessar as variáveis fora do fluxo do aplicativo
/// (ex.: em inicializadores de topo) antes do carregamento.
abstract class AppEnv {
  AppEnv._();

  /// Ambiente da aplicação (development, staging, production).
  static String get appEnv => dotenv.get('APP_ENV', fallback: 'development');

  /// URL base da API do Petto.
  static String get apiBaseUrl => dotenv.get('API_BASE_URL', fallback: '');

  /// Chave da API do Google (Maps / Places).
  ///
  /// Preencha o valor no arquivo `.env` na raiz do projeto.
  static String get googleApiKey => dotenv.get('GOOGLE_API_KEY', fallback: '');

  /// Indica se a chave da API do Google foi configurada.
  static bool get hasGoogleApiKey => googleApiKey.isNotEmpty;

  /// Indica que o arquivo `.env` já foi carregado.
  static bool get isLoaded => dotenv.isInitialized;
}
