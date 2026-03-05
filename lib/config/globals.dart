

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


//import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

// global screen size
Size Gss = const Size(0, 0);
// applicationDocumentsDirectory
// String appDocsDir = "";


// final iap = FlutterInappPurchase();

const List<String> scopes = <String>[
  'email',
  // 'https://www.googleapis.com/auth/contacts.readonly',
];

/// Google Auth things
/// https://developers.google.com/android/reference/com/google/android/gms/common/api/CommonStatusCodes
GoogleSignIn googleSignIn = GoogleSignIn(
  // scopes: scopes,
  // clientId: "631708018726-asci0805k32h4i7vvnpv94avfk57j80c.apps.googleusercontent.com"
  // clientId: "631708018726-5buq7lvhsoqcqr98hmnesrt5iuu7vrbl.apps.googleusercontent.com"
);


/// Firebaee options in lib/firebase_options.dart for now
final firebase_auth_inst = FirebaseAuth.instance;


/// for home tab and bookings tab so far
ScrollController homeScrollController = ScrollController();
ScrollController bookingUpcomingScrollController =  ScrollController();
ScrollController bookingPastScrollController =  ScrollController();

final scrollControllerProvider = StateProvider<ScrollController>(
      (ref) => homeScrollController);


/// only needed here for now ( also in logout I think)
final GlobalKey<NavigatorState> gNavigatorKey = GlobalKey<NavigatorState>();