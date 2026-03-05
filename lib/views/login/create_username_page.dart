import 'dart:io';
import 'package:connectme_app/components/ui/buttons/rounded_outline_button.dart';
import 'package:connectme_app/components/ui/modals/error_dialog.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/config/settings.dart';
import 'package:connectme_app/methods/etc.dart';
import 'package:connectme_app/models/user/etc.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/requests/login/login.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/util/regexp.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:connectme_app/views/etc/loading_screen.dart';
import 'package:connectme_app/views/onboarding/welcome_screen.dart';
import 'package:connectme_app/views/strings/ui_message_strings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:purchases_flutter/purchases_flutter.dart';



class CreateUsernamePage extends ConsumerStatefulWidget {
  const CreateUsernamePage({super.key,
    // required this.googleSignInAccount,
    // required this.googleSignInAuthentication
    required this.federatedUserId
  });

  final String federatedUserId;

  // final GoogleSignInAccount? googleSignInAccount;
  // final GoogleSignInAuthentication? googleSignInAuthentication;

  @override
  CreateUsernamePageState createState() => CreateUsernamePageState();
}

class CreateUsernamePageState extends ConsumerState<CreateUsernamePage> {

  TextEditingController newNameController = TextEditingController();

   UserType? selectedUserType;

   @override
  void initState() {
    super.initState();
    lg.t("[CreateUsernamePageState] init state called");
  }

