import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../routes/app_routes.dart';

/// Controller responsável pelo estado e pela lógica da tela de Cadastro.
class RegisterController {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool aceitouTermos = false;

  /// Rota principal exibida após o cadastro.
  String get authenticatedRoute => AppRoutes.home;

  /// Cria uma nova conta no Firebase Authentication e atualiza o nome de exibição.
  /// Retorna `null` em caso de sucesso ou uma mensagem de erro legível.
  Future<String?> register() async {
    final nome = nomeController.text.trim();
    final email = emailController.text.trim();
    final password = senhaController.text.trim();

    if (nome.isEmpty || email.isEmpty || password.isEmpty) {
      return 'Preencha seu nome, e-mail e senha.';
    }

    if (!aceitouTermos) {
      return 'Você precisa aceitar os Termos de Uso e a Política de Privacidade.';
    }

    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(nome);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'Este e-mail já está cadastrado.';
        case 'invalid-email':
          return 'Formato de e-mail inválido!';
        case 'weak-password':
          return 'A senha é muito fraca (use pelo menos 6 caracteres).';
        default:
          return e.message ?? 'Erro ao criar conta.';
      }
    } catch (_) {
      return 'Erro inesperado ao criar conta.';
    }
  }

  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
  }
}