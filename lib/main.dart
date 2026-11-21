import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'core/constants/app_env.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carrega as variáveis de ambiente do arquivo .env.
  await dotenv.load();
  _logEnvironment();

  // Inicializa o Firebase usando as opções geradas para a plataforma atual.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const PettoApp());
}

/// Registra o status das variáveis de ambiente em modo debug.
///
/// Apenas o status é exibido — os valores (chaves) nunca são impressos.
void _logEnvironment() {
  debugPrint('Ambiente: ${AppEnv.appEnv}');
  debugPrint('API base: ${AppEnv.apiBaseUrl}');
  debugPrint(
    AppEnv.hasGoogleApiKey
        ? 'Google API Key: configurada'
        : 'Google API Key: não configurada',
  );
}