import 'package:flutter/material.dart';

import '../../../controllers/pet_create_controller.dart';

/// Tela de cadastro de pet do Petto.
class PetCreateScreen extends StatelessWidget {
  const PetCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PetCreateController();

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Pet')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Cadastrar Pet',
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
