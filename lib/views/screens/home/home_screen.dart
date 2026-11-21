import 'package:flutter/material.dart';

import '../../../controllers/home_controller.dart';
import '../../../core/helpers/navigation_helper.dart';
import '../../components/petto_bottom_nav_bar.dart';

/// Tela principal do Petto, exibida após a autenticação simulada.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController();

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Home', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Text(controller.placeholderMessage, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
      bottomNavigationBar: PettoBottomNavBar(
        currentIndex: 0,
        onTap: (index) => NavigationHelper.goToMainTab(context, index, 0),
      ),
    );
  }
}
