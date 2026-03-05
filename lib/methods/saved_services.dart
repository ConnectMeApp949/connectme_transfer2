
import 'package:connectme_app/providers/etc.dart';

updateSavedServices(ref, String vendorUserId, {bool? remove}) async {
  final notifier = ref.read(savedServiceProviderProv.notifier);

  if (remove == true) {

    notifier.state = notifier.state
        .whereType<String>()
        .where((e) => e != vendorUserId)
        .toList();

  } else {

    notifier.state = <String>[
      ...notifier.state.whereType<String>(),
      vendorUserId,
    ];

  }

  // var updatedSavedServces = await saveProvider(
  //     vendorUserId,
  //     remove,
  //     ref.read(userAuthProv)!.userId,
  //     ref.read(userAuthProv)!.userToken
  // );
}