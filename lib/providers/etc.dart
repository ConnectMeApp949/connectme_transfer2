
import 'package:connectme_app/models/user/etc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// toggle dark mode, set on startup to system theme
final darkModeProv = StateProvider<bool>((ref) {
  return false;
});

final tabIndexProvider = StateProvider<int>((ref) {
  return 0;
});

// final geoHashProvider = StateProvider<String>((ref) {
//   return "9yuwukk8q"; /// somewhere in kansas
// });

/// whether to show scrolling to top FAB... removed for now
// final showFABProvider = StateProvider<bool>((ref) {
//   return false;
// });

/// show bottom navigation bar
final showBNBProvider = StateProvider<bool>((ref) {
  return true;
});

/// for uploads to show live upload progress count
final uploadItemCounterProv = StateProvider<int>((ref) {
  return 0;
});


final userTypeProv = StateProvider<UserType?>((ref) {
  return null;
});

final savedServiceProviderProv = StateProvider<List<String>>((ref) {
  return [];
});


final clientUseLocationServicesForSearchProv = StateProvider<bool>((ref) {
  return true;
});

final vendorIsFirstTimeAndJustPaidProv = StateProvider<bool>((ref) {
  return false;
});

/// bad idea refactor later
final runPaywallSubroutineForVendorErrorProv = StateProvider<bool>((ref) {
  return false;
});

// final stripeClientCustomerIdProv = StateProvider<String?>((ref) {
//   return null;
// });


final showedRecentPaywallSheet = StateProvider<bool>((ref) => false);

void triggerPaywallTrigger(WidgetRef ref) {
  ref.read(showedRecentPaywallSheet.notifier).state = true;

  // Schedule unset without keeping ref
  Future.delayed(const Duration(seconds: 8), () {
    ref.read(showedRecentPaywallSheet.notifier).state = false;
  });
}


/// web migrations ones ....

final revcatAppUserIdProv = StateProvider<String?>((ref) => null);
// final userIsPremiumProv = StateProvider<bool>((ref) => false);

final vendorHasSubscriptionProv = StateProvider<bool>((ref) => false);