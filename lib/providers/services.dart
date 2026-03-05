import 'dart:async';
import 'package:connectme_app/config/settings.dart';
import 'package:connectme_app/models/services/services.dart';
import 'package:connectme_app/requests/services/services.dart';
import 'package:connectme_app/util/lists.dart';
import 'package:connectme_app/util/location.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/config/logger.dart';

/// for pagination
// final servicesHasMoreProvider = StateProvider<bool>((ref) => true);

final loadingServiceItemsProviderMore = StateProvider<bool>((ref) => true);
final loadingServiceItemsProvider = StateProvider<bool>((ref) => true);

class PaginatedServices extends Notifier<AsyncValue<List<ServiceOffered>>> {
  final int _limit = 10;
  bool _hasMore = true;
  bool _isFetching = false;

  bool _remoteHasMore = true;
  bool _remoteIsFetching = false;

  @override
  AsyncValue<List<ServiceOffered>> build() {
    lg.t("[PaginatedServices] build called");
    _hasMore = true;
    state = const AsyncValue.loading();
    ref.read(loadingServiceItemsProvider.notifier).state = true;
    Future.microtask(loadMore);
    return state;
  }

  resetForSearch(){
    lg.t("reset hasmore true");
    // ref.read(filteredServicesProvider.notifier).state = AsyncValue.loading(); /// updates UI to loading screen
    ref.read(loadingServiceItemsProvider.notifier).state = true;
    _hasMore = true;
    _remoteHasMore = true;
    _isFetching = false;
    _remoteIsFetching = false;
    ref.read(lastGeoHashProvider.notifier).state = null;
    ref.read(lastServiceDocIdProvider.notifier).state = null;
  }

  refresh() {
    // ref.read(filteredServicesProvider.notifier).state = AsyncValue.loading(); /// updates UI to loading screen
    ref.read(loadingServiceItemsProvider.notifier).state = true;
    _hasMore = true;
    _remoteHasMore = true;
    _isFetching = false;
    _remoteIsFetching = false;
    ref.read(lastGeoHashProvider.notifier).state = null;
    ref.read(lastServiceDocIdProvider.notifier).state = null;
    state = AsyncData([]);
    loadMore();
  }

    Future<void> loadMore(
        ) async {
      lg.t("[PaginatedServices] loadMore called");
      if (appConfig.simulateNetworkLatency){
        await Future.delayed(Duration(seconds:2));
      }

      if (!_hasMore || _isFetching) {
        lg.t(
            "[PaginatedServices] loadMore skipped: hasMore=$_hasMore, isFetching=$_isFetching");
        return;
      }

      _isFetching = true;
      try {
        final newItems = await _fetchNext(
        );
        lg.t("Fetched new items setting state");
        state = AsyncData([...state.value ?? [],

          // new items, filtered to exclude already-present ids
          ...newItems.where((item) {
            final existingIds = (state.value ?? []).map((e) => e.serviceId).toSet();
            return !existingIds.contains(item.serviceId);
          })

        ]);

      } catch (e, st) {
        lg.e("[PaginatedServices] loadMore error: $e");
        lg.e(st.toString());
        state = AsyncError("Error loading services", st);
      } finally {
        _isFetching = false;
        ref.read(loadingServiceItemsProviderMore.notifier).state = false;
        ref.read(loadingServiceItemsProvider.notifier).state = false;
      }

      lg.t("[PaginatedServices] check if we want remotes");
      // check if we want remotes too
      if (!ref.read(serviceSiteFilterProvider)[2]){return;}

      lg.t("[PaginatedServices] remotes wanted");
      if (!_remoteHasMore || _remoteIsFetching){
        lg.t(
            "[PaginatedServices] loadMoreRemote skipped: hasMore=$_remoteHasMore, isFetching=$_remoteIsFetching");
        return;
      }

      _remoteIsFetching = true;
      try {
        lg.t("[PaginatedServices] do fetch next remote");
        final newItems = await _fetchNextRemote(
        );
        lg.t("Fetched new remote items setting state");
        state = AsyncData([...state.value ?? [],
          // new items, filtered to exclude already-present ids
          ...newItems.where((item) {
            final existingIds = (state.value ?? []).map((e) => e.serviceId).toSet();
            return !existingIds.contains(item.serviceId);
          })
        ]);

      } catch (e, st) {
        lg.e("[PaginatedServices] loadMoreRemote error: $e");
        lg.e(st.toString());
        state = AsyncError("Error loading services", st);
      } finally {
        _remoteIsFetching = false;
        ref.read(loadingServiceItemsProviderMore.notifier).state = false;
        ref.read(loadingServiceItemsProvider.notifier).state = false;
      }
    }

