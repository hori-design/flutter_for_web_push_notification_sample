import 'dart:convert';
import 'package:flutter_for_web_push_notification_sample/libs/js/subscribe_web_push/subscribe_web_push_type.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

@JS('subscribeWebPush')
external Object _subscribeWebPush(String validPublicKey);

Future<SubscribeResultType> subscribeWebPush(String vapidPublicKey) async {
  final resultStr = await promiseToFuture<String>(
    _subscribeWebPush(vapidPublicKey),
  );
  final result = jsonDecode(resultStr) as Map<String, dynamic>;
  final data = result['data'] as Map<String, dynamic>?;
  final code = result['code'] as String;

  if (code != 'SUCCEED') {
    return (
      data: null,
      code: code,
    );
  }

  final endpoint = data?['endpoint'] as String?;
  final p256dh = data?['p256dh'] as String?;
  final auth = data?['auth'] as String?;

  return (
    data: (
      endpoint: endpoint ?? '',
      p256dh: p256dh ?? '',
      auth: auth ?? '',
    ),
    code: code,
  );
}
