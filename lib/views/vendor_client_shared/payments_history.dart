import 'dart:async';
import 'dart:convert';

import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/models/bookings/booking.dart';
import 'package:connectme_app/models/stripe/stripe_receipt.dart';
import 'package:connectme_app/models/stripe/stripe_refund.dart';
import 'package:connectme_app/models/user/etc.dart';
import 'package:connectme_app/providers/bookings.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/requests/bookings/bookings.dart';
import 'package:connectme_app/requests/urls.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/util/datetime_util.dart';
import 'package:connectme_app/util/etc.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../providers/auth.dart';
import '../strings/ui_message_strings.dart';


Future getPaymentHistory(String userId, String authToken, String clientOrVendor) async {
  lg.t("[getPaymentHistory] called");

  lg.t("[getPaymentHistory] pdatai ~ "+jsonEncode({
    'userId': userId,
    "authToken": authToken,
    "clientOrVendor": clientOrVendor
  }).toString());

  final response = await http.post(Uri.parse(get_payments_history_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        "authToken": authToken,
        "clientOrVendor": clientOrVendor
      }));
  if (response.statusCode != 200) {
    lg.w("not 200 paymentHistoryResponse ~ " + response.body.toString());
    throw Exception('Failed to load payments history');
    // return {"success":false};
  }
  return jsonDecode(response.body)["records"];
}

final paymentsHistoryProvider = FutureProvider((ref) async {

  final resp = await getPaymentHistory(ref.read(userAuthProv)!.userId,
      ref.read(userAuthProv)!.userToken,
        ref.read(userTypeProv)!.name);

  lg.t("[paymentsHistoryProvider] resp ~ " + resp.toString());

  // return resp.map((json) => StripeReceipt.fromJson(json)).toList();

  List transactions = resp.map((json) {
    if (json.containsKey('refund_charge_id')) {
      return StripeRefund.fromJson(json);
    } else {
      return StripeReceipt.fromJson(json);
    }
  }).toList();

  return transactions;

});


class PaymentHistoryPage extends ConsumerStatefulWidget {
  const PaymentHistoryPage({super.key});

  @override
  ConsumerState<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends ConsumerState<PaymentHistoryPage> {


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final receiptsAsync = ref.watch(paymentsHistoryProvider);

    return receiptsAsync.when(
        loading: () =>
        const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, _) {
          lg.e("[PaymentHistoryPage aync when]  error ~ " + err.toString());
          return Scaffold(
              appBar: AppBar(title: const Text('Payment History')),
              body: Center(child: Text(default_error_message)));
        },
        data: (receipts) {
          if (receipts.isEmpty) {
            return Scaffold(
              appBar: AppBar(title: const Text('Payment History')),
              body: const Center(child: Text("Nothing here yet")),
            );
          }
          return Scaffold(
              appBar: AppBar(title: const Text('Payment History')),
              body:
              ListView.builder(
                itemCount: receipts.length,
                itemBuilder: (context, index) {
                  return PaymentHistoryListItem(
                      key: ObjectKey(receipts[index]),
                      receiptObj: receipts[index]);
                },
              ));
        });
  }
}



/// Reciept and refund could be separate but they're like identical for now
class PaymentHistoryListItem extends ConsumerStatefulWidget {
  const PaymentHistoryListItem({super.key,
   required this.receiptObj
  });

  final receiptObj; /// not just reciept

  @override
  ConsumerState<PaymentHistoryListItem> createState() => _PaymentHistoryListItemState();
}

class _PaymentHistoryListItemState extends ConsumerState<PaymentHistoryListItem> {

  bool detailShown = false;

  Booking? booking;