    Future<List<ServiceOffered>> _fetchNext(
        ) async {
      lg.t("[PaginatedServices] _fetchNext called");
      logFilterProviders(ref);
      lg.t("Using lastGeoHash=${ref.read(lastGeoHashProvider)}, lastDocId=${ref.read(lastServiceDocIdProvider)}");
      List<ServiceOffered> newItems = [];
      if (state is AsyncError) {
        return [];
      }
      try {
        final resp = await fetchServices(
          lastGeoHash:ref.read(lastGeoHashProvider),
          lastDocId: ref.read(lastServiceDocIdProvider),
          distanceMetric: convDistanceStandardToMetricInt(ref.read(distanceStandardProvider)),
          category: ref.read(categoryFilterProvider),
          keywords: ref.read(keywordFilterProvider),
          rating: ref.read(ratingFilterProvider),
        );
        // lg.t("[PaginatedServices] resp ~ " + resp.toString());
        newItems = (resp["services"] as List)
            .map<ServiceOffered>((e) => ServiceOffered.fromJson(e))
            .toList();

        ref.read(lastGeoHashProvider.notifier).state = resp["lastGeoHash"];
        ref.read(lastServiceDocIdProvider.notifier).state = resp["lastDocId"];
        lg.t("[PaginatedServices] fetched ${resp["services"].length} items");

        if (newItems.length < _limit) {
          lg.t("setting hasMore to false");
          _hasMore = false;
          // ref.read(servicesHasMoreProvider.notifier).state = false;
        }
        // lg.t("returning newItems ~ " + newItems.toString());
        return newItems;
      }
      catch (e, st) {
        lg.e("[PaginatedServices] _fetchNext caught error: $e");
        lg.e(st.toString());
        state = AsyncError("Error loading services", st);
        return [];
      }
      finally {
        _isFetching = false;
        ref.read(loadingServiceItemsProviderMore.notifier).state = false;
      }
    }

  Future<List<ServiceOffered>> _fetchNextRemote(
      ) async {
    lg.t("[PaginatedServices] _fetchNextRemote called");
    // logFilterProviders(ref);
    lg.t("Using lastDocId=${ref.read(lastRemoteServiceDocIdProvider)}");
    List<ServiceOffered> newItems = [];
    if (state is AsyncError) {
      return [];
    }
    try {
      final resp = await fetchRemoteServices(
        // lastGeoHash:ref.read(lastGeoHashProvider),
        lastDocId: ref.read(lastServiceDocIdProvider),
        // distanceMetric: convDistanceStandardToMetricInt(ref.read(distanceStandardProvider)),
        category: ref.read(categoryFilterProvider),
        keywords: ref.read(keywordFilterProvider),
        rating: ref.read(ratingFilterProvider),
      );
      // lg.t("[PaginatedServices] resp ~ " + resp.toString());
      newItems = (resp["services"] as List)
          .map<ServiceOffered>((e) => ServiceOffered.fromJson(e))
          .toList();


      ref.read(lastRemoteServiceDocIdProvider.notifier).state = resp["lastDocId"];
      lg.t("[PaginatedServices] fetched ${resp["services"].length} items");

      if (newItems.length < _limit) {
        lg.t("setting hasMore to false");
        _remoteHasMore = false;
        // ref.read(servicesHasMoreProvider.notifier).state = false;
      }
      // lg.t("returning newItems ~ " + newItems.toString());
      return newItems;
    }
    catch (e, st) {
      lg.e("[PaginatedServices] _fetchNextRemote caught error: $e");
      lg.e(st.toString());
      state = AsyncError("Error loading services", st);
      return [];
    }
    finally {
      _remoteIsFetching = false;
      ref.read(loadingServiceItemsProviderMore.notifier).state = false;
    }
  }


