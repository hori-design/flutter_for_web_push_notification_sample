import 'package:js/js.dart';
import 'package:js/js_util.dart';

@JS('checkIsWebPushSupported')
external bool _checkIsWebPushSupported();

Future<bool> checkIsWebPushSupported() {
  return promiseToFuture<bool>(_checkIsWebPushSupported());
}