  @override
  void dispose() {
    newNameController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {


    if (!kIsWeb) {
      if (Platform.isIOS) {
     manageOrCancelString = " Manage or Cancel: Anytime in your Apple Account settings";
      }
      if (Platform.isAndroid) {
        manageOrCancelString = " Manage or Cancel: Anytime in profile settings";
      }
    }
    else{
        manageOrCancelString = " Manage or Cancel: Anytime in profile settings";
    }

    return Scaffold(
      body:
      ListView(
          shrinkWrap: true,
          children:[
            Padding(
              padding: EdgeInsets.symmetric(vertical: .038.sh),
            ),
            //
            // Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children:[
            //       // ReversibleBrightnessImage(
            //       //     imagePath: "assets/images/connectme_logo.png",
            //       //     size: Size(.5.sw, .5.sw)),
            //       // ))
            //     ]),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 12.sr),
            // ),
            // Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children:[
            //       Container(height: 18.sr,
            //           child: Text("Welcome to ConnectMe", style: TextStyle(fontSize: 15.sr),))]),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 12.sr),
            // ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Container(
                      child: Text("Choose Account Type", style: TextStyle(fontSize: 18.sr, fontWeight: FontWeight.bold),))]),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.sr),
            ),

            Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.sr), /// increasing kills borders
                child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:[

                      InkWell(
                          onTap: (){
                            setState(() {
                              selectedUserType = UserType.client;
                            });
                          },child:
                      Container(
                          width: Gss.width*.4,
                          height: Gss.width*.3,
                          decoration: BoxDecoration(
                              border: selectedUserType == UserType.client?
                              Border.all(color: appPrimarySwatch, width: 2):
                              Border.all(color: Theme.of(context).textTheme.bodyMedium!.color!, width: 1),
                              color:  selectedUserType == UserType.client?
                              appPrimarySwatch.withValues(alpha:0.2):null,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxWidth:  Gss.width*.38,),
                                child:Text("I am seeking Services",
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  style: TextStyle(fontSize: 16.sr,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )))),

                      InkWell(
                          onTap: (){
                            setState(() {
                              selectedUserType = UserType.vendor;
                            });
                          },
                          child:Container(
                            decoration: BoxDecoration(
                                border: selectedUserType == UserType.vendor?
                                Border.all(color: appPrimarySwatch, width: 2):
                                Border.all(color: Theme.of(context).textTheme.bodyMedium!.color!, width: 1),
                                color:  selectedUserType == UserType.vendor?
                                appPrimarySwatch.withValues(alpha:0.2):null,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            width: Gss.width*.4,
                            height: Gss.width*.3,
                            child:Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth:  Gss.width*.38,),
                                  child:Text("I am a Service Vendor",
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: TextStyle(fontSize: 16.sr,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ))
                          )),


                    ])),

            Padding(
              padding: EdgeInsets.symmetric(vertical: .03.sh),
            ),

            selectedUserType == UserType.client?
            Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.sr),
            child:
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Container(
                      child: Text("Free Account", style: TextStyle(fontSize: 15.sr, fontWeight: FontWeight.bold),))])):
            selectedUserType == UserType.vendor?
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.sr),
                child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Flexible(
                      child: Text("Vendor Account: \$9.99/mo or \$99.99/year", style: TextStyle(fontSize: 18.sr, fontWeight: FontWeight.bold),))]))
                :Container(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: .01.sh),
            ),
            // selectedUserType == UserType.vendor?
            // Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 12.sr),
            //     child:Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children:[
            //           Flexible(
            //               child: Text(" Vendor access to ConnectMe App.", style: TextStyle(fontSize: 15.sr),))]))
            //     :Container(),

            selectedUserType == UserType.vendor?
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.sr, vertical: 4.sr),
                child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                      Flexible(
                          child: Text("◦ Free Trial: First month free for new users", style: TextStyle(fontSize: 13.sr),))]))
                :Container(),

            selectedUserType == UserType.vendor?
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.sr, vertical: 4.sr),
                child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                      Flexible(
                          child: Text("◦ Includes", style: TextStyle(fontSize: 13.sr),))]))
                :Container(),

            selectedUserType == UserType.vendor?
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.sr, vertical: 4.sr),
                child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                      Flexible(
                          child: Text("   - Vendor profile listing and marketplace visibility", style: TextStyle(fontSize: 13.sr),))]))
                :Container(),

            selectedUserType == UserType.vendor?
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.sr, vertical: 4.sr),
                child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                      Flexible(
                          child: Text("   - Booking and calendar management tools", style: TextStyle(fontSize: 13.sr),))]))
                :Container(),

            selectedUserType == UserType.vendor?
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.sr, vertical: 4.sr),
                child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                      Flexible(
                          child: Text("   - Payment processing and transaction tracking", style: TextStyle(fontSize: 13.sr),))]))
                :Container(),

            selectedUserType == UserType.vendor?
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.sr, vertical: 4.sr),
                child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                      Flexible(
                          child: Text("   - Customer reviews and messaging features", style: TextStyle(fontSize: 13.sr),))]))
                :Container(),

            selectedUserType == UserType.vendor?
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.sr, vertical: 4.sr),
                child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                      Flexible(
                          child: Text("◦ Auto-Renewal: Automatically renews each period unless canceled before renewal", style: TextStyle(fontSize: 13.sr),))]))
                :Container(),

            selectedUserType == UserType.vendor?
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.sr, vertical: 4.sr),
                child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                      Flexible(
                          child: Text("◦ ${manageOrCancelString}", style: TextStyle(fontSize: 13.sr),))]))
                :Container(),

            Padding(
              padding: EdgeInsets.symmetric(vertical: .03.sh),
            ),

            selectedUserType != null?
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Container(
                      child: Text("Create Display Name", style: TextStyle(fontSize: 18.sr, fontWeight: FontWeight.bold),))])
            :Container()
            ,

            Padding(
              padding: EdgeInsets.symmetric(vertical: .01.sh),
            ),

            // selectedUserType == UserType.client?
            // Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 12.sr),
            //     child:Row(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         children:[
            //           Flexible(
            //               child: Text("Service Seekers: ", style: TextStyle(fontSize: 16.sr, fontWeight: FontWeight.w600)))]))
            // :Container(),

            selectedUserType == UserType.client?
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.sr),
                child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Flexible(
                          child: Text("This is the name you will use to book services with", style: TextStyle(fontSize: 16.sr)))]))

            :Container(),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.sr),
            ),

            // selectedUserType == UserType.vendor?
            // Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 12.sr),
            //     child:Row(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         children:[
            //           Flexible(
            //               child: Text("Vendors: ", style: TextStyle(fontSize: 16.sr, fontWeight: FontWeight.w600)))])):
            // Container(),

            selectedUserType == UserType.vendor?
            Padding(
    padding: EdgeInsets.symmetric(horizontal: 12.sr,),
            child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Flexible(
                      child: Text("Choose a personal Display Name. Additionally, you will be able to add a Business Name as well later.", style: TextStyle(fontSize: 16.sr)))]))
            :Container(),



            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.sr),
            ),

            selectedUserType != null?
            Container(
              // color: Colors.blue,
              // width: .88.sw,
              // height: .12.sw,
                child:Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.sr),
                    child:TextField(
                      // maxLines: 2,
                      maxLength: 64,
                      controller: newNameController,
                      decoration: InputDecoration(
                          hintText: "Your Display Name",
                          hintStyle: TextStyle(fontSize: 14.sr)
                      ),
                    )))
            :Container(),

            Padding(
              padding: EdgeInsets.symmetric(vertical: .03.sh),
            ),

            selectedUserType != null?
            Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 8.sr, vertical: 16.sr),
                child: RoundedOutlineButton(
                    width: .55.sw,
                    paddingVertical: 12.sr,
                    onTap: () async {
                      lg.d("[CreateUsernamePage submit onTap] calld");


                      String un_input = newNameController.text;
                      var ulnv = userLoginNameValidate(un_input);

                      if (!ulnv[0]) {
                        showErrorDialog(context, ulnv[1]);
                        return;
                      }

                      if (selectedUserType == null) {
                        showErrorDialog(context, "Please select an account type");
                        return;
                      }

                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return const LoadingScreen(
                          descriptionMain: "Creating Account",
                          descriptionSub: "One second please...",
                          noUseItemUploadCounter: true,
                        );
                      }));

                      lg.d("[CreateUsernamePage submit onTap] get jwt");

                      String? get_jwt_id_token = await firebase_auth_inst.currentUser!.getIdToken();

                      /// I think they pretty much have to have email to get to this point ?
                      String get_user_email =  firebase_auth_inst.currentUser!.email??"no_email";

                      if(get_jwt_id_token == null){
                        /// pop the loading screen
                        NavigatorPop_MountedSafe(gNavigatorKey.currentContext!);
                        showErrorDialog(gNavigatorKey.currentContext!, default_error_message);
                        return;
                      }
                      lg.d("[CreateUsernamePage submit onTap] got jwt token");

                      var userCreateAccountFirebaseResponse;
                      try {
                        final deviceInfoPlugin = DeviceInfoPlugin();
                        final deviceInfo = await deviceInfoPlugin.deviceInfo;

                        String platform_desc_string = "unknownPlatformString";
                        try {
                          if (!kIsWeb){
                          if ( Platform.isIOS){ platform_desc_string = "ios";}
                          if ( Platform.isAndroid){ platform_desc_string = "android";}
                          }
                          else{
                            platform_desc_string = "web";
                          }
                          deviceInfo.data.forEach((k,v){
                            platform_desc_string += k .toString() + v.toString();

                            lg.t("device data key ~ " + k.toString());
                            lg.t("device data value ~ " + v.toString());
                          });
                        }catch(e){
                          lg.w("Couldnt get platform description for platform_desc_string");
                        }

                        userCreateAccountFirebaseResponse = await userPostCreateAccountFirebase(
                            // gNavigatorKey.currentContext!,
                          ref,
                          un_input,
                          get_user_email,
                          selectedUserType!.name,
                          // widget.googleSignInAccount!.id,
                          platform_desc_string,
                          widget.federatedUserId,
                          get_jwt_id_token,
                            appConfig
                        );
                      }
                      catch (e) {
                        NavigatorPop_MountedSafe(gNavigatorKey.currentContext!);
                        showErrorDialog(gNavigatorKey.currentContext!, e.toString());
                        return;
                      }

                      /// failure dialogs handled by userPostCreateAccountFirebase

                     /// Send to onboarding
                    if (userCreateAccountFirebaseResponse["success"] == true) {
                      lg.t("ucafbr success start paywall check");
                      NavigatorPop_MountedSafe(gNavigatorKey.currentContext!); /// pop Creating Account loading screen, other pops are all for errors

                      if (userCreateAccountFirebaseResponse["data"]["userType"] == "client") {

                        Navigator.of(gNavigatorKey.currentContext!).push(MaterialPageRoute(builder: (context) {
                          return  AnimatedIntroScreen(userId: userCreateAccountFirebaseResponse["data"]["userId"],
                          userType: UserType.client
                          );
                        }));

                      }

                      if (userCreateAccountFirebaseResponse["data"]["userType"] == "vendor") {
                        Navigator.of(gNavigatorKey.currentContext!).push(MaterialPageRoute(builder: (context) {
                          return  AnimatedIntroScreen(userId: userCreateAccountFirebaseResponse["data"]["userId"],
                              userType: UserType.vendor
                          );
                        }));
                      }
                    }

                    },
                    label: "Submit"))
            :Container(),



            Padding(
              padding: EdgeInsets.symmetric(vertical: .03.sh),
            ),

            Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 8.sr, vertical: 16.sr),
                child: RoundedOutlineButton(
                    width: .55.sw,
                    paddingVertical: 12.sr,
                    onTap: () async {
                      lg.t("[createUserName cancel] tap");

                      // await userLogoutFirebase();
                      // Phoenix.rebirth(context); /// Decided to do this at some point and should have said why then, I think it's so Purchases gets re called to query entitlements but not sure
                      callNewLogoutForSomeStpdReason(gNavigatorKey.currentContext!, ref);
                      // Navigator.pushNamedAndRemoveUntil(
                      //     context, "/login", (route) => false);

                    },
                    label: "Cancel")),

          ]),
    );
  }
}

