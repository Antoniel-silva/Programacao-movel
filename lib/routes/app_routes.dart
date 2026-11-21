import 'package:flutter/material.dart';

import '../views/screens/auth/login_screen.dart';
import '../views/screens/auth/register_screen.dart';
import '../views/screens/checkin/checkin_screen.dart';
import '../views/screens/explore/create_meeting_point_screen.dart';
import '../views/screens/explore/explore_map_screen.dart';
import '../views/screens/explore/meeting_point_details_screen.dart';
import '../views/screens/feed/create_post_screen.dart';
import '../views/screens/feed/feed_screen.dart';
import '../views/screens/home/home_screen.dart';
import '../views/screens/pet_shop/cart_screen.dart';
import '../views/screens/pet_shop/pet_shop_screen.dart';
import '../views/screens/pet_shop/product_details_screen.dart';
import '../views/screens/pets/pet_create_screen.dart';
import '../views/screens/pets/pet_details_screen.dart';
import '../views/screens/pets/pet_list_screen.dart';
import '../views/screens/profile/edit_profile_screen.dart';
import '../views/screens/profile/profile_screen.dart';
import '../views/screens/splash/splash_screen.dart';
import '../views/screens/walkers/walker_details_screen.dart';
import '../views/screens/walkers/walkers_screen.dart';

/// Rotas nomeadas do Petto.
///
/// Todas as navegações do aplicativo devem usar os nomes
/// declarados aqui, em vez de rotas escritas diretamente nas telas.
abstract class AppRoutes {
  AppRoutes._();

  // Splash
  static const String splash = '/splash';

  // Auth
  static const String login = '/login';
  static const String register = '/register';

  // Home
  static const String home = '/home';

  // Pets
  static const String petList = '/pets';
  static const String petCreate = '/pets/create';
  static const String petDetails = '/pets/details';

  // Feed
  static const String feed = '/feed';
  static const String createPost = '/feed/create-post';

  // Explore
  static const String exploreMap = '/explore';
  static const String meetingPointDetails = '/explore/meeting-point';
  static const String createMeetingPoint = '/explore/create-meeting-point';

  // Check-in
  static const String checkin = '/checkin';

  // Pet Shop
  static const String petShop = '/pet-shop';
  static const String productDetails = '/pet-shop/product';
  static const String cart = '/pet-shop/cart';

  // Walkers
  static const String walkers = '/walkers';
  static const String walkerDetails = '/walkers/details';

  // Profile
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';

  /// Mapa de rotas nomeadas usado pelo [MaterialApp].
  static Map<String, WidgetBuilder> get routes => <String, WidgetBuilder>{
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    register: (_) => const RegisterScreen(),
    home: (_) => const HomeScreen(),
    petList: (_) => const PetListScreen(),
    petCreate: (_) => const PetCreateScreen(),
    petDetails: (_) => const PetDetailsScreen(),
    feed: (_) => const FeedScreen(),
    createPost: (_) => const CreatePostScreen(),
    exploreMap: (_) => const ExploreMapScreen(),
    meetingPointDetails: (_) => const MeetingPointDetailsScreen(),
    createMeetingPoint: (_) => const CreateMeetingPointScreen(),
    checkin: (_) => const CheckinScreen(),
    petShop: (_) => const PetShopScreen(),
    productDetails: (_) => const ProductDetailsScreen(),
    cart: (_) => const CartScreen(),
    walkers: (_) => const WalkersScreen(),
    walkerDetails: (_) => const WalkerDetailsScreen(),
    profile: (_) => const ProfileScreen(),
    editProfile: (_) => const EditProfileScreen(),
  };
}
