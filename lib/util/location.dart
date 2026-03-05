

import 'package:connectme_app/components/ui/buttons/rounded_outline_button.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/models/user/etc.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/requests/user/user_meta.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';



convDistanceStandardToMetricInt(String? input_user){
  String? input;
  if (input_user!=null){
    input = input_user.replaceAll("+", "");
  }

  if (input == null){
      return null;
    }
    if (input == "any"){
      return null;
    }
    if (input == "5"){
      return 5;
    }
    if (input == "25"){
      return 39;
    }
    if (input == "100"){
      return 156;
    }
    if (input == "750"){
      return 1250;
    }
    return null;
  }


convDistanceMetricToStandardInt(String? input_user){
  String? input;
  if (input_user!=null){
    input = input_user.replaceAll("+", "");}

  if (input == null){
    return null;
  }
  if (input == "any"){
    return null;
  }
  if (input == "5"){
    return 5;
  }
  if (input == "39"){
    return 25;
  }
  if (input == "156"){
    return 100;
  }
  if (input == "1250"){
    return 750;
  }
  return null;
}




getUserGeohash( WidgetRef ref, {int precision = 9}) async {
  lg.t("[getUserGeohash] called");
  bool serviceEnabled;
  LocationPermission permission;

  // Check location services
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }

  // Check permissions
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      lg.t("Location permissions are denied after requesting");
      throw Exception('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      lg.t("Location permissions are denied forever after requesting");
      throw Exception('Location permissions are denied');
    }
  }

  // Get current position
  final position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  lg.t("getUserGeohash position ~ " + position.toString());

  // Encode to geohash
  GeoHasher geoHasher = GeoHasher();
  final geohash = geoHasher.encode(position.longitude, position.latitude, precision: 9);

  if (ref.read(userTypeProv) == UserType.client){
    ref.read(clientUserMetaProv.notifier).state = ref.read(clientUserMetaProv)!
    .copyWith(geoHash: geohash,
              location: {"lat": position.latitude, "lng": position.longitude}
    );
  }
  if (ref.read(userTypeProv) == UserType.vendor){
    ref.read(vendorUserMetaProv.notifier).state = ref.read(vendorUserMetaProv)!
        .copyWith(geoHash: geohash,
        location: {"lat": position.latitude, "lng": position.longitude}
    );
  }

  if (ref.read(userAuthProv)!.userId != "Guest") {
    updateUserMeta(ref);
  }

  lg.t("getUserGeohash returning geohash ~ " + geohash);
  return geohash;

}


tryUpdateUserLocationServices(BuildContext context, WidgetRef ref){
      try {
        getUserGeohash(ref);
      }catch(e){
        showDialog(context: context, builder: (context) =>
            AlertDialog(
                title: Text("Location disabled"),
                content: Text("Please enable location services for Connectme app to use this feature."),
                actions: [
                  RoundedOutlineButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      label: "Ok"),
                ]));
      }
}