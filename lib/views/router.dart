import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/views/etc/redirect_landing.dart';
import 'package:connectme_app/views/stripe/refresh_url_page.dart';
import 'package:connectme_app/views/stripe/stripe_redirect_url_page.dart';
import 'package:connectme_app/views/test_route.dart';
import 'package:connectme_app/views/vendor_app/vendor_app.dart';
import 'package:flutter/material.dart';
import 'client_app/client_app.dart';
import 'login/login.dart';



class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {

    lg.t("[generateRoute] called");
    String? sn = settings.name;
    lg.t("[AppRouter] called with ~ ${ sn }" );

    final uri = Uri.parse(settings.name ?? '/');

    // switch (uri.path) {
    if (uri.path == "/client_home") {
      return MaterialPageRoute(builder: (_) => const ConnectMeClientApp());
    }
    if (uri.path == "/vendor_home") {
      return MaterialPageRoute(builder: (_) => const ConnectMeVendorApp());
    }
    if (uri.path == "/stripeVendorOnboardRefreshUrl"){
        return MaterialPageRoute(builder: (_) =>  const StripeRefreshUrlPage());
    }
    if (uri.path == "/stripeVendorOnboardRedirectUrl") {
      return MaterialPageRoute(builder: (_) => const StripeRedirectUrlPage());
    }
    if (uri.path == "__/auth/handler") {
      return MaterialPageRoute(builder: (_) => const RedirectLanding());
    }
    if (uri.path == "/test_r") {
      lg.t("settings name ~ " + settings.name.toString());
      final uri = Uri.parse(settings.name ?? '/');
      final foo = uri.queryParameters['foo'];
      lg.t("test_r query params ~ " + foo.toString());
      return MaterialPageRoute(builder: (_) => const TestRoute());
    }
    else{
      lg.t("get fucked");
        return MaterialPageRoute(builder: (_) => const ConnectMeLogin());
      }
  }
}

