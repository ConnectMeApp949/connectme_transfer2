import 'dart:async';
import 'package:connectme_app/components/ui/image_widgets/future_firebase_image.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/config/settings.dart';
import 'package:connectme_app/constants/lists.dart';
import 'package:connectme_app/models/services/services.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/providers/services.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/util/datetime_util.dart';
import 'package:connectme_app/util/etc.dart';
import 'package:connectme_app/util/location.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:connectme_app/views/service/service_detail.dart';
import 'package:connectme_app/views/strings/ui_message_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'components/filters_inputs.dart';


final focusSearchBar = StateProvider<bool>((ref) => false);
final focusSearchFilters = StateProvider<bool>((ref) => false);

class ConnectMeClientHome extends ConsumerStatefulWidget {
  const ConnectMeClientHome ({super.key,
    required this.tabIndex,
  });
  final int tabIndex;

  @override
  ConsumerState<ConnectMeClientHome> createState() => _ConnectMeClientHomeState();
}

class _ConnectMeClientHomeState extends ConsumerState<ConnectMeClientHome>  with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true; // 👈 Prevent dispose

  final double titleInitHeight = 60.0;
   double subtitleInitHeight = 60.0;
   double categoriesSliderInitHeight = 85.0;


  double titleHeight = 60.0;
  double subtitleHeight = 60.0;
  double categoriesSliderHeight = 85.0;

  double maxHeaderHeight = 60.0 + 60.0 + 85.0; // all items added together

  bool showFAB = false;

  double _lastOffset = 0;
  double _headerOffset = 0;

  final titleHeightNotifier = ValueNotifier<double>(60.0); /// titleInitHeight
  final subtitleHeightNotifier = ValueNotifier<double>(60.0); /// subtitleInitHeight
  // final searchBarHeightNotifier = ValueNotifier<double>(60.0); /// searchBarInitHeight
 final categoriesSliderHeightNotifier = ValueNotifier<double>(85.0); /// categoriesSliderInitHeight

  // bool focusSearchBar = false;
  // bool focusSearchFilters = false;
  final FocusNode _focusSearchBarNode = FocusNode();

  Timer? _debounceTimer0;
  Timer? _debounceTimer1;

  TextEditingController searchTextController = TextEditingController();


  void _handleScroll() async {
    final offset = homeScrollController.offset;

    final scrollDelta = offset - _lastOffset;

    // lg.t("scroll delta ~ " + scrollDelta.toString());
    _lastOffset = offset;

    _headerOffset -= scrollDelta;
    _headerOffset = _headerOffset.clamp(0.0, maxHeaderHeight);

    // lg.t("new header offset ~ " + _headerOffset.toString());

      /// Animate section heights based on header offset
      final remaining = _headerOffset;

      /// create snapping effect
      titleHeight = remaining > maxHeaderHeight ? titleInitHeight :
      (remaining - subtitleInitHeight).clamp(0, titleHeight);
      subtitleHeight = remaining > titleInitHeight ? subtitleInitHeight :
        (remaining ).clamp(0, subtitleInitHeight);
    categoriesSliderHeight = remaining > titleInitHeight ? categoriesSliderInitHeight :
    (remaining ).clamp(0, categoriesSliderInitHeight);

      titleHeightNotifier.value = titleHeight;
      subtitleHeightNotifier.value = subtitleHeight;
      categoriesSliderHeightNotifier.value = categoriesSliderHeight;

      // lg.t("heights ~ " + titleHeight.toString() + "  " + subtitleHeight.toString() + "  " + categoriesSliderHeight.toString());

    /// for FAB
      // bool shouldShowFAB = offset > 100;
      //
      // if (shouldShowFAB != showFAB) {
      //   showFAB = shouldShowFAB;
      //   ref.read(showFABProvider.notifier).state = showFAB;
      // }

/// check for Floating button, after scroll because limits
    if (scrollDelta < 0){
      if (_debounceTimer1?.isActive ?? false) return;
      lg.t("last offset pos");
      _debounceTimer1 = Timer(const Duration(milliseconds: 100), () {});
      ref.read(showBNBProvider.notifier).state = true;
    }
    if (scrollDelta > 0){
      if (_debounceTimer1?.isActive ?? false) return;
      lg.t("last offset neg");
      _debounceTimer1 = Timer(const Duration(milliseconds: 100), () {});
      ref.read(showBNBProvider.notifier).state = false;
      // ref.read(showFABProvider.notifier).state = false;
    }



    /// trigger pagination
    if (ref.watch(scrollControllerProvider).hasClients) {
      if (ref
          .watch(scrollControllerProvider)
          .position
          .pixels >=
          ref.watch(scrollControllerProvider).position.maxScrollExtent) {

        if (_debounceTimer0?.isActive ?? false) return;

          lg.t("call scroll triggered debounced services loadMore");
        ref.read(loadingServiceItemsProviderMore.notifier).state = true;
        _debounceTimer0 = Timer(const Duration(milliseconds: 3300), () {});
        lg.t("debounce timer set");
        await ref.read(servicesProvider.notifier).loadMore().then((res)async {
          lg.t("load more finished");
          if (appConfig.simulateNetworkLatency){
            lg.t("simulating network latency");
            await Future.delayed(Duration(milliseconds: 3000), () {});
          }
          lg.t("stop loading state");
          ref.read(loadingServiceItemsProviderMore.notifier).state = false;
        });
        // _debounceTimer = Timer(const Duration(milliseconds: 3300), () {
        // // ref.read(loadingServiceItemsProvider.notifier).state = true;
        // //   Future.delayed(Duration(milliseconds: 3300), () {
        // //     ref.read(loadingServiceItemsProvider.notifier).state = false;
        // //   });
        //
        //     // ref.read(servicesProvider.notifier).loadMore();
        //
        // });

      }
    }


  }



  @override
  void initState() {
    super.initState();

    lg.t("client home init state");

    homeScrollController.addListener(_handleScroll);
    _headerOffset = titleHeight + subtitleHeight;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      tryUpdateUserLocationServices(context, ref);
      // ref.read(userMetaProv.notifier).updateGeoHash();
    });

  }

  @override
  void dispose() {

    _focusSearchBarNode.dispose();
    homeScrollController.removeListener(_handleScroll);

      try{
        _debounceTimer0?.cancel();
      }catch(e){
        lg.w("couldn't cancel _debounceTimer0");
      }
    try{
      _debounceTimer1?.cancel();
    }catch(e){
      lg.w("couldn't cancel _debounceTimer1");
    }

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);

    final asyncServicesItems = ref.watch(filteredServicesProvider);

    if (ref.watch(searchBarInputFilterProvider).isNotEmpty){
      searchTextController.text = ref.watch(searchBarInputFilterProvider).join(" ");
    }
    else{
      searchTextController.text = "";
    }

    final distanceStandard = ref.watch(distanceStandardProvider);
    final category = ref.watch(categoryFilterProvider);
    final keywords = ref.watch(keywordFilterProvider);
    final rating = ref.watch(ratingFilterProvider);
    final searchBar = ref.watch(searchBarInputFilterProvider);

    lg.t("check search has filters");
    bool searchHasFilters = false;
    if (distanceStandard != null || category != null || keywords != null || rating != null || (searchBar.isNotEmpty && searchBar[0] != "")){
      lg.t("setting search has filters true ${distanceStandard} ${category} ${keywords} ${rating} ${searchBar}");
      searchHasFilters = true;
    }

    return
      Stack(
          children: [
          // Greyed-out overlay
    GestureDetector(
      behavior: HitTestBehavior.opaque,
        onTap: () {
        lg.t("Got stack top tap");
       if (ref.read(focusSearchBar)){
           ref.read(focusSearchBar.notifier).state = false;
           ref.read(focusSearchFilters.notifier).state = false;
       }
      },
      child: Container(
        color:
        ref.watch(focusSearchBar)?
        Colors.black.withValues(alpha:0.5): null,
      child:
      Column(
        children: [
        ValueListenableBuilder<double>(
        valueListenable: titleHeightNotifier,
        builder: (context, value, child) {
          return AnimatedContainer(
            color: Theme.of(context).scaffoldBackgroundColor,
            duration: Duration(milliseconds: 200),
            height: value,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Center(child:Text(
              'Home',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            )),
          );}),
    ValueListenableBuilder<double>(
    valueListenable: subtitleHeightNotifier,
    builder: (context, value, child) {
          return
            Padding(
                padding: EdgeInsets.symmetric(vertical:8),
            child:AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: value,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
                child:Row(children: [
              Expanded(child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Flexible(child:Text("Hello ${ref.watch(userAuthProv)!.userName}",
                  style: TextStyle(fontSize: Theme.of(context).textTheme.titleMedium!.fontSize, fontWeight: FontWeight.w700),
                )),
                // Row(children:[
                // Flexible(child:Text("Find and book services near you",
                //   style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize, fontWeight: FontWeight.w300),
                // ))])
            ],)
          ),

                  // Icon(Icons.notifications_none)
                  (subtitleHeightNotifier.value < subtitleInitHeight)? Container():
                  IconButton(onPressed: ()async{
                    ref.read(servicesProvider.notifier).refresh();

                    // final deviceInfoPlugin = DeviceInfoPlugin();
                    // final deviceInfo = await deviceInfoPlugin.deviceInfo;
                    // deviceInfo.data.forEach((k,v){
                    //
                    //   print("device data key ~ " + k.toString());
                    //   print("device data value ~ " + v.toString());
                    // });

                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  //   return const SuccessScreen(
                  //     message: "Booking Successful",
                  //   );
                  // }));

                  },
                      icon: Icon(Icons.refresh)
                  )
                ]))
            ));
    }),


!ref.watch(focusSearchBar)?
GestureDetector(
    onTap: (){
      if (!ref.watch(focusSearchBar)){
        ref.read(focusSearchBar.notifier).state = true;
        _focusSearchBarNode.requestFocus();
      }
      ref.read(showBNBProvider.notifier).state = false;
      // ref.read(showFABProvider.notifier).state = false;
    },
    child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.sr, horizontal: 8.sr),
        child:Container(
        width: Gss.width * .88,
        // height: Gss.height * .05,
        decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(6.sr),
            border: Border.all(color: Theme.of(context).colorScheme.onSurface, width: 1.sr)
        ),
        child:
    Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search),
            SizedBox(width: Gss.width * .01, height: 28.sr,),
            Text((searchTextController.text!="")?
            searchTextController.text:"Search for services...",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500)),
          ],
        )
    ))):

