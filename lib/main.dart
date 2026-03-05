import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:connectme_app/components/calendar_view_fork/calendar_view.dart';import 'package:connectme_app/config/settings.dart';
import 'package:connectme_app/models/app/config.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/styles/app_theme.dart';
import 'package:connectme_app/util/startup_tests.dart';
import 'package:connectme_app/views/login/login.dart';
import 'package:connectme_app/views/router.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import "package:flutter/foundation.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:connectme_app/config/logger.dart';
import 'components/dev/custom_error.dart';
import 'config/globals.dart';
import 'firebase_options.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:connectme_app/pwa_install_fork/pwa_install.dart';

// import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:connectme_app/platform_bridge/platform_bridge.dart';


class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse, // Add mouse drag support
    PointerDeviceKind.trackpad,
  };
}


void main() async {





  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    String revenuecatMobileApiKey = "<Not_Set>";
    if (Platform.isAndroid) {
      revenuecatMobileApiKey = revenuecatAndroidApiKey;
    }
    if (Platform.isIOS) {
      revenuecatMobileApiKey = revenueCatIOSApiKey;
    }

    /// Mobile Local
    if (Platform.isIOS) {
      cmapp_local_server_base_domain = iosMobileLocal_ServerBaseDomain;
    }
    if (Platform.isAndroid) {
      cmapp_local_server_base_domain = androidMobileLocal_ServerBaseDomain;
    }


    /// Mobile Local
    appConfig = AppConfig(
        server_url: "http://$cmapp_local_server_base_domain:$cmapp_firebase_local_server_port/connectme-app-11465/us-central1",
        storage_url: "http://$cmapp_local_server_base_domain:$cmapp_firebase_local_storage_port/v0/b/connectme-app-11465.appspot.com/o",
        appUrl: "http://$cmapp_local_server_base_domain:$cmapp_firebase_local_web_url_port",
        useFirebaseStorageEmulator: true,
        stripePublishableKey: stripeApiKey,
        revenuecatApiKey: revenuecatMobileApiKey,
        showDevSignInBypass: true,
        cDisableLoggingInProduction: false,
        useGoogleSignIn: true,
        simulateNetworkLatency: true,
        bypassPaywall: false,
      sConfigOptions: {
          "useSandboxSubTiming": true
      }
    );

    /// Mobile Firebase
    appConfig = AppConfig(
        server_url: "https://us-central1-connectme-app-11465.cloudfunctions.net",
        storage_url: "https://firebasestorage.googleapis.com/v0/b/connectme-app-11465.appspot.com/o",
        useFirebaseStorageEmulator: false,
        appUrl: firebaseHostingDeployURL,
        stripePublishableKey: stripeApiKey,
        revenuecatApiKey: revenuecatMobileApiKey,
        showDevSignInBypass: false,
        cDisableLoggingInProduction: false,
        useGoogleSignIn: true,
        simulateNetworkLatency: false,
        bypassPaywall: false,
        sConfigOptions: {
          "useSandboxSubTiming": true
        }
    );
  }

  /// dev chrome firebase emulator
  /// http://127.0.0.1:5001/connectme-app-11465/us-central1/#/stripeVendorOnboardRedirectUrl
  if (kIsWeb) {
    if (!kReleaseMode) {
      /// Web Local
      cmapp_local_server_base_domain = webLocalBaseDomain;
      appConfig = AppConfig(
          server_url: "http://$cmapp_local_server_base_domain:$cmapp_firebase_local_server_port/connectme-app-11465/us-central1",
          storage_url: "http://$cmapp_local_server_base_domain:$cmapp_firebase_local_storage_port/v0/b/connectme-app-11465.appspot.com/o",
          appUrl: "http://$cmapp_local_server_base_domain:$cmapp_firebase_local_web_url_port",
          useFirebaseStorageEmulator: true,
          stripePublishableKey: stripeApiKey,
          revenuecatApiKey: revenueCatWebApiKey,
          showDevSignInBypass: true,
          cDisableLoggingInProduction: false,
          useGoogleSignIn: true,
          simulateNetworkLatency: true,
          bypassPaywall: false,
          sConfigOptions: {
            "useSandboxSubTiming": true
          }
      );

      /// Web Firebase for !kReleaseMode
      // appConfig = AppConfig(
      //     server_url: "https://us-central1-connectme-app-11465.cloudfunctions.net",
      //     storage_url: "https://firebasestorage.googleapis.com/v0/b/connectme-app-11465.appspot.com/o",
      //     useFirebaseStorageEmulator: false,
      //     appUrl: firebaseHostingDeployURL,
      //     stripePublishableKey: stripeApiKey,
      //     revenuecatApiKey: revenueCatWebApiKey,
      //     showDevSignInBypass: true,
      //     cDisableLoggingInProduction: false,
      //     useGoogleSignIn: true,
      //     simulateNetworkLatency: false,
      //     bypassPaywall:false
      // );
    }

    ///Web firebase release ( Eventually Live Stripe keys )
    if (kReleaseMode) {
      appConfig = AppConfig(
          server_url: "https://us-central1-connectme-app-11465.cloudfunctions.net",
          storage_url: "https://firebasestorage.googleapis.com/v0/b/connectme-app-11465.appspot.com/o",
          useFirebaseStorageEmulator: false,
          appUrl: firebaseHostingDeployURL,
          stripePublishableKey: stripeApiKey,
          revenuecatApiKey: revenueCatWebApiKey_SANDBOX,
          showDevSignInBypass: false,
          cDisableLoggingInProduction: false,
          useGoogleSignIn: true,
          simulateNetworkLatency: false,
          bypassPaywall: false,
          sConfigOptions: {
            "useSandboxSubTiming": true
          }
      );
    }

    await FacebookAuth.i.webAndDesktopInitialize(
      appId: "730480449384487",
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
  }


  /// avoid print in production ( save for later or reduce level)
  if (kReleaseMode) {
    if (appConfig.cDisableLoggingInProduction) {
      debugPrint = (String? message, {int? wrapWidth}) {};
    }
  }
  else {
    lg.d("run dev mode startup");
    await runStartupTests();
  }

  WidgetsFlutterBinding.ensureInitialized();


  if (!kReleaseMode) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  if (kReleaseMode) {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDG_Wtv_RLJPWA76oYu2LiX8gv02pToz6o",
            authDomain: "connectme-app-11465.firebaseapp.com",
            projectId: "connectme-app-11465",
            storageBucket: "connectme-app-11465.firebasestorage.app",
            messagingSenderId: "631708018726",
            appId: "1:631708018726:web:cc0dcc1fcf444ef4801ee7",
            measurementId: "G-3TC7GYMPH6"
        ),
      );
    }
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }

  if (appConfig.useFirebaseStorageEmulator) {
    FirebaseStorage.instance.useStorageEmulator(
        cmapp_local_server_base_domain, 9199);
  }

  /// I don't think this is worth it
  // await FirebaseAppCheck.instance.activate(
  //   // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
  //   // argument for `webProvider`
  //   // webProvider: ReCaptchaV3Provider('6LeuSXsrAAAAAOFGCFiq77Bas3F4PAlGc9SAPLbp'),
  //   webProvider: ReCaptchaEnterpriseProvider("6LeuSXsrAAAAAOFGCFiq77Bas3F4PAlGc9SAPLbp"),
  //   // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
  //   // your preferred provider. Choose from:
  //   // 1. Debug provider
  //   // 2. Safety Net provider
  //   // 3. Play Integrity provider
  //   androidProvider: AndroidProvider.debug,
  //   // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
  //   // your preferred provider. Choose from:
  //   // 1. Debug provider
  //   // 2. Device Check provider
  //   // 3. App Attest provider
  //   // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
  //   appleProvider: AppleProvider.appAttest,
  // );


  // await initializeInAppPurchase(ref);


  // if (kIsWeb) {
  //   // RCStoreConfig(
  //   //   store: Store.rcBilling,
  //   //   apiKey: rc_web_api_key,
  //   // );
  //   callSubscriptionConfig("testkey");
  // }
  // else if (Platform.isIOS || Platform.isMacOS) {
  //
  // } else if (Platform.isAndroid) {
  //   // Run the app passing --dart-define=AMAZON=true
  //   // const useAmazon = bool.fromEnvironment("amazon");
  //   RCStoreConfig(
  //     store: /*useAmazon ? Store.amazon : */  Store.playStore,
  //     apiKey:/* useAmazon ? amazonApiKey :*/ rc_web_api_key, ///  NOT GOING TO WORK
  //   );
  // }



    //await configure_RC_SDK();
  if (kIsWeb) {
    // await configure_RC_SDK();


    PWAInstall().setup(installCallback: () {
      lg.t('[pwa_install_fork] APP INSTALLED callback fired');
    });

    if (PWAInstall().installPromptEnabled == true) {
      try {
        PWAInstall().promptInstall_();
      } catch (e) {
        lg.e("error caught in PWA install prompt");
        lg.e(e.toString());
      }
    }
    else {
      lg.w("PWA install prompt disabled");
    }
  }
  else
    if (!kIsWeb) {
      if (Platform.isAndroid || Platform.isIOS){
        lg.t("call mobile sub config");

    }
  }


  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
  ]);     // DeviceOrientation.landscapeLeft,
  // DeviceOrientation.landscapeRight,

  /// set status bar color
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: appPrimarySwatch,
  //     statusBarIconBrightness: Brightness.dark,
  //   ),
  // );
