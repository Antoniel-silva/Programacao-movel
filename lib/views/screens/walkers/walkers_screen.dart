import 'package:flutter/material.dart';

import '../../../controllers/walkers_controller.dart';

/// Tela de lista de walkers do Petto.
class WalkersScreen extends StatelessWidget {
  const WalkersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WalkersController();

    return Scaffold(
      appBar: AppBar(title: const Text('Walkers')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Walkers', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Text(controller.placeholderMessage, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