  clear(){
    lg.t("Paginat4edServices Notifier clear called");
    state = AsyncData([]);
  }


  }


logFilterProviders(ref){
  lg.t("distance metric ~ " + ref.read(distanceStandardProvider).toString());
  lg.t("service site filter ~ " + ref.read(serviceSiteFilterProvider).toString());
  lg.t("category filter ~ " + ref.read(categoryFilterProvider).toString());
  lg.t("keyword filter ~ " + ref.read(keywordFilterProvider).toString());
  lg.t("rating filter ~ " + ref.read(ratingFilterProvider).toString());
  lg.t("search bar filter ~ " + ref.read(searchBarInputFilterProvider).toString());
}




final lastGeoHashProvider = StateProvider<String?>((ref) => null);
final lastServiceDocIdProvider = StateProvider<String?>((ref) => null);
final categoryFilterProvider = StateProvider<String?>((ref) => null);

final lastRemoteServiceDocIdProvider = StateProvider<String?>((ref) => null);

final searchBarInputFilterProvider = StateProvider<List<String>>((ref) => []);
// ['any', '3', '25', '100', '750'];
final distanceStandardProvider = StateProvider<String?>((ref) => null);

/// order is important is [on site, client site remote, delivery] for now...
final serviceSiteFilterProvider = StateProvider<List<bool>>((ref) => [true, true, true, true]);

final keywordFilterProvider = StateProvider<List<String>?>((ref) => null);
final ratingFilterProvider = StateProvider<double?>((ref) => null);


bool userInRange(String userGeoHash, String serviceGeoHash, int? distanceKm) {
  lg.t("calc user in range ~ ");
  if (distanceKm == null){
    lg.t("distanceKm is null retting true");
    return true;
  }

  final distanceToPrecision = {
    5: 5,
    39: 4,
    156: 3,
    1250: 2,
    5000: 1,
  };
  final prefixLength = distanceToPrecision[distanceKm];
  lg.t("get prefix len ~ " + prefixLength.toString());
  return userGeoHash.substring(0, prefixLength) == serviceGeoHash.substring(0, prefixLength);
}

bool siteMatches(List<bool> filters, String site) {
  const siteOrder = [
    "on site",
    "client site",
    "remote",
    "delivery",
  ];

  for (int i = 0; i < siteOrder.length; i++) {
    if (filters[i] && site.toLowerCase().replaceAll(" ", "").replaceAll("-", "").replaceAll("_", "") ==
        siteOrder[i].toLowerCase().replaceAll(" ", "").replaceAll("-", "").replaceAll("_", "")) {
      return true;
    }
  }

  return false;
}


final servicesProvider =
NotifierProvider<PaginatedServices, AsyncValue<List<ServiceOffered>>>(() => PaginatedServices());


