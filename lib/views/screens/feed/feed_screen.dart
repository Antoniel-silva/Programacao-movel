import 'package:flutter/material.dart';

import '../../../controllers/feed_controller.dart';

/// Tela de feed do Petto.
class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = FeedController();

    return Scaffold(
      appBar: AppBar(title: const Text('Feed')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Feed', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Text(controller.placeholderMessage, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
