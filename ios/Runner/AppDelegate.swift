import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // TODO: Cole aqui a mesma GOOGLE_API_KEY do arquivo .env na raiz do projeto.
    // No iOS a chave não pode ser lida do .env em tempo de execução,
    // por isso ela é informada diretamente aqui (não commite a chave real).
    GMSServices.provideAPIKey("SUA_GOOGLE_API_KEY")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
