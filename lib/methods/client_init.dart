


import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/providers/stripe.dart';
import 'package:connectme_app/requests/save_provider/save_provider.dart';
import 'package:connectme_app/requests/stripe/stripe_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

initializeClientProviders(WidgetRef ref)async {
  lg.t("initSavedServiceProviders called");
  await initSavedServiceProviders(ref);
  lg.t("initPaymentMethodsProviders done");
  await initPaymentMethodsProviders(ref);
  lg.t("passed initPaymentMethodsProviders");
}


initSavedServiceProviders(WidgetRef ref )async{

  var savedProviders = await getSavedProviders(
      ref.read(userAuthProv)!.userId,
      ref.read(userAuthProv)!.userToken);

  lg.t("savedProviders runtimeType: ${savedProviders.runtimeType}");

  ref.read(savedServiceProviderProv.notifier).state = savedProviders; /// as List<String>
}


initPaymentMethodsProviders(WidgetRef ref)async{
lg.t("[initPaymentMethodsProviders] called");
  var resp = await getStripeClientAccountStatus(
      ref,
      ref.read(userAuthProv)!.userToken,
      ref.read(userAuthProv)!.userId);
  if (resp["accountStatus"] == "not_created"){
    lg.t("[initPaymentMethodsProviders] accountStatus not_created");
  }
  else if (resp.containsKey("stripe_customer_id")){
    lg.t("[initPaymentMethodsProviders] stripe_customer_id not null");
    if (resp["stripe_customer_id"]!= null) {
      ref.read(stripeCustomerIdProv.notifier).state = resp["stripe_customer_id"];
    }
  }

}