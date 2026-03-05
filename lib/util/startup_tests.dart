

import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/requests/test/test_requests.dart';

runStartupTests() async {
  lg.d("runStartupTests called");
  await testPostReq();
  // await testLargReq();
}