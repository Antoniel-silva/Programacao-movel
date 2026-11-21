import 'package:flutter/material.dart';

import '../../../controllers/product_details_controller.dart';

/// Tela de detalhes do produto do Petto.
class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ProductDetailsController();

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Produto')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Detalhes do Produto',
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
