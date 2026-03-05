import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/user.dart';
import 'package:connectme_app/util/image_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectme_app/platform_bridge/platform_bridge.dart';

updateProfileImage(WidgetRef ref)async{
  String userId = ref.read(userAuthProv)!.userId;
    final imageBytes = await pickImageAndConvertToJpeg();
    if (imageBytes != null) {
      ref.read(profileImageUrlProvider(userId).notifier).setLoading();
      // String? download_url_data =
      await uploadToFirebaseAndGetDownloadURL(
          userId,
          ref.read(userAuthProv)!.userToken,
          {"profile_images/" + ref.read(userAuthProv)!.userId + ".jpg":imageBytes});
    }
    ref.invalidate(profileImageUrlProvider( userId));
}