Material(
    elevation: 4,
    borderRadius: BorderRadius.circular(8),
    child:      Container(
        padding:EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Center(
            child:
            Row(children:[
            Flexible(
              child:TextField(
                controller: searchTextController,
                onSubmitted: (value){

                  ref.read(focusSearchBar.notifier).state = false;
                  ref.read(focusSearchFilters.notifier).state = false;

                  ref.read(servicesProvider.notifier).resetForSearch();

                  var search_vals = value.toLowerCase().split(' ');
                  ref.read(searchBarInputFilterProvider.notifier).state = search_vals;

                  ref.read(servicesProvider.notifier).loadMore();
                },
                focusNode: _focusSearchBarNode,
                decoration: InputDecoration(
                  hintText: 'Search for services...',
                  filled: false,
                  // fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
          )),
            IconButton(onPressed: (){
              if (!ref.watch(focusSearchFilters)) {
                ref.read(focusSearchFilters.notifier).state = true;
              }
              else {
                ref.read(focusSearchFilters.notifier).state = false;
              }

            },
                // icon: Icon(Icons.filter_list)
                // icon: Icon(Icons.edit_attributes_outlined)
                icon: Icon(Icons.settings_suggest_outlined)
            ),
            ])))),

          // Expanded(
          //   child: Padding(
          //       padding: EdgeInsets.symmetric(horizontal: Gss.width * .03),
          //       child:
          //       loadingServiceItems == true ? Center(child: CircularProgressIndicator())
        // :
          ValueListenableBuilder<double>(
          valueListenable: categoriesSliderHeightNotifier,
          builder: (context, value, child) {
          return AnimatedContainer(
          // color: Theme.of(context).appBarTheme.backgroundColor,
          // color: Colors.red,
              duration: Duration(milliseconds: 200),
          height: value,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child:
          ServicesCategoriesChipsSlider());}),

       ref.watch(loadingServiceItemsProvider)?
       Expanded(
           child:Center(child:CircularProgressIndicator())):
       Expanded(
          child:  Padding(
            padding: EdgeInsets.symmetric(horizontal: Gss.width * .03),
              child: asyncServicesItems.when(
              loading: (){
                // return Container();
                return Center(child: CircularProgressIndicator());
                },
                error: (e_obj, e_stacktracke){
                lg.e("[ConnectMeClientHome asyncItems] error ~ " + e_obj.toString());
                lg.e(e_stacktracke.toString());
                return Center(child: Text('Error: Please try again later'));},
              data: (items) {
                if (items.isEmpty) {
                return Container(height: Gss.height * .44,
                child: Center(child: Text(nothingHereYetMessage,
                style: Theme.of(context).textTheme.bodyLarge,
                )));
              }
              if (items.isNotEmpty) {
                        lg.t("ConnectMeClientHome past items len ~ " + items.length.toString());
                        return ListView.builder(
                          physics: ClampingScrollPhysics(),
                        controller: homeScrollController,
                        itemCount: items.length + 1,
                        itemBuilder: (_, index){
                            lg.t("homeScroll build item ~ " + index.toString());
                        // if (index == 0){
                        // return ServicesCategoriesChipsSlider();
                        // }
                         if (index == 0) {
                           lg.t("build idx 0");
                          return Padding(
                              padding: EdgeInsets.symmetric(vertical: Gss.width * .03),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      searchHasFilters?
                                      "Search Results":
                                      "Featured Services", style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700),),
                                    // Text("See all", style: TextStyle(fontSize: 12.sr,
                                    //     color: Colors.blue
                                    // ))
                                  ]));
                        }
                        else {
                          lg.t("ret normal servicelistitem");
                        return ServiceListItem(
                            key: ValueKey(items[index - 1].serviceId),
                            serviceItem: items[index - 1]);
                        }
                        }
                      );
                    }

                    /// to ignore linter
                    lg.e("thing not able to build");
                    return Container();
                  },
                ),
              )),

          ref.watch(loadingServiceItemsProviderMore) ? Container(
            height: Gss.height * .15,
            child: Center(child: CircularProgressIndicator()),
          ):Container()

        ],
            ),
            )),
            Positioned(
              bottom: 0,
            right: 0,
            left: 0,
            child:
            Builder(builder:(context){
    lg.t("build Positioned ControlPanel ");
            return AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              height: !ref.watch(focusSearchFilters)?0:Gss.height * .45,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: ControlPanel()
              ),
            );})),
          ]);
  }
}

