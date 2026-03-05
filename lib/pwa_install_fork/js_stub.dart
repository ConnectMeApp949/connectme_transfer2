import '../config/logger.dart';

class JS {
  final String? name;
  const JS([this.name]);
}

allowInterop<F extends Function>(F f){
  lg.w("JS interop not supported");
  // throw UnimplementedError();
}