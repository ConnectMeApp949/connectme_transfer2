import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectme_app/models/user/user_auth.dart';
import 'package:connectme_app/models/user/client_user_meta.dart';
import 'package:connectme_app/models/user/vendor_user_meta.dart';


final userAuthProv = StateProvider<UserAuth?>((ref) {
  return null;
});


final clientUserMetaProv = StateProvider<ClientUserMeta?>((ref) {return null;});


final vendorUserMetaProv = StateProvider<VendorUserMeta?>((ref) {return null;});

