import 'dart:async';

import 'package:flutter/services.dart';
import 'package:thawani_flutter/models/configuration.dart';
import 'package:thawani_flutter/models/payment_response.dart';
import 'thawani_flutter_platform_interface.dart';

class ThawaniFlutter {
   static StreamController<PaymentResult> paymentCallbackEvent =
      StreamController<PaymentResult>();

  Future<String?> makePayment(PaymentConfiguration configuration) {
    return ThawaniFlutterPlatform.instance.makePayment(configuration);
  }

  Future<String?> callBackHandler() {
    return _methodCallHandler(
      (event) {
        if (paymentCallbackEvent.isClosed) {
          paymentCallbackEvent = StreamController<PaymentResult>();
        }
        var paymentResult = PaymentResult.fromJson(event.arguments);
        paymentCallbackEvent.add(paymentResult);
        return Future.value("success");
      },
    );
  }

  Future<String?> _methodCallHandler(
      Future<String?> Function(MethodCall) handler) {
    return ThawaniFlutterPlatform.instance.methodCallHandler(handler);
  }
}
