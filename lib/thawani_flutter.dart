import 'dart:async';

import 'package:flutter/services.dart';
import 'package:thawani_flutter/models/configuration.dart';
import 'package:thawani_flutter/models/payment_response.dart';
import 'thawani_flutter_platform_interface.dart';

class ThawaniFlutter {
  ThawaniFlutter._singleton();

  static final ThawaniFlutter _instance = ThawaniFlutter._singleton();

  factory ThawaniFlutter() {
    return _instance;
  }

  StreamController<PaymentResult> paymentCallbackEvent =
      StreamController<PaymentResult>();

  Future<String?> makePayment(PaymentConfiguration configuration) {
    print('############################################### we are tried to make a payment');
    return ThawaniFlutterPlatform.instance.makePayment(configuration);
  }

  Future<String?> callBackHandler() {
    return _methodCallHandler(
      (event) {
        if (paymentCallbackEvent.isClosed) {
          print('############################################### paymentCallbackEvent was closed');
          paymentCallbackEvent = StreamController<PaymentResult>();
        }
        var paymentResult = PaymentResult.fromJson(event.arguments);
        print('############################################### we are sending the event to the stream');
        paymentCallbackEvent.add(paymentResult);
        print('############################################### we are sending the event to the stream');
        return Future.value("success");
      },
    );
  }

  Future<String?> _methodCallHandler(
      Future<String?> Function(MethodCall) handler) {
    return ThawaniFlutterPlatform.instance.methodCallHandler(handler);
  }
}
