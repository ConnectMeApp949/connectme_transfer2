import 'dart:async';
import 'package:connectme_app/components/ui/modals/error_dialog.dart';
import 'package:connectme_app/components/ui/modals/use_suggested_address_dialog.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/methods/etc.dart';
import 'package:connectme_app/models/user/client_user_meta.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/requests/location/location.dart';
import 'package:connectme_app/requests/user/user_meta.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/util/location.dart';
import 'package:connectme_app/views/strings/ui_message_strings.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class ClientAddresses extends ConsumerStatefulWidget {
  const ClientAddresses({super.key});

  @override
  ConsumerState<ClientAddresses> createState() => _ClientAddressesState();
}

class _ClientAddressesState extends ConsumerState<ClientAddresses> {

  String? address;

  // Editing states
  Map<String, bool> isEditing = {
    // 'businessName': false,
    // 'email': false,
    // 'phone': false,
    'address': false,
    // 'website': false,
    // 'bio': false,
  };

  // Controllers
  // late TextEditingController businessNameController;
  // late TextEditingController emailController;
  // late TextEditingController phoneController;
  late TextEditingController addressController;
  // late TextEditingController websiteController;
  // late TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    lg.t("client addresses init state");


    scheduleMicrotask(()async{
      await getUserMeta(
        ref.read(userAuthProv)!.userId,
        // ref.read(userAuthProv)!.userToken
      ).then((resp){
        if (resp["success"] == true){
          lg.t("got user meta set controllers");
          ref.read(clientUserMetaProv.notifier).state = ClientUserMeta.fromJson(resp["data"]);
        }
      });
    });



