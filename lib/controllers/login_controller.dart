import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../routes/app_routes.dart';

/// Controller responsável pelo estado e pela lógica da tela de Login.
class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Rota principal exibida após a autenticação.
  String get authenticatedRoute => AppRoutes.home;

  /// Realiza o login com e-mail e senha no Firebase Authentication.
  /// Retorna `null` em caso de sucesso ou uma mensagem de erro legível.
  Future<String?> login() async {
    final email = emailController.text.trim();
    final password = senhaController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      return 'Preencha o e-mail e a senha.';
    }

    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        return 'Não foi possível concluir o login.';
      }
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Usuário não encontrado!';
        case 'wrong-password':
        case 'invalid-credential':
          return 'E-mail ou senha inválidos!';
        case 'invalid-email':
          return 'Formato de e-mail inválido!';
        case 'user-disabled':
          return 'Esta conta foi desativada.';
        default:
          return e.message ?? 'Erro ao fazer login.';
      }
    } catch (_) {
      return 'Erro inesperado ao fazer login.';
    }
  }

  void dispose() {
    emailController.dispose();
    senhaController.dispose();
  }
}