/// hide status bar entirely
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  /// too early here don't have any login detail
  /// should do latest list truncated because IPS change alot if want to use for rate limiting
  // await logLoginTrackMeta();

  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exceptionAsString().contains('mouse_tracker.dart')) {
      // ignore
      return;
    }
    FlutterError.dumpErrorToConsole(details);
  };

  final List<String> excludedErrorSources = [
    'mouse_tracker.dart',
    'engine/window.dart',
  ];

  lg.t("run zoned guarded");

  runZonedGuarded(() {
  runApp(Phoenix(
      child:
      // runApp(
          ProviderScope(
          child:const ConnectMeApp()))
    );

  }
    , (error, stack) {
    lg.e("Caught Exp in runZonedGuarded");
    FlutterError.reportError(FlutterErrorDetails(exception: error, stack: stack));
    }, zoneSpecification: ZoneSpecification(
    print: (self, parent, zone, line) {
    final excluded = excludedErrorSources.any((e) => line.contains(e));
    if (!excluded) parent.print(zone, line);
    },
    ));

}

class ConnectMeApp extends ConsumerStatefulWidget {
  const ConnectMeApp({super.key});

  @override
  ConsumerState<ConnectMeApp> createState() => _ConnectMeAppState();
}

class _ConnectMeAppState extends ConsumerState<ConnectMeApp> with WidgetsBindingObserver{

