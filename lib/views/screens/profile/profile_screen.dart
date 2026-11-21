import 'package:flutter/material.dart';

import '../../../controllers/profile_controller.dart';
import '../../../core/helpers/navigation_helper.dart';
import '../../components/petto_bottom_nav_bar.dart';

/// Tela de perfil do Petto.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ProfileController();

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Perfil', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Text(controller.placeholderMessage, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
      bottomNavigationBar: PettoBottomNavBar(
        currentIndex: 4,
        onTap: (index) => NavigationHelper.goToMainTab(context, index, 4),
      ),
    );
  }
}
