
import 'dart:convert';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/requests/urls.dart';
import 'package:connectme_app/util/datetime_util.dart';
import 'package:http/http.dart' as http;


 getBaseAvailability(String vendorUserId)async {
  lg.t("getBaseAvailability called with vendorUserId ~ " + vendorUserId);

  // bool doubleBookingEnabled = false;

  try {
    var resp = await http.post(Uri.parse(get_base_availability_url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': vendorUserId,
        }));

    if (resp.statusCode == 200) {
      lg.t("[getBaseAvailability] getBaseAvailability got response ~ ");
      var decResp = json.decode(resp.body);
      lg.t(decResp.toString());

      if (decResp["baseAvailability"] == null){ /// vendor has no base availability set yet
        /// important init point -> noted in get_availability.py
        lg.t("returning default, baseAvail null");
        return baseAvailabilityDefaultResponse;
      }

      /// somehow null getting saved in DB from auto save, just sanitize here
      if (decResp["baseAvailability"]["double_booking_enabled"] == null){
        decResp["baseAvailability"]["double_booking_enabled"] = false;
      }
      // if (decResp[""]) /// days taken care of by loading methods

      // var convBaseAvailabilityResponse = jsonToBaseAvailabilityTodImpl(
      //     decResp["baseAvailability"]);
      // lg.t("[getBaseAvailability] convBaseAvailabilityResponse run with convBaseAvailabilityResponse ~ " + convBaseAvailabilityResponse.toString());
      // return convBaseAvailabilityResponse;
      return decResp["baseAvailability"];
    }
    else {
      lg.e("getBaseAvailability failed with statusCode ~ " +
          resp.statusCode.toString());
      return baseAvailabilityDefaultResponse;
    }
  }
  catch(e){
    lg.e("getBaseAvailability error ~ " + e.toString());
    return baseAvailabilityDefaultResponse;
  }
}