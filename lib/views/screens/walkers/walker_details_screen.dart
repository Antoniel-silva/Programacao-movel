import 'package:flutter/material.dart';

import '../../../controllers/walker_details_controller.dart';

/// Tela de detalhes do walker do Petto.
class WalkerDetailsScreen extends StatelessWidget {
  const WalkerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WalkerDetailsController();

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Walker')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Detalhes do Walker',
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
