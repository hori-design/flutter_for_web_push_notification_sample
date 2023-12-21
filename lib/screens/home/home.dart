import 'package:flutter/material.dart';
import 'package:flutter_for_web_push_notification_sample/hooks/use_push_notification.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notification = usePushNotification();

    Future<void> subscribeNotification() async {
      notification.subscribe(({
        required String endpoint,
        required String p256dh,
        required String auth,
      }) => {},);
    }

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: subscribeNotification,
          child: const Text('通知を購読する'),
        ),
      ),
    );
  }
}
