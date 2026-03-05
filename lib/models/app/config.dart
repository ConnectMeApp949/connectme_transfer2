


class AppConfig{
  AppConfig({
    required this.server_url,
    required this.storage_url,
    required this.appUrl,
    required this.useFirebaseStorageEmulator,
    required this.stripePublishableKey,
    required this.revenuecatApiKey,
    required this.showDevSignInBypass,
    required this.cDisableLoggingInProduction,
    required this.useGoogleSignIn,
    required this.simulateNetworkLatency,
    required this.bypassPaywall,
    required this.sConfigOptions
  });

  final String server_url;
  final String storage_url;
  final String appUrl;
  final bool useFirebaseStorageEmulator;
  final String stripePublishableKey;
  final String revenuecatApiKey;
  final bool showDevSignInBypass;
  final bool cDisableLoggingInProduction;
  final bool useGoogleSignIn;
  final bool simulateNetworkLatency;
  final bool bypassPaywall;
  final Map sConfigOptions;
}