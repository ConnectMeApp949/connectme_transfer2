

import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/models/user/vendor_user_meta.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/providers/user.dart';
import 'package:connectme_app/requests/user/user_meta.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:connectme_app/views/client_app/profile/view_vendor_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




class _VendorUserDisplayData {
  final String userId;
  final String vendorUserName;
  final String businessName;
  final String? profilePicUrl;
  final VendorUserMeta vendorUserMeta;

  _VendorUserDisplayData({
    required this.userId,
    required this.vendorUserName,
    required this.businessName,
    required this.profilePicUrl,
    required this.vendorUserMeta
  });
}



final savedUsersProvider = FutureProvider<List<_VendorUserDisplayData>>((ref) async {
  final ids = ref.watch(savedServiceProviderProv);
  final results = <_VendorUserDisplayData>[];

  for (final userId in ids) {

    try {
      final userMetaMap = await getUserMeta(userId);
      final userMeta = VendorUserMeta.fromJson(userMetaMap["data"]);
      final picUrl = await getFirebaseProfileImageUrl(userId);
      results.add(
        _VendorUserDisplayData(
          userId: userId,
          businessName: userMeta.businessName ?? "",
          vendorUserName: userMeta.userName
              // ?? ""
          ,
          profilePicUrl: picUrl,
          vendorUserMeta: userMeta,
        ),
      );
    }catch(e){
      lg.w("couldn't convert to vendor display data, did $userId delete their account?");
      lg.e(e.toString());
    }
  }

  return results;
});

class SavedServicesList extends ConsumerStatefulWidget {
  const SavedServicesList({super.key});

  @override
  ConsumerState<SavedServicesList> createState() => _SavedServicesListState();
}

class _SavedServicesListState extends ConsumerState<SavedServicesList> {
  List<String>? savedUserIds;

  @override
  void initState() {
    super.initState();
  }

  // Future<List<_UserDisplayData>> _fetchUsers(List<String>? userIds) async {
  //   final results = <_UserDisplayData>[];
  //   if (userIds == null){return [];}
  //   for (final userId in userIds) {
  //     final userMetaMap = await getUserMeta(userId);
  //     final VendorUserMeta userMeta = VendorUserMeta.fromJson(userMetaMap["data"]);
  //     final picUrl = await getFirebaseProfileImageUrl(userId);
  //     results.add(
  //       _UserDisplayData(
  //         userId: userId,
  //         businessName: userMeta.businessName??"",
  //         profilePicUrl: picUrl,
  //         vendorUserMeta: userMeta
  //       ),
  //     );
  //   }
  //   return results;
  // }

  @override
  Widget build(BuildContext context) {

    final vendorsAsync = ref.watch(savedUsersProvider);

    return vendorsAsync.when(
      loading: () => const Scaffold(body:Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body:Center(child: Text('Error: $err'))),
      data: (vendors) {
        if (vendors.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Saved Providers'),
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            ),
            body: const Center(child: Text("Nothing here yet")),
          );
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Saved Providers'),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          ),
          body:
        ListView.builder(
              itemCount: vendors.length,
              itemBuilder: (context, index) {
                final vendor = vendors[index];
                return
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.sr,horizontal: 2.sr ),
                  child:Container(
                decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
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
                GestureDetector(
                  onTap:()async{


                    Navigator.pushNamedAndRemoveUntil(context, "/client_home", (route) => false);

                    String? getProfilePicUrl =  await getFirebaseProfileImageUrl(vendor.userId);
                    Navigator.of(gNavigatorKey.currentContext!).push(MaterialPageRoute(builder: (context) {
                      return VendorProfilePublicPage(
                        vendorUserId: vendor.userId,
                        vendorUserMeta: vendor.vendorUserMeta,
                        profileImageDownloadUrl:  getProfilePicUrl,
                        showSaveButton: false,
                      );
                    }));
                  },
                child:ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                    vendor.profilePicUrl != null?
                    NetworkImage(vendor.profilePicUrl!):
                  AssetImage('assets/images/etc/avatar_placeholder.jpeg',)
                    ,
                  ),
                  title: Text(vendor.businessName),
                ))));
              },
            )
        );
      },
    );

    // return FutureBuilder<List<_UserDisplayData>>(
    //   // future: _usersFuture,
    //   future:_fetchUsers(ref.watch(savedServiceProviderProv)),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(child: CircularProgressIndicator());
    //     }
    //     if (snapshot.hasError) {
    //       return Center(child: Text('Error: ${snapshot.error}'));
    //     }
    //     final users = snapshot.data!;
    //     if (users.isEmpty) {
    //       return Scaffold(
    //         appBar: AppBar(title: const Text('Saved Providers')),
    //         body: Center(
    //           child: Text("Nothing here yet"),
    //         ),
    //       );
    //     }
    //
    //     return Scaffold(
    //         appBar: AppBar(title: const Text('Saved Providers')),
    //     body: ListView.builder(
    //       itemCount: users.length,
    //       itemBuilder: (context, index) {
    //         final user = users[index];
    //         return
    //           Padding(
    //             padding: EdgeInsets.symmetric(vertical: 2.sr,horizontal: 2.sr ),
    //           child:Container(
    //         decoration: BoxDecoration(
    //         color: Theme.of(context).cardColor,
    //         borderRadius: BorderRadius.circular(12),
    //         boxShadow: [
    //         BoxShadow(
    //         color: ref.watch(darkModeProv)
    //         ? Colors.black.withValues(alpha:0.6)
    //             : Colors.grey.withValues(alpha:0.3),
    //         blurRadius: 6,
    //         offset: const Offset(0, 3),
    //         ),
    //         ],
    //         ),
    //         child:
    //         GestureDetector(
    //           onTap:()async{
    //
    //
    //             Navigator.pushNamedAndRemoveUntil(context, "/client_home", (route) => false);
    //             Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    //               return VendorProfilePublicPage(
    //                 vendorUserId: user.userId,
    //                 vendorUserMeta: user.vendorUserMeta,
    //                 profileImagePath: user.profilePicUrl,
    //               );
    //             }));
    //           },
    //         child:ListTile(
    //           leading: CircleAvatar(
    //             backgroundImage:
    //             user.profilePicUrl != null?
    //             NetworkImage(user.profilePicUrl!):
    //           AssetImage('assets/images/etc/avatar_placeholder.jpeg',)
    //             ,
    //           ),
    //           title: Text(user.businessName),
    //         ))));
    //       },
    //     ));
    //   },
    // );
  }
}