  @override
  Widget build(BuildContext context) {


    return
      GestureDetector(
          onTap: () async {

            setState(() {
              detailShown = !detailShown;
            });

            // String bookingId = receiptObjs[index]["booking_id"];
            String bookingId = widget.receiptObj.bookingId;
            List<Booking> bp = ref.watch(
                bookingsCumNotifierProvider);

            bool foundInProv = false;
            for (Booking b in bp) {
              if (b.bookingId == bookingId) {
                lg.t("found in booking prov");
                foundInProv = true;
              }
            }

            if (!foundInProv) {
              await fetchBookingById(
                  ref.read(userAuthProv)!.userToken,
                  ref.read(userAuthProv)!.userId,
                  bookingId
              ).then((res){
                setState(() {
                  booking = res;
                });
              });
            }
          },
          child:
          ListView(
            shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                (widget.receiptObj is StripeReceipt) ?
                Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 16.sr, horizontal: 2.sr),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: ref.watch(darkModeProv)
                                  ? Colors.black.withValues(alpha:0.6)
                                  : Colors.grey.withValues(alpha:0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child:
                        ListTile(
                          title: Text(
                            widget.receiptObj.serviceName + " " +
                                humanReadableDateTime(
                                    widget.receiptObj.createTime,
                                    format: "long"),
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleSmall,
                          ),
                          trailing:
                              Container(
                          decoration:
                          BoxDecoration(color:
                          ref.watch(userTypeProv) == UserType.vendor?
                          Colors.green[700]:
                              appPrimarySwatch[700]
                              ,
                              borderRadius: BorderRadius.circular(
                                  Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium!.fontSize! *.4
                              )),
                          child:Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.sr, vertical: 1.sr),
                              child:Text(
                            formatCents(widget.receiptObj
                                .paymentAmountCents),
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleMedium!.copyWith(color:Colors.white),
                          )))
                        )))
                    :
                (widget.receiptObj is StripeRefund) ?
                Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 16.sr, horizontal: 2.sr),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: ref.watch(darkModeProv)
                                  ? Colors.black.withValues(alpha:0.6)
                                  : Colors.grey.withValues(alpha:0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child:
                        ListTile(
                          title:
                          Row(children:[
                          Text("Refund " ,
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleSmall!.copyWith(color: appPrimarySwatch[700],
                            fontWeight: FontWeight.w600
                            ),
                          ),

                            SizedBox(width: 4.sr,),

                            Text(widget.receiptObj.serviceName,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleSmall!,
                            )

                          ]),
                          trailing:
                          Container(
                              decoration:
                              BoxDecoration(color:
                              ref.watch(userTypeProv) == UserType.vendor?
                              appPrimarySwatch[700]:
                              Colors.green[700]

                                  ,
                                  borderRadius: BorderRadius.circular(
                                      Theme
                                          .of(context)
                                          .textTheme
                                          .titleMedium!.fontSize! *.4
                                  )),
                              child:Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.sr, vertical: 1.sr),
                                child:
                          Text(
                            ((widget.receiptObj.refundInitiator ==
                                "client"
                                && ref.watch(userTypeProv) ==
                                    UserType.client
                            ) ? "+" :
                            (widget.receiptObj.refundInitiator ==
                                "vendor"
                                && ref.watch(userTypeProv) ==
                                    UserType.vendor
                            ) ? "+" : "")
                                +
                                formatCents(widget.receiptObj
                                    .refundAmountCents),
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleMedium!.copyWith(color:Colors.white),
                          )))
                        ))) : Container(),

                /// didn't parse to receipt or refund
                // }
                // else{
                //   lg.e("[PaymentHistoryPage] error didn't parse to receipt or refund");
                //   return
                //    Container();
                // }
                // },


                (detailShown && booking != null)?
                Padding(
                padding: EdgeInsets.symmetric(vertical: 3.sr, horizontal: 8.sr),
                child:Container(
                      child:
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children:
                      ref.watch(userTypeProv)== UserType.client?
                          [
                            Text("${booking?.vendorUserName} "),
                            Text("${widget.receiptObj.vendorBusinessName} "),
                            Text(humanReadableDateTime(
                                    widget.receiptObj.createTime,
                                    format: "long"),
                              // style: Theme
                              //     .of(context)
                              //     .textTheme
                              //     .titleSmall!,
                            ),
                            Text("${DateFormat.jm().format(booking?.bookingTime??DateTime.now())}"),

                            booking?.address != null?
                            Text("${booking?.address}"):Container(),

                            Text("Vendor Id: ${widget.receiptObj.vendorUserId} "),
                            Text("Payment Id: ${widget.receiptObj.paymentIntentId} "),

                            booking?.address != null?
                            Text("${booking?.address}"):Container()

                  ]:
                      [
                        Text("${booking?.clientUserName} "),
                        Text(humanReadableDateTime(
                            widget.receiptObj.createTime,
                            format: "long"),
                          // style: Theme
                          //     .of(context)
                          //     .textTheme
                          //     .titleSmall!,
                        ),
                        Text("${DateFormat.jm().format(booking?.bookingTime??DateTime.now())}"),
                        Text("Client Id: ${widget.receiptObj.clientUserId} "),
                        Text("Payment Id: ${widget.receiptObj.paymentIntentId} "),


                      ]

                      )
                    )):
                (detailShown && booking == null)?
                Container(height: 100,child:Center(child: CircularProgressIndicator()),):Container()
              ]


          ));
  }
}
