import 'package:flutter/material.dart';
import 'package:flutter_for_web_push_notification_sample/libs/js/check_is_subscribed_web_push/check_is_subscribed_web_push_html.dart';
import 'package:flutter_for_web_push_notification_sample/libs/js/check_is_web_push_supported/check_is_web_push_supported_html.dart';
import 'package:flutter_for_web_push_notification_sample/libs/js/subscribe_web_push/subscribe_web_push.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef OnCompletedCallBack = void Function({
  required String endpoint,
  required String p256dh,
  required String auth,
});

typedef UsePushNotificationRecord = ({
  void Function(OnCompletedCallBack onCompleted) subscribe,
});

typedef UsePushNotificationType = UsePushNotificationRecord Function();

UsePushNotificationType usePushNotification = () {
  final context = useContext();

  void showAlertDialog(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          GestureDetector(
            child: const Text('OK'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Future<void> subscribeWebPushNotification(
    OnCompletedCallBack onCompleted,
  ) async {
    const vapidPublicKey = String.fromEnvironment('VAPID_PUBLIC_KEY');
    final result = await subscribeWebPush(vapidPublicKey);
    switch(result.code) {
      case 'SUCCEED':
        final data = result.data;
        if (data != null) {
          onCompleted(
            endpoint: data.endpoint,
            p256dh: data.p256dh,
            auth: data.auth,
          );
        }
        return;
      case 'NOT_SUPPORTED':
        showAlertDialog('ご利用の環境は、通知がサポートされていません。');
        return;
      case 'DENIED':
        showAlertDialog('通知がブロックされています。ブラウザの設定を確認してください。');
        return;
      case 'CANCELED':
        showAlertDialog('通知が許可されませんでした。通知機能を使用する場合は、アプリを再起動して再度お試しください。');
        return;
      default:
        return;
    }
  }

  Future<void> subscribe(OnCompletedCallBack callBack) async {
    final isSupported = await checkIsWebPushSupported();
    if (!isSupported) {
      showAlertDialog('ご利用の環境は、通知がサポートされていません。');
      return;
    }

    final isSubscribed = await checkIsSubscribedWebPush();
    if (isSubscribed) {
      showAlertDialog('既に通知を購読しています。');
      return;
    }

    await subscribeWebPushNotification(callBack);
  }

  return (
    subscribe: subscribe,
  );
};
