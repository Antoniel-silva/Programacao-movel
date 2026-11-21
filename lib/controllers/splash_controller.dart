import 'package:firebase_auth/firebase_auth.dart';

import '../routes/app_routes.dart';

/// Controller responsável pelo estado e pela lógica da SplashScreen.
class SplashController {
  /// Mensagem temporária exibida enquanto o conteúdo da tela
  /// não for implementado.
  String get placeholderMessage =>
      'Conteúdo da tela de splash será implementado aqui.';

  /// Próxima rota após a splash screen:
  /// envia para a Home se já houver usuário logado, ou para o Login caso contrário.
  String get nextRoute {
    final user = FirebaseAuth.instance.currentUser;
    return user != null ? AppRoutes.home : AppRoutes.login;
  }
}