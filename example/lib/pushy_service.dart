import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pushy_flutter/pushy_flutter.dart';

import '../../main.dart';

class PushyService {
  static Future init() async {
    if (Platform.isWindows) {
      return;
    }
    Pushy.listen();
    await PushyService.pushyRegister();
    Pushy.setNotificationListener(backgroundNotificationListener);
    Pushy.setNotificationIcon('ic_notification');
  }

  static Future pushyRegister() async {
    try {
      // Register the user for push notifications
      String deviceToken = await Pushy.register();
      print('Pushy device token: $deviceToken');
      // Print token to console/logcat
      // print('Device token: $deviceToken');
      // send the token to the server
    } on PlatformException catch (error) {
      // Display an alert with the error message
      // await Sentry.captureException(
      //   error,
      //   stackTrace: StackTrace.current,
      // );
    }
  }
  static Future pushySubscribe(String topic) async {
    try {
      Pushy.subscribe(topic);
    } on PlatformException catch (error) {
      // Display an alert with the error message
      // await Sentry.captureException(
      //   error,
      //   stackTrace: StackTrace.current,
      // );
    }
  }
  static Future pushyUnSubscribe(String topic) async {
    try {
      Pushy.unsubscribe(topic);
    } on PlatformException catch (error) {
      // Display an alert with the error message
      // await Sentry.captureException(
      //   error,
      //   stackTrace: StackTrace.current,
      // );
    }
  }
}