class ServicesCategoriesChipsSlider extends ConsumerWidget {
  const ServicesCategoriesChipsSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    lg.t("[ServicesCategoriesChipsSlider] build");

    return Container(
        // height: Theme.of(context).textTheme.labelMedium!.fontSize! *2.24 + 55,
        child:
        Column(
            mainAxisSize: MainAxisSize.min,
            children:[
          Padding(
              padding: EdgeInsets.symmetric(
              horizontal: 12.sr
              ),
              child:Row(children:[
              Padding(
              padding: EdgeInsets.symmetric(
              vertical: 4.sr
              ),
                child: Text("Categories", style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w700),)),
              ])),
          // Flexible(
          //     child:
          Container(
            // color: Colors.green,
          height: Theme.of(context).textTheme.labelMedium!.fontSize! *2.24 + 4.sr,
              child:ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:  serviceCategories.length,
                  itemBuilder: (_, index) {
                    if (serviceCategories[index].toLowerCase() == "any"){
                      return Container();
                    }
                    return
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.sr),
                          child:
                          InkWell(
                            onTap: () async {
                              if (ref.read(categoryFilterProvider) != serviceCategories[index]) {
                                ref.read(servicesProvider.notifier).resetForSearch();
                                ref.read(categoryFilterProvider.notifier).state = serviceCategories[index];
                                ref.read(searchBarInputFilterProvider.notifier).state = serviceCategories[index].toLowerCase().split(" ");
                                await ref.read(servicesProvider.notifier).loadMore().then((res){

                                });
                              }
                              else if (ref.read(categoryFilterProvider) == serviceCategories[index]) {
                                ref.read(categoryFilterProvider.notifier).state = null;
                                ref.read(searchBarInputFilterProvider.notifier).state = [];

                              }
                            },
                          child:Container(
                              decoration: BoxDecoration(
                                color:
                                ref.read(categoryFilterProvider.notifier).state == serviceCategories[index]?
                                // Theme.of(context).colorScheme.onPrimary:
                                appPrimarySwatch[700]:
                                Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: Theme.of(context).colorScheme.onSurface, width: 1.sr)
                              ),
                              child:
                              // Padding(
                              //   padding: EdgeInsets.symmetric(horizontal: 28, vertical: 2),
                              // child:
                              Center(child:
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 2.sr),
                              child:Text(serviceCategories[index],
                              style: TextStyle(fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                                fontWeight: FontWeight.w500,
                                color:
                                ref.read(categoryFilterProvider.notifier).state == serviceCategories[index]?
                                Colors.white: Theme.of(context).colorScheme.onSurface,
                                // ref.read(categoryFilterProvider.notifier).state == serviceCategories[index]?
                                // Theme.of(context).colorScheme.onSurface:
                                // Theme.of(context).colorScheme.onSurface,
                              // Colors.black:Colors.black
                              ),
                              ))))));
                  }))
        ]));
  }
}

