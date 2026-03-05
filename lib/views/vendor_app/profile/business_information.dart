import 'dart:async';
import 'package:connectme_app/components/ui/modals/error_dialog.dart';
import 'package:connectme_app/components/ui/modals/use_suggested_address_dialog.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/models/user/vendor_user_meta.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/requests/location/location.dart';
import 'package:connectme_app/requests/user/user_meta.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class BusinessInformation extends ConsumerStatefulWidget {
  const BusinessInformation({super.key});

  @override
  ConsumerState<BusinessInformation> createState() => _BusinessInformationState();
}

class _BusinessInformationState extends ConsumerState<BusinessInformation> {

  // String? userName;
  String? businessName;
  String? email;
  String? phone;
  String? address;
  String? website;
  String? bio;

  // Editing states
  Map<String, bool> isEditing = {
    // 'userName': false,
    'businessName': false,
    'email': false,
    'phone': false,
    'address': false,
    'website': false,
    'bio': false,
  };

  // Controllers
  // late TextEditingController userNameController;
  late TextEditingController businessNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController websiteController;
  late TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    lg.t("business_information init state");


    scheduleMicrotask(()async{
      await getUserMeta(
          ref.read(userAuthProv)!.userId,
          // ref.read(userAuthProv)!.userToken
      ).then((resp){
        if (resp["success"] == true){
          lg.t("got user meta set controllers");
          ref.read(vendorUserMetaProv.notifier).state = VendorUserMeta.fromJson(resp["data"]);
        }
      });
    });



