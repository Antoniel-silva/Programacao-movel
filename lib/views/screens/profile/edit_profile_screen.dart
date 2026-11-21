import 'package:flutter/material.dart';

import '../../../controllers/edit_profile_controller.dart';

/// Tela de edição de perfil do Petto.
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = EditProfileController();

    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Editar Perfil',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(controller.placeholderMessage, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
