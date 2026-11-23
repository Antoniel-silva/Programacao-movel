import 'package:flutter/material.dart';

import '../../../controllers/register_controller.dart';
import '../../../core/theme/app_theme.dart';

/// Tela de cadastro do Petto.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterController _controller = RegisterController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    setState(() => _isLoading = true);
    final errorMessage = await _controller.register();
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

    Navigator.pushNamedAndRemoveUntil(
      context,
      _controller.authenticatedRoute,
      (route) => false,
    );
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
        title: const Text('Vamos nos conhecer'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PRIMEIRO, VOCÊ · 1 DE 2',
                style: TextStyle(
                  color: AppTheme.primaryGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Quem está do\noutro lado da guia?',
                style: TextStyle(
                  color: AppTheme.darkGreen,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sua próxima amizade começa por aqui.',
                style: TextStyle(
                  color: AppTheme.mutedText,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 28),
              _buildFieldLabel('Seu nome'),
              TextFormField(
                controller: _controller.nomeController,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(
                  color: AppTheme.darkGreen,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                decoration: const InputDecoration(
                  hintText: 'Ex: Marina Costa',
                ),
              ),
              const SizedBox(height: 18),
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
              const SizedBox(height: 16),
              CheckboxListTile(
                value: _controller.aceitouTermos,
                onChanged: _isLoading
                    ? null
                    : (value) {
                        setState(() {
                          _controller.aceitouTermos = value ?? false;
                        });
                      },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Concordo com os Termos de Uso e a Política de Privacidade do Petto.',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Continuar para meu pet'),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: const Text(
                    'Já tenho conta',
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
    );
  }
}