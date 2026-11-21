import 'package:flutter/material.dart';

import '../../../controllers/pet_list_controller.dart';

/// Tela de listagem de pets do Petto.
class PetListScreen extends StatelessWidget {
  const PetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PetListController();

    return Scaffold(
      appBar: AppBar(title: const Text('Meus Pets')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Meus Pets',
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
