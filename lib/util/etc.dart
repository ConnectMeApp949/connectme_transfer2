import 'dart:math';



String generateRandomAlphanumeric(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final rand = Random.secure();
  return List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
}




List<int> convertToHoursAndMinutes(int totalMinutes) {
  if (totalMinutes % 15 != 0) {
    throw ArgumentError('Input must be a multiple of 15.');
  }

  int hours = totalMinutes ~/ 60;
  int minutes = totalMinutes % 60;
  return [hours, minutes];
}


String formatCents(int cents) {
  final dollars = cents ~/ 100;
  final remainder = cents % 100;

  if (remainder == 0) {
    return '\$$dollars';
  } else {
    final value = cents / 100.0;
    return '\$${value.toStringAsFixed(2)}';
  }
}


// Future<T> showLoadingWhile<T>({
//   required BuildContext context,
//   required Future<T> Function() task,
// }) async {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) => const Center(child: CircularProgressIndicator()),
//   );
//
//   try {
//     final result = await task();
//     return result;
//   } finally {
//     NavigatorPop_MountedSafe(context);
//   }
// }