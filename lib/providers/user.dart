import 'dart:async';

import 'package:connectme_app/config/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';




Future<String?> getFirebaseProfileImageUrl(String userId)async{
    try {
      lg.t("getFirebaseProfileImageUrl called w userId ~ " + userId);
      final storageRef = FirebaseStorage.instance.ref().child(
          'profile_images/$userId.jpg');
      final url = await storageRef.getDownloadURL().timeout(Duration(seconds:15));
      lg.t("getFirebaseProfileImageUrl returning ~  " + url.toString());
      return url;
    }catch(e){
      lg.t("getFirebaseProfileImageUrl return null");
      return null;
    }

}

final profileImageUrlProvider = AsyncNotifierProvider.family<
    ProfileImageUrlNotifier, String?, String>(
      () => ProfileImageUrlNotifier(),
);

class ProfileImageUrlNotifier extends FamilyAsyncNotifier<String?, String> {
  @override
  Future<String?> build(String userId) async {

    try {
      lg.t("ProfileImageUrlNotifier called");
      return await getFirebaseProfileImageUrl(userId);
    } catch (e) {
      lg.t("ProfileImageUrlNotifier retturn null");
      // Return null on error (e.g., no image uploaded)
      return null;
    }
  }

  void setUrl(String? newUrl) {
    state = AsyncValue.data(newUrl);
  }

  Future<void> refresh(String userId) async {
    state = const AsyncValue.loading();
    // Run the build() method safely and update state with data or error
    state = await AsyncValue.guard(() => build(userId));
  }

  Future<void> setLoading() async {
    state = const AsyncValue.loading();
  }
}