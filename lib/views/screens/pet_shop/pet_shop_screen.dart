import 'package:flutter/material.dart';

import '../../../controllers/pet_shop_controller.dart';
import '../../../core/helpers/navigation_helper.dart';
import '../../components/petto_bottom_nav_bar.dart';

/// Tela da Pet Shop do Petto.
class PetShopScreen extends StatelessWidget {
  const PetShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PetShopController();

    return Scaffold(
      appBar: AppBar(title: const Text('Pet Shop')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pet Shop',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(controller.placeholderMessage, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
      bottomNavigationBar: PettoBottomNavBar(
        currentIndex: 3,
        onTap: (index) => NavigationHelper.goToMainTab(context, index, 3),
      ),
    );
  }
}