// class ServicesCategoriesImagesSlider extends StatelessWidget {
//   const ServicesCategoriesImagesSlider({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         height: Gss.height * .2,
//         child:
//         Column(children:[
//           Padding(
//               padding: EdgeInsets.symmetric(vertical: Gss.width * .03),
//               child:Row(children:[
//                 Text("Categories", style: TextStyle(fontSize: 18.sr,
//                   fontWeight: FontWeight.w700,
//                 ),),
//               ])),
//           Expanded(
//               child:ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount:  serviceCategories.length,
//                   itemBuilder: (_, index) {
//                     return
//                       Padding(
//                           padding: EdgeInsets.symmetric(horizontal: Gss.width * .02),
//                           child:Container(
//                               width: Gss.width * .4,
//                               child:Stack(children:[
//                                 Container(
//                                   decoration:BoxDecoration(
//                                     image: DecorationImage(
//                                         image: AssetImage("assets/images/test/test_house.jpeg"),
//                                         fit: BoxFit.cover
//                                     ),
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                 ),
//                               ])));
//                   }))
//         ]));
//   }
// }


class ServiceListItem extends ConsumerWidget {
  const ServiceListItem({super.key,
  required this.serviceItem
  });

  final ServiceOffered serviceItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    lg.t("[ServiceListItem] build service list item 0");
    return
      /// *ListItemTapper* Need this one here too for search bar dismissal
      GestureDetector(
        behavior:
        // ref.watch(focusSearchBar) == true?
        // HitTestBehavior.translucent:
          HitTestBehavior.opaque,

        onTap: (){
          lg.t("push service detail");
          if ( ref.read(focusSearchBar.notifier).state == false) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ServiceDetail(service: serviceItem);
            }));
          }
        },
        child:
      Container(
        // height: 444.sr,
        width: Gss.width *.8,
        child:
        Column(children:[

          /// *ListItemTapper* Need this one here too
            GestureDetector(
            behavior: HitTestBehavior.opaque
                ,
            onTap: () {
              lg.t("Got stack second tap");
              if (ref.read(focusSearchBar)){
                ref.read(focusSearchBar.notifier).state = false;
                ref.read(focusSearchFilters.notifier).state = false;
              }
              else{
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return ServiceDetail(service: serviceItem);
                }));
              }
            },
            child:
          ClipRRect(
            borderRadius:
            BorderRadius.all(Radius.circular(8.sr),
            // topRight: Radius.circular(16)
            ),
          child:
          Stack(children:[
          ImageBuilderFromFutureUrl(path: serviceItem.featureImageId,
            width: Gss.width,
            height: Gss.width * .67,
          ),
          Positioned(top:4.sr,right:4.sr,
          child:
          Builder(builder:(context){
            lg.t("build ServiceListItemCategoryChip ");
          return ServiceListItemCategoryChip(
              categoryString: serviceItem.category
          );
          })
          )
          ])
          )),
          Padding(
         padding: EdgeInsets.symmetric(
                horizontal: Gss.width * .05,
                vertical: Gss.width * .02),
         child:Column(children:[
           SizedBox(height: Gss.height * .015),

              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                 Flexible(
                 child:
                       Text(serviceItem.name,
                    style: TextStyle(fontSize: 16.sr,
                      fontWeight: FontWeight.w800,
                    // ))
                  ))),
               ]),
                 SizedBox(height: Gss.height * .02),
                 serviceItem.rating != null && serviceItem.rating! > 0?
                 Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children:[
    RatingBar.builder(
                   initialRating: serviceItem.rating??0,
                   minRating: 0,
                   direction: Axis.horizontal,
                   allowHalfRating: true,
                   itemCount: 5, // 5 stars
                   itemSize: 22  ,
                   unratedColor: Colors.grey[300],
                   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                   itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                   onRatingUpdate: (rating) {
                     // setState(() {
                     //   _rating = rating;
                     // });
                     // ref.read(ratingFilterProvider.notifier).state = rating;
                   },
                   ignoreGestures: true,
               ),
                       Text("${serviceItem.rating}/5 (${serviceItem.ratingCount})",
                         style:TextStyle(fontSize:16.sr),
                       ),
                     ]):
                 Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children:[
                 Text("No ratings yet",
                   style: TextStyle(fontSize: 15.sr,
                     fontWeight: FontWeight.w300,
                   ),)]),
           SizedBox(height: Gss.height * .02),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    SI_BubbleWrap(wordList: serviceItem.keywords.where((s)=> s.toLowerCase().replaceAll(" ", "") != serviceItem.category.toLowerCase().replaceAll(" ", "")).toList())
                  ]),
              Builder(builder:(context){
                lg.t("right before double rows ");
           return SizedBox(height: Gss.height * .0225);}),
           Row(children:[
            Row(children:[
            Icon(Icons.access_time_rounded,
            size:14.sr,
            ),
            SizedBox(width: Gss.width * .01),
            // Text( serviceItem.timeLength.toString() + " mins",
            // style: TextStyle(fontSize: 12.sr,
            //   fontWeight: FontWeight.w300,
            // ),)
              serviceItem.timeLength != 0 && serviceItem  .timeLength != null?
              Text(formatMinutesToHours(serviceItem.timeLength!),
                  style: TextStyle(fontSize: 14.sr,
                    fontWeight: FontWeight.w300,
                  )):
              Text("No time limit",
                style: TextStyle(fontSize: 14.sr,
                  fontWeight: FontWeight.w300,
                ),)
            ]),
            Expanded(
            child:Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:[
            Text( formatCents(serviceItem.priceCents),
              style: TextStyle(fontSize: 16.sr,
                color: ref.watch(darkModeProv)?appPrimarySwatch[900]:primaryAccentColor0Light,
                fontWeight: FontWeight.w800,
              ),)]))

          ]),
        ]
      )),
          Builder(builder:(context){
            lg.t("build end Sized Box ");
          return SizedBox(height: Gss.height * .05);})
        ]
    )));
  }
}




// class FeaturedServiceHeader extends StatelessWidget {
//   const FeaturedServiceHeader({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: EdgeInsets.symmetric(vertical: Gss.width * .03),
//         child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("Featured Services", style: TextStyle(fontSize: 18.sr,
//                 fontWeight: FontWeight.w700,
//               ),),
//               // Text("See all", style: TextStyle(fontSize: 12.sr,
//               //     color: Colors.blue
//               // ))
//             ]));
//   }
// }



class SI_BubbleWrap extends ConsumerWidget {
   const SI_BubbleWrap({super.key,
  required this.wordList,
    this.alignment = WrapAlignment.start,
  });
  final List<String> wordList;
  final WrapAlignment? alignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      alignment: alignment?? WrapAlignment.start,
      spacing: 8,
      runSpacing: 8,
      children: wordList.map((word) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.sr, vertical: 4.sr),
          decoration: BoxDecoration(
            color:
            ref.watch(darkModeProv) ?
            appPrimarySwatch[900]:
            appPrimarySwatch[700],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            word,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color:
                ref.watch(darkModeProv) ?
                Theme.of(context).textTheme.bodyMedium?.color:
                Theme.of(context).colorScheme.onPrimary
            ),
          ),
        );
      }).toList(),
    );
  }
}