    // userNameController = TextEditingController(text: ref.read(userAuthProv)!.userName??"");
    businessNameController = TextEditingController(text: ref.read(vendorUserMetaProv)!.businessName??"");
    emailController = TextEditingController(text: ref.read(vendorUserMetaProv)!.email??"");
    phoneController = TextEditingController(text: ref.read(vendorUserMetaProv)!.phone??"");
    addressController = TextEditingController(text: ref.read(vendorUserMetaProv)!.address??"");
    websiteController = TextEditingController(text: ref.read(vendorUserMetaProv)!.website??"");
    bioController = TextEditingController(text: ref.read(vendorUserMetaProv)!.bio??"");
  }

  @override
  void dispose() {
    // userNameController.dispose();
    businessNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    websiteController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Widget _buildEditableTile({
    required String label,
    required String fieldKey,
    required String? value,
    required TextEditingController controller
  }) {
    final editing = isEditing[fieldKey] ?? false;

    return ListTile(
      title: Text(label,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: editing
          ? TextField(
        style: Theme.of(context).textTheme.bodySmall,
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText:"..."
          // labelText:"..."
        ),
        onSubmitted: (newValue) {
          setState(() {
            isEditing[fieldKey] = false;
            switch (fieldKey) {
              // case 'userName':
              //   userName = newValue;
              //   break;
              case 'businessName':
                businessName = newValue;
                break;
              case 'email':
                email = newValue;
                break;
              case 'phone':
                phone = newValue;
                break;
              case 'address':
                address = newValue;
                break;
              case 'website':
                website = newValue;
                break;
              case 'bio':
                bio = newValue;
                break;
            }
          });
        },
        onEditingComplete: () async{

          lg.d("[BusinessInformation form] onEditingComplete called");

          setState(() => isEditing[fieldKey] = false);
        },
      )
          : Text(value??""),
      trailing:
      isEditing[fieldKey] == false?
      IconButton(
        icon: Icon(Icons.edit_outlined,
          size:14.sr,
        ),
        onPressed: () {
          setState(() {
            isEditing[fieldKey] = true;
          });
        },
      ):
      IconButton(
        icon: Icon(Icons.save_alt,
          size:14.sr,
        ),
        onPressed: () async {
          lg.d("[BusinessInformation form] save field called");
          if (fieldKey == "address"){
            lg.d("[BusinessInformation form] save address");
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );

            var resp;
            try {
              resp = await lookupSuggestedAddress(addressController.text);
            }catch(e){
              Navigator.pop(gNavigatorKey.currentContext!);
              showErrorDialog(gNavigatorKey.currentContext!, "Something went wrong with address lookup. Please try again later.");
            }

            lg.t("lookup address resp");
            if (resp.containsKey("display_name")) {
              lg.t("found results");
              Navigator.pop(gNavigatorKey.currentContext!); /// pop main loading spinner

              await showUseSuggestedAddressDialog(gNavigatorKey.currentContext!, resp, ()async{
                                  lg.d("Set address controller");
                                  addressController.text = resp["display_name"];
                                  VendorUserMeta existing = ref.read(
                                      vendorUserMetaProv)!;
                                  GeoHasher geoHasher = GeoHasher();
                                  String geoHash = geoHasher.encode(
                                       double.parse(resp["lon"]), double.parse(resp["lat"]));
                                  VendorUserMeta updated = existing.copyWith(
                                    address: resp["display_name"],
                                    geoHash: geoHash,
                                    location: {
                                      "lat": resp["lat"],
                                      "lng": resp["lon"]
                                    },
                                  );
                                  ref.read(vendorUserMetaProv.notifier).state = updated;
                                  Navigator.pop(context);

                                  },
                                      ()async {
                                  addressController.text = "";
                                  Navigator.pop(context);

                                         }
              );

            }else{
              lg.t("didnt find results");
              addressController.text = "";
              Navigator.pop(gNavigatorKey.currentContext!); /// pop main loading spinner
              showErrorDialog(gNavigatorKey.currentContext!, "Address not found");
            }
          }

          VendorUserMeta existing = ref.read(vendorUserMetaProv)!;
          VendorUserMeta updated = existing.copyWith(
            // userType: ref.read(userTypeProv)!,
            businessName:businessNameController.text==""?null:businessNameController.text,
            email:emailController.text==""?null:emailController.text,
            phone:phoneController.text==""?null:phoneController.text,
            address:addressController.text==""?null:addressController.text,
            website:websiteController.text==""?null:websiteController.text,
            bio:bioController.text==""?null:bioController.text,
          );
          lg.d("[BusinessInformation form] updated ~ " + updated.toString());
          ref.read(vendorUserMetaProv.notifier).state = updated;
          lg.d("calling updateUserMeta");
          updateUserMeta(ref); /// don't await

          // TODO transfer functions from old username to new username looks like only for messaging right now
          /// check if we need to do username update
          // if (userNameController.text != ref.read(userAuthProv)!.userName){
          //   updateUserName(ref, userNameController.text); /// don't await
          // }


          setState(() {
            isEditing[fieldKey] = false;
          });
        },
      )
      ,
    );
  }

  @override
  Widget build(BuildContext context) {

    // userName =ref.watch(userAuthProv)!.userName;
    businessName =ref.watch(vendorUserMetaProv)!.businessName ??
        businessName;
    email = ref.watch(vendorUserMetaProv)!.email ??
        email;
    phone = ref.watch(vendorUserMetaProv)!.phone ??
        phone;
    address = ref.watch(vendorUserMetaProv)!.address ??
        address;
    website = ref.watch(vendorUserMetaProv)!.website ??
        website;
    bio = ref.watch(vendorUserMetaProv)!.bio ??
        bio;

    // businessNameController.text = businessName;
    // emailController.text = email;
    // phoneController.text = phone??null;
    // addressController.text = address;
    // websiteController.text = website;
    // bioController.text = bio;


    return Scaffold(
      appBar: AppBar(title: const Text('Business Information')),
      body: ListView(
        children: [
          SizedBox(height: Gss.height * .03,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Gss.width * .03),
          child:Text("Provide your business details to display on your profile and to use for listing services",
            style: Theme.of(context).textTheme.bodyLarge,
          )),
          SizedBox(height: Gss.height * .02,),

          _buildEditableTile(
            label: 'Business Name*',
            fieldKey: 'businessName',
            value: businessName,
            controller: businessNameController,
          ),
          _buildEditableTile(
            label: 'Email',
            fieldKey: 'email',
            value: email,
            controller: emailController,
          ),
          _buildEditableTile(
            label: 'Phone Number',
            fieldKey: 'phone',
            value: phone,
            controller: phoneController,
          ),
          _buildEditableTile(
            label: 'Address',
            fieldKey: 'address',
            value: address,
            controller: addressController,
          ),
          _buildEditableTile(
            label: 'Website',
            fieldKey: 'website',
            value: website,
            controller: websiteController,
          ),
          _buildEditableTile(
            label: 'Bio',
            fieldKey: 'bio',
            value: bio,
            controller: bioController,
          ),
        ],
      ),
    );
  }
}
