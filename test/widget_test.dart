import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petto/app.dart';
import 'package:petto/core/constants/app_env.dart';
import 'package:petto/views/screens/auth/login_screen.dart';
import 'package:petto/views/screens/splash/splash_screen.dart';

void main() {
  test('carrega as variáveis de ambiente do arquivo .env', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    await dotenv.load();

    expect(dotenv.isInitialized, isTrue);
    expect(AppEnv.appEnv, isNotEmpty);
    expect(AppEnv.apiBaseUrl, isNotEmpty);
    expect(AppEnv.googleApiKey, isA<String>());
  });

  testWidgets('inicia na SplashScreen e navega para o Login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PettoApp());

    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Login'), findsWidgets);
  });
}
