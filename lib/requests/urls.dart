import 'package:connectme_app/config/settings.dart';

/// unsecured ping /// UP (FINE) maybe rate limit overall
/// unsecured write /// UW (RISK) need rate limit overall
/// unsecured read /// UR (FINE) no issue hardly rate limit overall ** could probably be S but how much worse than a ping is it??? **
/// secured write /// SW (OK) no issue
/// secured read /// SR (OK) no issue
/// not for server /// NFS (OK) no issue (do not call from API)


String terms_of_service_url = appConfig.server_url + "/termsOfService"; /// UR
String privacy_policy_url = appConfig.server_url + "/privacyPolicy"; /// UR

String test_user_password_url = appConfig.server_url + "/testUserAuth"; /// UR

String test_post_request_url = appConfig.server_url + "/test_post_req"; /// UP


String user_create_account_firebase_url = appConfig.server_url + "/createAccountFirebaseToken"; /// SW
String user_login_with_google_url = appConfig.server_url + "/loginWithGoogle"; /// SW
String get_account_sub_url = appConfig.server_url + "/getUserAccountSubscription";
String update_user_account_sub_url =  appConfig.server_url + "/updateUserAccountSub";

// String user_login_track_meta = appConfig.server_url + "/trackMeta"; /// UW

String bookings_url = appConfig.server_url + "/getBookings"; /// SR
String create_booking_url = appConfig.server_url + "/createBooking"; /// SW
String confirm_booking_and_pay_url = appConfig.server_url + "/confirmBookingAndPay"; /// SW
String cancel_booking_url = appConfig.server_url + "/cancelBooking"; /// SW
String get_booking_by_id_url = appConfig.server_url + "/getBookingByID"; /// SR


String services_url = appConfig.server_url + "/getServices";  /// UR
String remote_services_url = appConfig.server_url + "/getRemoteServices"; /// UR
String vendor_services_url = appConfig.server_url + "/getVendorServices"; /// UR
String create_service_url = appConfig.server_url + "/createNewService"; /// SW
String delete_service_url = appConfig.server_url + "/deleteService" ; /// SW

String image_upload_url = appConfig.server_url + "/uploadImages"; /// SW

String get_user_meta_url = appConfig.server_url + "/getUserMeta"; /// UR
String update_user_meta_url = appConfig.server_url + "/updateUserMeta"; /// SW

String get_message_threads_url = appConfig.server_url + "/getMessageThreads"; /// SR
String get_or_create_thread_url = appConfig.server_url + "/getOrCreateThread"; /// SW
String get_messages_url = appConfig.server_url + "/getMessages"; /// SR
String send_message_url = appConfig.server_url + "/sendMessage"; /// SW
String block_message_thread_url = appConfig.server_url + "/blockThread"; /// SW
String report_message_user_url = appConfig.server_url + "/reportMessageUser"; /// SW
String mark_thread_read_url = appConfig.server_url + "/markThreadAsRead"; /// SW

String save_provider_url = appConfig.server_url + "/saveProvider"; /// SW
String get_saved_providers_url = appConfig.server_url + "/getSavedProviders"; /// SR


String get_stripe_vendor_account_status_url = appConfig.server_url + "/getVendorStripeAccountStatus"; /// SR
String create_stripe_vendor_onboarding_url = appConfig.server_url + "/createVendorStripeAccountOnboarding"; /// SW
String stripe_vendor_onboard_redirect_url = appConfig.appUrl + "/#/stripeVendorOnboardRedirectUrl"; /// NFS
String stripe_vendor_onboard_refresh_url = appConfig.appUrl + "/#/stripeVendorOnboardRefreshUrl";  /// NFS
String get_vendor_stripe_dashboard_url = appConfig.server_url + "/getVendorStripeDashboardUrl"; /// SR

String facebook_login_redirect_url = appConfig.appUrl + "/#/__/auth/handler";
// https://connectme-app-11465.firebaseapp.com/__/auth/handler

String create_stripe_client_customer_url = appConfig.server_url + "/createClientStripeCustomer"; /// SW
String create_client_stripe_checkout_setup_session =  appConfig.server_url + "/createClientStripeCheckoutSetupSession"; /// SW
String get_stripe_client_setup_status_url = appConfig.server_url + "/getClientStripeSetupStatus"; ///SR

// String make_client_stripe_payment_url = appConfig.server_url + "/makeClientStripePayment"; /// huge security risk cannot do this
// String get_transaction_details_url = appConfig.server_url + "/getTransactionStripeAccountDetails"; /// huge security risk cannot do this


String create_review_url = appConfig.server_url + "/createRating"; ///SW
String get_reviews_url = appConfig.server_url + "/getRatings"; /// SR
String get_ratings_for_service_url = appConfig.server_url + "/getServiceRatings"; /// SR
String get_ratings_for_vendor_url = appConfig.server_url + "/getVendorRatings"; /// SR

/// needs to be refactored to provider somewhere anyway
String get_vendor_ratings_agg_url = appConfig.server_url + "/getVendorRatingsAgg"; /// UR

String get_base_availability_url = appConfig.server_url + "/getBaseAvailability"; /// UR
String set_base_availability_url = appConfig.server_url + "/setBaseAvailability"; /// SW

String get_payments_history_url = appConfig.server_url + "/getPaymentsHistory"; /// SR

String delete_user_account_url = appConfig.server_url + "/deleteUserAccount"; /// SW