final filteredServicesProvider = StateProvider<AsyncValue<List<ServiceOffered>>>((ref) {
  final allItems = ref.watch(servicesProvider);
  final distanceStandard = ref.watch(distanceStandardProvider);
  final siteFilter = ref.watch(serviceSiteFilterProvider);
  final category = ref.watch(categoryFilterProvider);
  final keywords = ref.watch(keywordFilterProvider);
  final rating = ref.watch(ratingFilterProvider);
  final searchBar = ref.watch(searchBarInputFilterProvider);
  final clientGeoHash = ref.watch(clientUserMetaProv)!.geoHash;

  return allItems.when(
    data: (items) {

      List<String> keywordsPlusSearchbar = keywords??[];
          keywordsPlusSearchbar.addAll(searchBar);

      return filterServices(
        allItems,
        clientGeoHash,
        distanceStandard != null ? convDistanceStandardToMetricInt(distanceStandard) : null,
        siteFilter,
        category,
        keywords,
        rating,
        searchBar,
      );

    },
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

AsyncValue<List<ServiceOffered>> filterServices(
    AsyncValue<List<ServiceOffered>> allItems,
    String? clientGeoHash,
    int? distanceMetric,
    List<bool> siteFilter,
    String? category,
    List<String>? keywords,
    double? rating,
    List<String> searchBar,
    ) {
  return allItems.when(
    data: (items) {

      lg.t("filter with client geoHash ~ $clientGeoHash");
      lg.t("filter with distanceMetric ~ $distanceMetric");
      lg.t("filter with searchBar ~ $searchBar");
      lg.t("filter with keywords ~ $keywords");
      lg.t("filter with rating ~ $rating");
      lg.t("filter with category ~ $category");

      List<String> keywordsPlusSearchbar = [...?keywords, ...searchBar];

      final filtered = items.where((item) {
        final matchesDistance = distanceMetric == null ||
            item.geoHash == null ||
            clientGeoHash == null ||
            userInRange(
              clientGeoHash,
              item.geoHash!,
              distanceMetric,
            );
        // lg.t("item matchesDistance ~ " + matchesDistance.toString());
        //
        // lg.t("check category ~ " + category.toString());
        // lg.t("item category ~ " + item.category.toString());
        final matchesCategory = category == null || (item.category.toLowerCase() == category.toLowerCase());
        // lg.t("matchesCategory ~ " + matchesCategory.toString());

        /// Split category into list to check with keywords
        List<String> checkCatergoryKeywords = item.category.toLowerCase().split(" ");
        final matchesKeyword = (keywords == null && searchBar.isEmpty) ||
            listsHaveMatchingKeyword(item.keywords, keywordsPlusSearchbar) ||
            listsHaveMatchingKeyword(checkCatergoryKeywords, keywordsPlusSearchbar);


        final matchesRating = rating == null || (item.rating ?? 5) >= rating;
        // lg.t("matchesRating ~ " + matchesRating.toString());

        final matchesSite = siteFilter.isEmpty || siteMatches(siteFilter, item.site);


        return matchesDistance &&
            matchesCategory &&
            matchesKeyword &&
            matchesRating &&
            matchesSite;
      }).toList();

      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
}


class VendorServices extends Notifier<AsyncValue<List<ServiceOffered>>> {

  @override
  AsyncValue<List<ServiceOffered>> build(){
    fetchInitial();
    return const AsyncValue.loading();
  }

  refresh(){
    fetchInitial();
  }

  Future<void> fetchInitial() async {
    lg.t("[VendorServices] fetchInitial called");
    if (appConfig.simulateNetworkLatency){
      await Future.delayed(Duration(milliseconds: 1000), () {}); /// simulate latency
    }
    try {
      final vendorUserId = ref.read(userAuthProv)!.userId;
      final newItems = await fetchProviderServices(vendorUserId);
      state = AsyncValue.data(newItems);
    } catch (e, st) {
      lg.e("[VendorServices] initial fetch error: $e");
      lg.e(st.toString());
        state = AsyncValue.error(e, st);
    }
  }

  clear(){
        lg.t("VendorServices Notifier clear called");
        state = AsyncData([]);
  }

}


final vendorServicesProvider = NotifierProvider<VendorServices,
    AsyncValue<List<ServiceOffered>>>(() {
  return VendorServices();
});

