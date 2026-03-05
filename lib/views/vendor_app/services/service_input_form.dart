import 'dart:async';
import 'dart:convert';

import 'package:connectme_app/components/ui/buttons/rounded_outline_button.dart';
import 'package:connectme_app/components/ui/image_widgets/reorderable_image_grid.dart';
import 'package:connectme_app/components/ui/modals/error_dialog.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/settings.dart';
import 'package:connectme_app/constants/lists.dart';
import 'package:connectme_app/models/services/services.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/providers/services.dart';
import 'package:connectme_app/requests/location/location.dart';
import 'package:connectme_app/requests/services/services.dart';
import 'package:connectme_app/requests/urls.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/util/etc.dart';
import 'package:connectme_app/util/image_util.dart';
import 'package:connectme_app/util/location.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:connectme_app/views/strings/ui_message_strings.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/platform_bridge/platform_bridge.dart';
import 'package:http/http.dart' as http;

// import 'package:email_validator/email_validator.dart';

class ServiceForm extends ConsumerStatefulWidget {
  const ServiceForm({super.key,
  this.service
  });
  final ServiceOffered? service;

  @override
  ConsumerState<ServiceForm> createState() => _ServiceFormState();
}

class _ServiceFormState extends ConsumerState<ServiceForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _descriptionController = TextEditingController();
  final  GlobalKey<FormFieldState<String>> _descriptionFormKey = GlobalKey<FormFieldState<String>>();
  final _emailController = TextEditingController();
  // final GlobalKey<FormFieldState<String>> _emailFormKey = GlobalKey<FormFieldState<String>>();
  final _nameController = TextEditingController();
  final GlobalKey<FormFieldState<String>> _nameFormKey = GlobalKey<FormFieldState<String>>();
  final _phoneController = TextEditingController();
  final _priceController = TextEditingController();
  final GlobalKey<FormFieldState<String>> _priceFormKey = GlobalKey<FormFieldState<String>>();
  // final _distanceController = TextEditingController();
  final GlobalKey<FormFieldState<String>> _distanceFormKey = GlobalKey<FormFieldState<String>>();
  final _timeLengthController = TextEditingController();
  // final GlobalKey<FormFieldState<String>> _timeLengthFormKey = GlobalKey<FormFieldState<String>>();
  // final _keywordController = TextEditingController();
  // final GlobalKey<FormFieldState<String>> _keywordFormKey = GlobalKey<FormFieldState<String>>();
  final _addressController = TextEditingController();
  final GlobalKey<FormFieldState<String>> _addressFormKey = GlobalKey<FormFieldState<String>>();

  final GlobalKey<FormFieldState<String>> _categoryFormKey = GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _siteFormKey = GlobalKey<FormFieldState<String>>();


  @override
  dispose(){
    _descriptionController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _priceController.dispose();
    // _distanceController.dispose();
    _timeLengthController.dispose();
    // _keywordController.dispose();
    _addressController.dispose();

    super.dispose();
  }

  // Form values
  String? category;
  String? site;
  String? chosenDistance;
  bool setTimeLengthSelected = false;
  String hoursChosen = "0";
  String minutesChosen = "0";
  bool useSavedAddressSelected = false;
  List<String> keywords = [];

  /// for the reorderable grid view
  List<MapEntry<String, Uint8List>> _orderedImages = [];

  bool addressIsFederated = false;
  String? lookedUpSuggestedAddress;
  String? lookedUpSuggestedGeoHash;
  Map? lookedUpSuggestedLocation;

  @override
  initState() {
    super.initState();
    scheduleMicrotask(() async {
      if (widget.service != null) {

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );

        for (var image in widget.service!.imageIds){
          final imageBytes = await getDownloadUrlAndReturnFirebaseStorageImageAsBytes(image);
          if (imageBytes != null) {
            // final imageBytesUint8List = imageBytes;
            _orderedImages.add(MapEntry(image, imageBytes));
          }
        }

        setState(() {
          _descriptionController.text = widget.service!.description;
          _emailController.text = widget.service!.email ?? "";
          _nameController.text = widget.service!.name;
          // _categoryController.text = widget.service!.category;
          _phoneController.text = widget.service!.phoneNumber ?? "";
          _priceController.text = (widget.service!.priceCents / 100).toStringAsFixed(2);

          if (widget.service!.timeLength != 0) {
            setTimeLengthSelected = true; // set to true to show time length
            _timeLengthController.text = widget.service!.timeLength.toString();
            List hoursAndMinutes = convertToHoursAndMinutes(
                widget.service!.timeLength!);
            hoursChosen = hoursAndMinutes[0].toString();
            minutesChosen = hoursAndMinutes[1].toString();
          }

          _addressController.text = widget.service!.address ?? "";
          category = widget.service!.category;
          site = widget.service!.site;
          if (widget.service!.radius != null) {
          chosenDistance =
              convDistanceMetricToStandardInt(widget.service!.radius.toString())
                  ?.toString();
          }

          keywords = widget.service!.keywords.toList();
        });
        Navigator.of(gNavigatorKey.currentContext!).pop();
      }
    });
  }

  void _addKeyword(String value) {
    lg.t("adding keyword with old keywords ~ " + keywords.toString());

    if (keywords.length < gServiceKeywordLimit) {
      if (value
          .trim()
          .isEmpty || keywords.contains(value.trim())) {return;}
      setState(() {
        keywords.addAll(value.trim().split(" "));
        // _keywordController.clear();
      });

      lg.t("new keywords ~ " + keywords.toString());
    }
    else{
      showErrorDialog(context, "You've reached the keyword limit.");
    }
  }


  void _removeKeyword(String value) {
    setState(() {
      keywords.remove(value);
    });
  }





  createNewService(Map newServiceData)async{
    lg.t("[createNewService] called");
    final uri = Uri.parse(create_service_url);
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(newServiceData),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        lg.e('Upload failed: ${response.statusCode}');
        lg.d(response.body);
        return null;
      }
    }

    setAddressCacheFieldsWithLookupResponse(List lsaasd_resp){
      /// the lookup shows a dialog so this is enough
      if ( lsaasd_resp[0] == false){
        addressIsFederated = false;
        setState(() {});
        return;
        }
        else{

          addressIsFederated = true;
          lookedUpSuggestedAddress = lsaasd_resp[1];
          lookedUpSuggestedGeoHash = lsaasd_resp[2];
          lookedUpSuggestedLocation = lsaasd_resp[3];
          setState(() {});
        }
    }

    // return [bool success, String address, String geohash];
    Future<List> lookupSuggestedAddressAndShowDialog(String inputAddress) async{
    lg.t("[lookupSuggestedAddressAndShowDialog] called");

    var geocoding_resp;
    List ret_obj = [false, ""];
    try { /// saw this return I/flutter ( 3695): 🚫  error caught in submit form ~ FormatException: Unexpected character (at character 1)
          ///      I/flutter ( 3695): <html>
          ///   I/flutter ( 3695): ^
          /// I/flutter ( 3695): 🚫  trace ~ #0      _ChunkedJsonParser.fail (dart:convert-patch/convert_patch.dart:1457:5)
          /// not sure why tried to reproduce in browser but always got json response

      geocoding_resp = await lookupSuggestedAddress(inputAddress);

    }catch(e){
            lg.e("exception in lookupSuggestedAddress ~ " + e.toString());
            rethrow;
          }

          lg.t("lsa resp passed");
      if (geocoding_resp != null && geocoding_resp.length > 0) {
        lg.t("[lookupSuggestedAddressAndShowDialog] found addresses");

       bool userAcceptedAddress = await showDialog(context: gNavigatorKey.currentContext!, builder: (context) =>
            AlertDialog(
              title: Text("Use Found Address?"),
              content: Text(geocoding_resp["display_name"]),
              actions: [

            Padding(
            padding: EdgeInsets.symmetric(vertical: 12.sr),
            child:
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                TextButton(
                    onPressed: () {

                      Navigator.pop(context, false);
                    },
                    child: Text("Cancel")),

                    TextButton(
                        onPressed: () {
                          lg.d("Set address controller");
                          _addressController.text = geocoding_resp["display_name"];

                          Navigator.pop(context, true);
                        },
                        child: Text("Ok",
                        style: TextStyle(color: appPrimarySwatch[700]),
                        ))

                    ])),
              ],
            ));
        GeoHasher geoHasher = GeoHasher();
        String geoHash = geoHasher.encode(
            double.parse(geocoding_resp["lon"]), double.parse(geocoding_resp["lat"]));
        Map location = {"lat": double.tryParse(geocoding_resp["lat"]), "lng": double.tryParse(geocoding_resp["lon"])};

        // return
           ret_obj = [userAcceptedAddress, geocoding_resp["display_name"], geoHash, location];
        lg.d("returing ~ " + ret_obj.toString());
        return ret_obj;
      }else{
        lg.w("Address not found resp len was 0");
        return [false, ""];
      }
      /// should never reach
    }

  submitForm()async{
    lg.t("[submitForm] called");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {

      if (_orderedImages.isEmpty){
        Navigator.pop(context);
        showErrorDialog(context, "Please add at least one image");
        return;
      }

      if (_formKey.currentState?.validate() == true) {
        lg.t("[submitForm] form validated");

        if (site == "on-site" || site == "client-site" || site == "delivery"){
          if (addressIsFederated == false){
          // if (useSavedAddressSelected == false){
            var lsaasd_resp = await lookupSuggestedAddressAndShowDialog(_addressController.text);
            lg.t("lsaasd_resp returned call setAddressCacheFieldsWithLookupResponse");
            setAddressCacheFieldsWithLookupResponse(lsaasd_resp);
            if (lsaasd_resp[0] == false ){ /// specific case user did not accept address
              lg.t("[submitForm] lsaasd_resp is false");
              Navigator.pop(gNavigatorKey.currentContext!);
              return; /// user cancelled lookup but can enter address again, no error
            }
          }
        }

        int calculatedTimeLength = 0;
        if (setTimeLengthSelected){
          calculatedTimeLength = ((int.tryParse(hoursChosen) ?? 0) * 60) +
              ( int.tryParse(minutesChosen) ?? 0 );
        }


        lg.t("build new service data");

        final newServiceData = {
          'userId': ref.read(userAuthProv)!.userId,
          "authToken": ref.read(userAuthProv)!.userToken,
          'address': lookedUpSuggestedAddress,
          'category': category,
          'description': _descriptionController.text,
          'email': _emailController.text.isEmpty ? null : _emailController.text,
          'featureImageId': _orderedImages[0].key,
          'imageIds': _orderedImages.map((e) => e.key).toList(),
          'geoHash': lookedUpSuggestedGeoHash,
          'keywords': keywords,
          'location': lookedUpSuggestedLocation,
          'name': _nameController.text,
          'phoneNumber': _phoneController.text.isEmpty ? null : _phoneController
              .text,
            'priceCents': ((double.tryParse(_priceController.text) ?? 0) * 100).round(),
          'radius': convDistanceStandardToMetricInt(
            chosenDistance
          ),
          "rating":widget.service?.rating,
          "ratingCount": widget.service?.ratingCount,
          'site': site,
          'timeLength': calculatedTimeLength,
          'vendorUserId':ref.read(userAuthProv)!.userId,
        'vendorBusinessName': ref.read(vendorUserMetaProv)!.businessName,
          'vendorUserName': ref.read(userAuthProv)!.userName,
        };

        lg.t("submitting built data ~ " + newServiceData.toString());

        if (widget.service != null) { // delete existing service if it exists
          try {
            await deleteService(
                ref.read(userAuthProv)!.userId,
                ref.read(userAuthProv)!.userToken,
                widget.service!.serviceId);
          }catch(e){
            lg.e("error deleting service ~ " + e.toString());
          }

        }

        lg.t("call create new service");

        var cns_resp = await createNewService(newServiceData);

        /// only upload images if form successfull
        if (cns_resp["success"] == true) {
          if (_orderedImages.isNotEmpty) {
            Map<String, Uint8List> mapImageData = Map.fromEntries(_orderedImages);
            // var download_url_data =
              await uploadToFirebaseAndGetDownloadURL(
                  ref.read(userAuthProv)!.userId,
                  ref.read(userAuthProv)!.userToken,
                  mapImageData);

            // lg.t("download urls " + download_url_data.toString());
            }

          ref.read(vendorServicesProvider.notifier).refresh();

          if (context.mounted) {
            Navigator.of(gNavigatorKey.currentContext!).pop(); // Remove loading dialog
            Navigator.of(gNavigatorKey.currentContext!).pop(); // Go to services page
          }
          // Navigator.of(context).pushNamedAndRemoveUntil("/vendor_home", (route) => false);

        }
        else{
        throw Exception("Service creation failed");
        }
      }
      else{
        Navigator.pop(context);
        showErrorDialog(context, "Please check all required fields and try again");
      }

    }catch(e, st){
      lg.e("error caught in submit form ~ " + e.toString());
      lg.e("trace ~ " + st.toString());
      Navigator.pop(gNavigatorKey.currentContext!);

      if (e.toString().contains("lookupSuggestedAddress")) {
        showErrorDialog(gNavigatorKey.currentContext!, locationLookupServiceErrorMessage);
        return;
      }
        showErrorDialog(gNavigatorKey.currentContext!, default_error_message);


    }

    // lg.d("download_url_data ~ " + download_url_data.toString());
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    //   return UploadSuccessScreen();
    // }));
  }



  addImageToFormPage()async{
    Uint8List? imageBytes;
    // if (kIsWeb) {
      imageBytes = await pickImageAndConvertToJpeg();
    // }

    if (imageBytes != null) {
      String makeId = generateRandomAlphanumeric(16);
      String makeFirebaseUrl = "service_images/" + makeId + ".jpg";
      // imageBytesImages[makeId] = imageBytes;
      _orderedImages.add(MapEntry(makeFirebaseUrl, imageBytes));
      setState(() { });
    }
  }

  removeImageFromFormPage(String id){
    setState(() {
      _orderedImages.removeWhere((element) => element.key == id);
    });
  }

  void onReorder(List<MapEntry<String, Uint8List>> newList) {
    setState(() {
      _orderedImages = List.from(newList); // copy to avoid external mutation
      // imageBytesImages = Map.fromEntries(_orderedImages);
    });
  }


  @override
  Widget build(BuildContext context) {


    // final inputDecorationTheme = Theme.of(context).inputDecorationTheme;

    return  SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              // ImageGalleryViewer(images: imageBytesImages.values.toList()),

              ReorderableImageGrid(
                orderedImages: _orderedImages,
                onReorder: (newList) => setState(() => _orderedImages = newList),
                onRemove: (id) => removeImageFromFormPage(id),
              ),
              _orderedImages.isNotEmpty?
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.sr),
              child:Row(children: [Flexible(child:Text("Long press and drag to reorder images, double tap to remove"))])):Container(),
              SizedBox(height: 16.sr,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                InkWell(
                  onTap: () async{
                    if (_orderedImages.length < serviceImageLimit) {
                      await addImageToFormPage();
                    }
                    else{
                      showErrorDialog(context, "Maximum of ${serviceImageLimit} images");
                    }
                        },
                    child:Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: appPrimarySwatch[600]!, width: 1.sr),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: Gss.width * .1, vertical: Gss.width * .01),
                  width: Gss.width * .3,
                child:Center(child:Icon(Icons.add_a_photo_outlined,
                color: appPrimarySwatch[600],
                  size: Gss.width * .1,
                ))
                ))
              ]),

               SizedBox(height: 22.sr),
              TextFormField(
                maxLength:200,
                key: _nameFormKey,
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Service Name*',

                ),
                validator: (val) =>
                val == null || val.trim().isEmpty ? 'Enter a name' : null,
                onChanged: (val){ _nameFormKey.currentState?.validate();}
              ),
              SizedBox(height: Gss.height * .088,),

              DropdownButtonFormField<String>(
                key: _categoryFormKey,
                decoration: const InputDecoration(labelText: 'Category*'),
                items: serviceCategories
                    .where((cat) => cat.toLowerCase() != "any")
                    .map((cat) => DropdownMenuItem(value: cat.toLowerCase(), child: Text(cat)))
                    .toList(),
                value: category,
                onChanged: (val){
                  setState(() => category = val);
                  _categoryFormKey.currentState?.validate();
                  },
                validator: (val) => val == null ? 'Please select a category' : null,
              ),

              SizedBox(height: Gss.height * .088,),

              TextFormField(
                maxLength:2000,
                key: _descriptionFormKey,
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description*'),
                maxLines: 3,
                onChanged: (val){ _descriptionFormKey.currentState?.validate();},
                validator: (val) =>
                val == null || val.trim().isEmpty ? 'Enter a description' : null,

              ),

              SizedBox(height: Gss.height * .088,),

              /// Price
              TextFormField(
                maxLength: 8,
                key: _priceFormKey,
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price*'),
                keyboardType: TextInputType.number,
                onChanged: (val){ _priceFormKey.currentState?.validate();},
                validator: (val) =>
                val == null || double.tryParse(val) == null ? 'Enter a valid price' : null,
              ),

              SizedBox(height: Gss.height * .088,),

              CheckboxListTile(
                title: const Text('Set time length?'),
                value: setTimeLengthSelected,
                onChanged: (val){
                  setState(() {
                    setTimeLengthSelected = val??false;
                  });
                },
              ),

              SizedBox(height: Gss.height * .088,),

              setTimeLengthSelected?
                  Row(children: [
                    Expanded(child:
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Gss.width * .02),
                      child:
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Hours'),
                      items: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      value: hoursChosen,
                      onChanged: (val) => setState(() => hoursChosen = val??"0"),
                    ))),
                    Expanded(child:
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: Gss.width * .02),
                        child:DropdownButtonFormField<String>(
                      decoration:  InputDecoration(
                      labelText:"Minutes"
                      ).applyDefaults(Theme.of(context).inputDecorationTheme)
                          ,
                      items: ["0", "15", "30", "45"]
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      value: minutesChosen,
                      onChanged: (val) => setState(() => minutesChosen = val??"0"),
                    ))),
                  ],):Container(),
              // TextFormField(
              //   controller: _timeLengthController,
              //   decoration: const InputDecoration(labelText: 'Time Length (minutes)'),
              //   keyboardType: TextInputType.number,
              //   validator: (val) =>
              //   val == null || int.tryParse(val) == null ? 'Enter time in minutes' : null,
              // ):Container(),

              SizedBox(height: Gss.height * .088,),

              TextFormField(
                // controller: _keywordController,
                decoration: const InputDecoration(labelText: 'Add keyword'),
                onFieldSubmitted: _addKeyword,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.sr, vertical: 6.sr),
              child:Wrap(
                alignment: WrapAlignment.start,
                spacing: 8,
                children: keywords
                    .map((kw) => Chip(
                  label: Text(kw),
                  onDeleted: () => _removeKeyword(kw),
                ))
                    .toList(),
              )),

              SizedBox(height: Gss.height * .088,),

              DropdownButtonFormField<String>(
                key: _siteFormKey,
                decoration: const InputDecoration(labelText: 'Site*'),
                items: serviceSiteOptions
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                value: site,
                onChanged: (val){ setState(() => site = val);
                _siteFormKey.currentState?.validate();
                },
                validator: (val) => val == null ? 'Please select a site' : null,
              ),

              SizedBox(height: Gss.height * .088,),

              site == "client-site" || site == "delivery"?
              DropdownButtonFormField<String>(
                key: _distanceFormKey,
                decoration: const InputDecoration(labelText: 'Service Distance* (miles)'),
                items: serviceDistanceOptions
                    .map((s){
                      String displayS = "";
                      if (s == 750){
                        displayS = "750+";
                      }
                      else{displayS = s.toString();}
                      return DropdownMenuItem(value: s.toString(), child: Text(displayS));
                    }).toList(),
                value: chosenDistance,
                onChanged: (val) {setState(() => chosenDistance = val);
                  _distanceFormKey.currentState?.validate();
                  },
                validator: (val) => val == null ? 'Please select a distance' : null,
              ): Container(),


              SizedBox(height: Gss.height * .088,),

              site == "on-site" || site == "client-site" || site == "delivery"?
              CheckboxListTile(
                title: const Text('Use Saved Address'),
                value: useSavedAddressSelected,
                onChanged: (val){

                  setState(() {
                    _addressController.text = "";
                    useSavedAddressSelected = val??false;
                  });
                  if (val == true) {
                    if (ref.read(vendorUserMetaProv)!.address == null ||
                        ref.read(vendorUserMetaProv)!.address == ""
                    ) {
                      setState(() {
                        _addressController.text = "";
                        useSavedAddressSelected = false;
                      });
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          title: const Text('No Address Found'),
                          content: const Text(
                              'Address not found. Update address to use saved address'),
                          actions: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  // TextButton(
                                  //   onPressed: () {
                                  //     Navigator.of(context).pop();
                                  //     Navigator.of(context).pop();
                                  //     Navigator.of(context).pop();
                                  //     Navigator.of(context).push(
                                  //         MaterialPageRoute(builder: (context) {
                                  //           return const BusinessInformation();
                                  //         }));
                                  //   },
                                  //   child: const Text('Update Address'),
                                  // )
                                ])
                          ],
                        );
                      });
                    } else { /// then meta should have these
                      _addressController.text =
                      ref.read(vendorUserMetaProv)!.address!;
                      lookedUpSuggestedAddress = ref.read(vendorUserMetaProv)!.address!;
                      lookedUpSuggestedGeoHash = ref.read(vendorUserMetaProv)!.geoHash!;
                      lookedUpSuggestedLocation = ref.read(vendorUserMetaProv)!.location!;
                      addressIsFederated = true;
                    }
                    _addressFormKey.currentState?.validate();
                  }

                  },
              ):Container(),

              SizedBox(height: Gss.height * .088,),

              (site == "on-site" || site == "client-site" || site == "delivery") ?
              TextFormField(
                key:_addressFormKey,
                maxLength: 200,
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Service Location* (address)'),
                keyboardType: TextInputType.streetAddress,
                validator: (val) =>
                val == null || val == "" ? 'Enter an address' : null,
                onChanged: (val){
                  lg.t("address onChange");
                  _addressFormKey.currentState?.validate();
                  setState(() {
                    addressIsFederated = false;
                  });
                  },
                onFieldSubmitted: (val) async{
                  lg.t("address onFieldSubmitted");

                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const Center(child: CircularProgressIndicator()),
                  );

                  try {
                    List lsaasd_resp = await lookupSuggestedAddressAndShowDialog(
                        _addressController.text);
                    setAddressCacheFieldsWithLookupResponse(lsaasd_resp);
                  }catch(e){
                    lg.e("Exp caught in field submitted address lookup");
                    Navigator.pop(gNavigatorKey.currentContext!);
                    showErrorDialog(gNavigatorKey.currentContext!, locationLookupServiceErrorMessage);
                  }

                },
              ): Container(),

              SizedBox(height: Gss.height * .088,),

              TextFormField(
                maxLength: 200,
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                // validator: (val) => val == null || !EmailValidator.validate(val)
                //     ? 'Enter a valid email'
                //     : null,
              ),

              SizedBox(height: Gss.height * .088,),

              TextFormField(
                maxLength: 200,
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: Gss.height * .088,),


              SizedBox(height: Gss.height * .1),

              RoundedOutlineButton(
                color: appPrimarySwatch[700],
                onTap: ()async{


                await submitForm();
              },
                label: "Submit",
                width: Gss.width * .88,
                paddingVertical: Gss.height * .01,
              ),

              SizedBox(height: Gss.height * .1),
            ],
          ),
        ),
    );
  }
}
