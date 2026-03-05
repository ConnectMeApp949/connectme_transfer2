import 'package:connectme_app/models/app/config.dart';
import 'package:connectme_app/models/user/etc.dart';



/// sandbox needs config
String revenueCatWebApiKey_SANDBOX = "rcb_sb_zWbgCDLGBodZSODjIewoVQunB";
// String revenueCatWebApiKey_LIVE = "rcb_iCqPIgNWserLLQgEoGywkwDHtlQx";
String revenueCatWebApiKey = revenueCatWebApiKey_SANDBOX;

/// sandbox needs config
String stripeApiKey_SANDBOX = "pk_test_51RhhGoEJGpZQS0Pwxlc8brLhKQupZtgEvdpyjVT9LsQX9AKTnPRGwXsn9bifIJvMm5GKbO3HpAv21gpHOdIOArKE00yQopwiAd";
String stripeApiKey_LIVE = "pk_live_51RhhGjEDMzT93NEkxkSJ9jdUcGP6eKrM8HZ5sNMSl0gYjVKoFxwN0ssos1HBv2DZeWsBlyaJ1TspksKxWWPq52xZ00x0ftdZ9y";
String stripeApiKey = stripeApiKey_SANDBOX;

/// ***********************************
/// Can leave for release
/// ***********************************
///

/// sandbox set through google play internal testing
String revenuecatAndroidApiKey = "goog_QkWRhLNLADZNrFpJRbzaXkUJfdw";

/// sandbox set through testflight
String revenueCatIOSApiKey = "appl_ehJjaZvwNZTWRwHmlRVMAlZmMEh";

/// Entitlement ID
const vendorBasicAccountEntitlementID = "Basic Vendor Account";

/// in firebase user doc
const vendorBasicAccountLevelID = "vendor_basic";

const vendorBasicProductsAndroid = ["vendor_basic_annual", "vendor_basic_monthly"];
const vendorBasicProductsIos = ["vendor_basic_monthly_2", "vendor_basic_annual_2"];

/// Firebase Hosting deploy URL
/// only supports HTTPS no HTTP fallback
String firebaseHostingDeployURL = "https://connectme-app-11465.web.app";
/// Legacy supports HTTP fallback
// String firebaseHostingDeployURL = "https://connectme-app-11465.firebaseapp.com";

/// dev ~ http://127.0.0.1:5001/connectme-app-11465/us-central1
/// android emulator ~ https://10.0.2.2:
/// device ~ https://10.0.1.13
String iosMobileLocal_ServerBaseDomain = "172.17.0.1"; /// *Not standard* this address is for running docker-osx

// String androidMobileLocal_ServerBaseDomain = "10.0.2.2"; /// Emulator
String androidMobileLocal_ServerBaseDomain = "10.0.1.3"; /// Device (Seems to have been working for emulator too...)


String webLocalBaseDomain = "127.0.0.1";



String cmapp_firebase_local_server_port = "5001";
String cmapp_firebase_local_storage_port = "9199";
String cmapp_firebase_local_web_url_port = "55156"; /// set port on flutter run --web-port



/// dev android emulator firebase emulator
late AppConfig appConfig;
late String cmapp_local_server_base_domain;


int vendorServicesLimit = 7;
int serviceImageLimit = 5;
int gServiceKeywordLimit = 100;


String noEmailHashSeedPlaceholderEmail = "notfoundemail@placeholder.com";

/// Sync in python settings.py
int millisInMinute = 60000;
int sandboxMonthMillis = millisInMinute * 3;
int monthMillis = 2629746000;
int sandboxYearMillis = millisInMinute * 5;
int yearMillis = 31556952000;


class TestUser{
  TestUser(this.un, this.uid, this.ut, this.ue, this.utype);
  String un;
  String uid;
  String ut;
  String ue;
  UserType utype;
}

/// test login client
TestUser clientTestUser = TestUser("Caroline",
    "cp5t39isqq0euy7sgkrw4u7l",
    "c3bickid3dmr2ivodnby84b56sz5btoc",
    "c_test_email@connectme.dev",
    UserType.client
);

/// test login vendor
TestUser vendorTestUser = TestUser("Vanessa",
    "vp5t39isqq0euy7sgkrw4u7l",
    "v3bickid3dmr2ivodnby84b56sz5btov",
    "v_test_email@connectme.dev",
    UserType.vendor
);


/// dangerous safe user
/// use for logout at this point, having issues with navigator
/// navigator is behaving on its own making race conditions again
/// when I clear app for logout, it tries to push back to home page from main build
/// even though I push first from calling fn
/// so only use dangerous safe user when you know it will be reset

TestUser dangerousSafeUser = TestUser("",
    "",
    "",
    "",
    UserType.client
);