    // businessNameController = TextEditingController(text: ref.read(vendorUserMetaProv)!.businessName??"");
    // emailController = TextEditingController(text: ref.read(vendorUserMetaProv)!.email??"");
    // phoneController = TextEditingController(text: ref.read(vendorUserMetaProv)!.phone??"");
    addressController = TextEditingController(text: ref.read(clientUserMetaProv)!.address??"");
    // websiteController = TextEditingController(text: ref.read(vendorUserMetaProv)!.website??"");
    // bioController = TextEditingController(text: ref.read(vendorUserMetaProv)!.bio??"");
  }

  @override
  void dispose() {
    // businessNameController.dispose();
    // emailController.dispose();
    // phoneController.dispose();
    addressController.dispose();
    // websiteController.dispose();
    // bioController.dispose();
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
      title:
      Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
      child: Text(label,
        style: Theme.of(context).textTheme.labelMedium,
      )),
      subtitle: editing
          ? TextField(
        style: Theme.of(context).textTheme.labelMedium,
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
              // case 'businessName':
              //   businessName = newValue;
              //   break;
              // case 'email':
              //   email = newValue;
              //   break;
              // case 'phone':
              //   phone = newValue;
              //   break;
              case 'address':
                address = newValue;
                break;
              // case 'website':
              //   website = newValue;
              //   break;
              // case 'bio':
              //   bio = newValue;
              //   break;
            }
          });
        },
        onEditingComplete: () async{
          lg.d("[ClientAddresses form] onEditingComplete called");
          setState(() => isEditing[fieldKey] = false);
        },
      )
          : Text(value??"",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing:
      isEditing[fieldKey] == false?
      IconButton(
        icon: Icon(Icons.edit_outlined,
          size:Theme.of(context).textTheme.titleLarge!.fontSize,
        ),
        onPressed: () {
          setState(() {
            isEditing[fieldKey] = true;
          });
        },
      ):
      IconButton(
        icon: Icon(Icons.save_alt,
          size:Theme.of(context).textTheme.titleLarge!.fontSize,
        ),
        onPressed: () async {

          if (fieldKey == "address"){

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );

            var resp = await lookupSuggestedAddress(addressController.text);

            lg.t("lookup address resp");
            if (resp.containsKey("display_name")) {
              lg.t("found results");
              Navigator.pop(gNavigatorKey.currentContext!);
              await showUseSuggestedAddressDialog(gNavigatorKey.currentContext!, resp, (){ lg.d("Set address controller");
              addressController.text = resp["display_name"];
              ClientUserMeta existing = ref.read(
                  clientUserMetaProv)!;
              GeoHasher geoHasher = GeoHasher();
              String geoHash = geoHasher.encode(
                  double.parse(resp["lon"]), double.parse(resp["lat"]));
              ClientUserMeta updated = existing.copyWith(
                address: resp["display_name"],
                geoHash: geoHash,
                location: {
                  "lat": resp["lat"],
                  "lng": resp["lon"]
                },
              );
              ref
                  .read(clientUserMetaProv.notifier)
                  .state = updated;
              Navigator.pop(context);},

                  ()async {
                  addressController.text = "";
                  Navigator.pop(context);
                }
              );
            }else{
              lg.t("didnt find results");
              addressController.text = "";
              Navigator.pop(gNavigatorKey.currentContext!);
              showErrorDialog(gNavigatorKey.currentContext!, "Address not found");
            }
          }

          ClientUserMeta existing = ref.read(clientUserMetaProv)!;
          ClientUserMeta updated = existing.copyWith(
            // userType: ref.read(userTypeProv)!,
            // businessName:businessNameController.text==""?null:businessNameController.text,
            // email:emailController.text==""?null:emailController.text,
            // phone:phoneController.text==""?null:phoneController.text,
            address:addressController.text==""?null:addressController.text,
            // website:websiteController.text==""?null:websiteController.text,
            // bio:bioController.text==""?null:bioController.text,
          );
          lg.d("[BusinessInformation form] updated ~ " + updated.toString());
          ref.read(clientUserMetaProv.notifier).state = updated;
          lg.d("calling updateUserMeta");
          updateUserMeta(ref);

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

    address = ref.watch(clientUserMetaProv)!.address ??
        address;

    return
     Scaffold(
      appBar: AppBar(title: const Text('Address'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: ListView(
        children: [
          SizedBox(height: Gss.height * .03,),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: Gss.width * .03),
              child:Text("Save your address for searching and booking.",
                style: Theme.of(context).textTheme.bodyLarge,
              )),
          SizedBox(height: Gss.height * .02,),

          // CheckboxListTile(
          //   title: const Text('Use Automatic Location?'),
          //   value: ref.watch(clientUseLocationServicesForSearchProv),
          //   onChanged: (newValue) {
          //
          //   },
          // ),

          _buildEditableTile(
            label: 'Address',
            fieldKey: 'address',
            value: address,
            controller: addressController,
          ),


      ListTile(
        title: Text("Search Location",
          style: Theme.of(context).textTheme.labelMedium,
        ),
          subtitle:
          Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child:
              Wrap(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              alignment: WrapAlignment.spaceEvenly,
                children: [
                ChoiceChip(
                    backgroundColor: Colors.grey[100],
                    selectedColor: appPrimarySwatch[300],
                  label:  Text('Use Location Services',
                  style: TextStyle(color: Colors.black),
                  ),
                  selected: ref.watch(clientUseLocationServicesForSearchProv) &&
                  ref.watch(clientUserMetaProv)!.location != null
                  ,
                  onSelected: (_) async {
                    if (ref.watch(clientUserMetaProv)!.location == null) {
                      showDialog(context: context, builder: (context) {
                        return const Center(child: CircularProgressIndicator());
                      });
                      try {
                        /// throws if location services are disabled
                        await getUserGeohash(ref);
                        ref.watch(
                            clientUseLocationServicesForSearchProv.notifier)
                            .state = true;
                        Navigator.pop(gNavigatorKey.currentContext!);
                      } catch (e) {
                        Navigator.pop(gNavigatorKey.currentContext!);
                        showErrorDialog(gNavigatorKey.currentContext!, e.toString());
                      }
                    }
                    else{
                      ref.watch(
                          clientUseLocationServicesForSearchProv.notifier)
                          .state = true;
                    }
                  }
                ),
                ChoiceChip(
                  backgroundColor: Colors.grey[100],
                  selectedColor: appPrimarySwatch[300],
                  label: const Text('Use Address',
                    style: TextStyle(color: Colors.black),
                  ),
                  selected: ! ref.watch(clientUseLocationServicesForSearchProv),
                  onSelected: (_) async {

                    if (ref.watch(clientUserMetaProv)!.address == null) {
                      showErrorDialog(context, "Please save an address");
                    }
                    else {
                      try {
                        showDialog(context: context, builder: (context) {
                          return const Center(
                              child: CircularProgressIndicator());
                        });

                        Map<String,dynamic> resp = {};

                        try { /// catch here so we can still pop loading spinner
                          resp = await lookupSuggestedAddress(
                              ref.watch(clientUserMetaProv)!.address!);
                        }catch(e){
                          NavigatorPop_MountedSafe(gNavigatorKey.currentContext!);
                        }
                        if (resp.containsKey("display_name")) {
                          lg.t("found results");
                          Navigator.pop(gNavigatorKey.currentContext!);
                          await showUseSuggestedAddressDialog(
                              gNavigatorKey.currentContext!, resp, () async {
                            lg.d("Set address controller");
                            addressController.text = resp["display_name"];
                            ClientUserMeta existing = ref.read(
                                clientUserMetaProv)!;
                            GeoHasher geoHasher = GeoHasher();
                            String geoHash = geoHasher.encode(
                                double.parse(resp["lon"]),
                                double.parse(resp["lat"]));
                            ClientUserMeta updated = existing.copyWith(
                              address: resp["display_name"],
                              addressGeoHash: geoHash,
                              addressLocation: {
                                "lat": resp["lat"],
                                "lng": resp["lon"]
                              },
                            );
                            await updateUserMeta(ref);
                            ref
                                .read(clientUserMetaProv.notifier)
                                .state = updated;
                            Navigator.pop(gNavigatorKey.currentContext!);
                          },
                                  () async {
                                Navigator.pop(context);
                              }
                          );
                        } else {
                          lg.t("didnt find results");
                          Navigator.pop(gNavigatorKey.currentContext!);
                          if (context.mounted) {
                            showErrorDialog(context, "Address not found");
                          }
                        }
                        ref
                            .watch(
                            clientUseLocationServicesForSearchProv.notifier)
                            .state = false;
                      }
                      catch (e) {
                        lg.e("error caught in client address lookup");
                        lg.e(e.toString());
                        Navigator.pop(gNavigatorKey.currentContext!);
                        if (context.mounted) {
                          showErrorDialog(context, default_error_message);
                        }
                      }
                    }
                  },
                ),
              ],

          ))),

        ],
    ));
  }
}