  @override
  void initState() {
    super.initState();

    initializeInAppPurchase(ref);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    scheduleMicrotask(() {
      if (brightness == Brightness.dark) {
        ref.read(darkModeProv.notifier).state = true;
      }
      else{
        ref.read(darkModeProv.notifier).state = false;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // if (!_handledRedirect) {
    //   _handledRedirect = true;
    // runOauthRedirectHandlers();
    // }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    lg.t("build connectme app primary theme ~");


    return
      Builder(builder: (context) {
        Gss = MediaQuery.of(context).size;
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          if (kReleaseMode) {
            // do not do in production
            // lg.d(er  rorDetails.stack.toString());
            // lg.d(errorDetails.exception.toString());
            // lg.d(errorDetails.toString());
            return const PoppableProductionError();
          } else {
            return PoppableProductionError();
            return CustomError(errorDetails: errorDetails);
          }
        };
        return
          CalendarControllerProvider(
            controller: EventController(),
              // ..addAll(calendarMockEvents),
        child:
        Directionality(
            textDirection: TextDirection.ltr,
            child:
            MaterialApp(
              navigatorKey: gNavigatorKey,
          title: 'ConnectMe',
          showPerformanceOverlay: false,
          // locale:
          // enableDevicePreviewPackage ? DevicePreview.locale(context) : null,
          // builder: enableDevicePreviewPackage ? DevicePreview.appBuilder : null,
          scrollBehavior: AppScrollBehavior(),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: "/",
          theme: primaryThemeData,
          darkTheme: darkThemeData,
          themeMode: ref.watch(darkModeProv) ? ThemeMode.dark : ThemeMode.light,
          home: ConnectMeLogin(),
        )));
      });
  }
}




