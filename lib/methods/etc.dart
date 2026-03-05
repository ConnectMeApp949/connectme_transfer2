

import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/config/settings.dart';
import 'package:connectme_app/models/user/user_auth.dart';
import 'package:connectme_app/providers/auth.dart';
// import 'package:connectme_app/providers/auth.dart';
// import 'package:connectme_app/providers/availability.dart';
// import 'package:connectme_app/providers/bookings.dart';
// import 'package:connectme_app/providers/etc.dart';
// import 'package:connectme_app/providers/messaging.dart';

// import 'package:connectme_app/providers/reviews.dart';
// import 'package:connectme_app/providers/services.dart';
// import 'package:connectme_app/providers/stripe.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/requests/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

/// mounted safe pop
/// avoids async gap crash
NavigatorPop_MountedSafe(BuildContext context){
  if (context.mounted && Navigator.canPop(context)) {
    Navigator.pop(context);
  }
}


/// make sure get gContext that's the whole reason I'm doing this stupid thing because
/// was working fine for 4 months and then decides to stop all of a sudden
/// there sure is a lot of code to go through on phoenix damn
callNewLogoutForSomeStpdReason(BuildContext gContext, WidgetRef ref) async{

  lg.t("[callNewLogoutForSomeStpdReason] called");
  await userLogoutFirebase();

  try {
    lg.t("Reset all providers manually");

    ref.read(userAuthProv.notifier).state =  UserAuth(
        userName: dangerousSafeUser.un,
        userId: dangerousSafeUser.uid,
        userToken: "",
        email: "",
        accountLevel: "free",
        purchaseEver: false
    );

    Navigator.pushNamedAndRemoveUntil(
        gNavigatorKey.currentContext!, "/", (route) => false);
    Phoenix.rebirth(gContext);
    /// got effed up right here. I am just about ded kel

    /*
       Try this f it
    /// def need
    ref.read(userAuthProv.notifier).state = null;
    /// might help avoid relog bugs but probably don't need
    ref.read(baseAvailabilityResponseProv.notifier).state = {};

    ref.read(bookingsPastProvider.notifier).clear();
    ref.read(bookingsUpcomingProvider.notifier).clear();
    ref.read(bookingsCumNotifierProvider).clear();
    ref.read(upcomingHasMoreNotifierProvider.notifier).state = true;
    ref.read(pastHasMoreNotifierProvider.notifier).state = true;

    ref.read(tabIndexProvider.notifier).state = 0;
    ref.read(showBNBProvider.notifier).state = true;
    ref.read(userTypeProv.notifier).state = null;
    ref.read(savedServiceProviderProv.notifier).state = [];
    ref.read(clientUseLocationServicesForSearchProv.notifier).state = true;
    ref.read(vendorIsFirstTimeAndJustPaidProv.notifier).state = false;
    ref.read(runPaywallSubroutineForVendorErrorProv.notifier).state = false;
    ref.read(showedRecentPaywallSheet.notifier).state = false;

    ref.read(purchasesProvider.notifier).clear();

    ref.invalidate(reviewsForVendorProvider);

    ref.read(loadingServiceItemsProviderMore.notifier).state = true;
    ref.read(loadingServiceItemsProvider.notifier).state = true;
    ref.read(lastGeoHashProvider.notifier).state = null;
    ref.read(lastServiceDocIdProvider.notifier).state = null;
    ref.read(categoryFilterProvider.notifier).state = null;
    ref.read(lastRemoteServiceDocIdProvider.notifier).state = null;
    ref.read(searchBarInputFilterProvider.notifier).state = [];
    ref.read(distanceStandardProvider.notifier).state = null;
    ref.read(serviceSiteFilterProvider.notifier).state = [true,true,true,true];
    ref.read(keywordFilterProvider.notifier).state = null;
    ref.read(ratingFilterProvider.notifier).state = null;
    ref.read(servicesProvider.notifier).clear();
    ref.read(vendorServicesProvider.notifier).clear();

    ref.read(stripeCustomerIdProv.notifier).state = null;

    // ref.read(profileImageUrlProvider)

    ref.read(messagesProvider.notifier).clearMessages();

      */

    lg.t("provider manual reset complete");

  }catch(e){
    lg.e("Caught Exp in logout thing ~ " + e.toString());
    try{
      lg.t("try catch push home");
      Navigator.pushNamedAndRemoveUntil(
          gNavigatorKey.currentContext!, "/", (route) => false);

    }catch(e){
      lg.e("Exp caught in try catch push home~ " + e.toString());
    }
  }

}
