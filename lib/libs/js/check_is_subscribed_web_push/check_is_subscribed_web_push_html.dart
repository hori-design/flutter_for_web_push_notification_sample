import 'package:js/js.dart';
import 'package:js/js_util.dart';

@JS('checkIsSubscribedWebPush')
external Object _checkIsSubscribedWebPush();

Future<bool> checkIsSubscribedWebPush() {
  return promiseToFuture<bool>(_checkIsSubscribedWebPush());
}
