import 'package:flutter/material.dart';

import '../../../controllers/login_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routes/app_routes.dart';

/// Tela de login do Petto.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _controller = LoginController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    final errorMessage = await _controller.login();
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }

    Navigator.pushReplacementNamed(context, _controller.authenticatedRoute);
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.mutedText,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrar'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'BEM-VINDO DE VOLTA',
                  style: TextStyle(
                    color: AppTheme.primaryGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Que bom ver\nvocê por aqui!',
                  style: TextStyle(
                    color: AppTheme.darkGreen,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Acesse sua conta para continuar no Petto.',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 28),
                _buildFieldLabel('E-mail'),
                TextFormField(
                  controller: _controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: AppTheme.darkGreen,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'marina.costa@email.com',
                  ),
                ),
                const SizedBox(height: 18),
                _buildFieldLabel('Senha'),
                TextFormField(
                  controller: _controller.senhaController,
                  obscureText: true,
                  style: const TextStyle(
                    color: AppTheme.darkGreen,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  decoration: const InputDecoration(
                    hintText: '••••••••••',
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Entrar'),
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: _isLoading
                        ? null
                        : () => Navigator.pushNamed(context, AppRoutes.register),
                    child: const Text(
                      'Criar conta',
                      style: TextStyle(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}