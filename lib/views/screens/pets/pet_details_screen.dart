import 'package:flutter/material.dart';

import '../../../controllers/pet_details_controller.dart';

/// Tela de detalhes do pet do Petto.
class PetDetailsScreen extends StatelessWidget {
  const PetDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PetDetailsController();

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Pet')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Detalhes do Pet',
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
