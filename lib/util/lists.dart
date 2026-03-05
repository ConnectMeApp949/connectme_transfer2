
import 'package:connectme_app/config/logger.dart';

bool listsHaveMatchingKeyword(List<String> itemKeywords, List<String> searchKeywords) {
  lg.t("[listsHaveMatchingKeyword] called with itemKeywords , searchKeywords");
  lg.t("itemKeywords ~ " + itemKeywords.toString());
  lg.t("searchKeywords ~ " + searchKeywords.toString());

  return itemKeywords.map((k) => k.toLowerCase()).any(
        (ik) => searchKeywords.any((sk) => ik.contains(sk.toLowerCase())),
  );
}


