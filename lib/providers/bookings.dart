import 'package:connectme_app/views/client_app/bookings/bookings_tab.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:connectme_app/models/bookings/booking.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/requests/bookings/bookings.dart';

import 'etc.dart';


/// for pagination
final upcomingHasMoreNotifierProvider = StateProvider<bool>((ref) => true);

class PaginatedBookingsUpcoming extends AsyncNotifier<List<Booking>> {
  final int _limit = 10; /// make sure to sync with server
  bool _hasMore = true;
  bool _isFetching = false;

  @override
  Future<List<Booking>> build() async {
    lg.t("[PaginatedBookingsUpcoming] build called");
    _hasMore = true;
    return _fetchNext();
  }

  Future<void> loadMore() async {
    lg.t("[PaginatedBookingsUpcoming] loadMore called");
    if (!_hasMore || _isFetching){
      lg.t("[PaginatedBookingsUpcoming] loadMore called but not needed _hasMore $_hasMore _isFetching $_isFetching");
      return;}
    _isFetching = true;
    try {
      final newItems = await _fetchNext();
      state = AsyncData([...state.value ?? [], ...newItems]);
    }
    catch (e, st) {
      lg.e("[PaginatedBookingsUpcoming loadMore error: $e");
      lg.e(st.toString());
      // Optionally notify UI or set a flag
    } finally {
      _isFetching = false;
    }
  }

  Future<List<Booking>> _fetchNext() async {
    // await Future.delayed(Duration(milliseconds: 300)); // simulate latency
    lg.t("[PaginatedBookingsUpcoming] _fetchNext called");
    List<Booking> newItems = [];
    if (state is AsyncError) {
      return [];
    }
    List bookingList =  state.value ?? [];
    lg.t("get last booking time");
    DateTime lastBookingTime = DateTime.now();
    if (bookingList.isNotEmpty) {
      lastBookingTime = bookingList.last.bookingTime;
    }
    lg.t("get user id");
    final userId = ref.read(userAuthProv)!.userId;
    final userToken = ref.read(userAuthProv)!.userToken;
    String ownerType = ref.read(userTypeProv)!.name;
    newItems = await fetchBookings(userToken, userId, ownerType, lastBookingTime, BookingTimeType.upcoming);

    if (newItems.length < _limit){
      _hasMore = false;
      ref.read(upcomingHasMoreNotifierProvider.notifier).state = false;
    }

    ref.read(bookingsCumNotifierProvider.notifier).addFromListIfNotPresent(newItems);

    return newItems;

  }

  reload()async {
    state = AsyncData([]);
    _hasMore = true;
    await loadMore();
  }

  void clear() {
    state = AsyncData([]);
  }

}

/// for pagination
final pastHasMoreNotifierProvider = StateProvider<bool>((ref) => true);


///  don't use these Async providers, they're more trouble than worth, I thought I cut them out sooner
class PaginatedBookingsPast extends AsyncNotifier<List<Booking>> {
  final int _limit = 10; /// make sure to sync with server
  bool _hasMore = true;
  bool _isFetching = false;

  @override
  Future<List<Booking>> build() async {
    lg.t("[PaginatedBookingsPast] build called");
    _hasMore = true;
    return _fetchNext();
  }

  Future<void> loadMore() async {
    lg.t("[PaginatedBookingsPast] loadMore called");
    if (!_hasMore || _isFetching){
      lg.t("[PaginatedBookingsPast] loadMore called but not needed _hasMore ~ " + _hasMore.toString()
      + "isFetching ~ " + _isFetching.toString());
      return;
    }

    _isFetching = true;
    try {
      final newItems = await _fetchNext();
      state = AsyncData([...state.value ?? [], ...newItems]);
    }
    catch (e, st) {
      lg.e("[PaginatedBookingsPast loadMore error: $e");
      lg.e(st.toString());
      state = AsyncError("Error loading bookings", st);

    } finally {
      _isFetching = false;
    }
  }

  Future<List<Booking>> _fetchNext() async {
    // await Future.delayed(Duration(milliseconds: 300)); // simulate latency
    lg.t("[PaginatedBookingsPast] _fetchNext called");
    List<Booking> newItems = [];
    if (state is AsyncError) {
      return [];
    }
    List bookingList =  state.value ?? [];
    lg.t("get last booking time");
    DateTime lastBookingTime = DateTime.now();
    if (bookingList.isNotEmpty) {
      lastBookingTime = bookingList.last.bookingTime;
    }
    lg.t("get user id");
    final userId = ref.read(userAuthProv)!.userId;
    final userToken = ref.read(userAuthProv)!.userToken;
    String ownerType = ref.read(userTypeProv)!.name;
    newItems = await fetchBookings(userToken, userId, ownerType ,lastBookingTime, BookingTimeType.past);

    if (newItems.length < _limit){
      _hasMore = false;
      ref.read(pastHasMoreNotifierProvider.notifier).state = false;
    }

    ref.read(bookingsCumNotifierProvider.notifier).addFromListIfNotPresent(newItems);

    return newItems;

  }

  reload()async {
    state = AsyncData([]);
    _hasMore = true;
    await loadMore();
  }


  void clear() {
    // List<Booking> cl_lst = [];
    // state = cl_lst;
      state = AsyncData([]);
  }

}


final bookingsPastProvider =
AsyncNotifierProvider<PaginatedBookingsPast, List<Booking>>(() => PaginatedBookingsPast());

final bookingsUpcomingProvider =
AsyncNotifierProvider<PaginatedBookingsUpcoming, List<Booking>>(() => PaginatedBookingsUpcoming());

/// cumulative because can't use the AsyncNotifiers, REMEMBER DONT USE ASYNC ONES
/// have to remove this later completely waste
// final bookingsCumProvider = StateProvider<List<Booking>>((ref) {
//   return [];
// });

class bookingsCumProvider extends Notifier<List<Booking>> {
  @override
  List<Booking> build() {
    return []; // Initial empty list
  }

  // Adds the string only if it's not already present
  void addFromListIfNotPresent(List<Booking> values) {

    for (Booking v in values) {
      if (!state.contains(v)) {
        state = [...state, v];
      }
    }

    /// do logging
    //   List bl = [];
    //   for (Booking b in state) {
    //     bl.add(b.bookingId);
    //   }
    //   lg.t("[bookingsCumProvider] bookings ids ~ " + bl.toString());

    }

  void remove(Booking value) {
    state = state.where((v) => v != value).toList();
  }

  void clear() {
    state = [];
  }
}

// Provider for the above Notifier
final bookingsCumNotifierProvider = NotifierProvider<bookingsCumProvider, List<Booking>>(
      () => bookingsCumProvider(),
);