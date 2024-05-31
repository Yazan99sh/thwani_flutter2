import 'dart:async';

import 'package:flutter/services.dart';
import 'package:thawani_flutter/models/configuration.dart';
import 'package:thawani_flutter/models/payment_response.dart';
import 'thawani_flutter_platform_interface.dart';

class ThawaniFlutter {
  ThawaniFlutter._();

  static final ThawaniFlutter _instance = ThawaniFlutter._();

  factory ThawaniFlutter() => _instance;

  StreamController<PaymentResult> _paymentCallbackEvent =
      StreamController<PaymentResult>();

  Future<String?> makePayment(PaymentConfiguration configuration) {
    return ThawaniFlutterPlatform.instance.makePayment(configuration);
  }

  Future<String?> callBackHandler() {
    return _methodCallHandler(
      (event) {
        if (_paymentCallbackEvent.isClosed) {
          print(
              '############################################### paymentCallbackEvent was closed');
          _paymentCallbackEvent = StreamController<PaymentResult>();
        }
        var paymentResult = PaymentResult.fromJson(event.arguments);
        print(
            '############################################### we are sending the event to the stream');
        _paymentCallbackEvent.add(paymentResult);
        print(
            '############################################### we are sending the event to the stream');
        return Future.value("success");
      },
    );
  }

  Future<String?> _methodCallHandler(
      Future<String?> Function(MethodCall) handler) {
    return ThawaniFlutterPlatform.instance.methodCallHandler(handler);
  }

  StreamSubscription? _streamSubscription;

  startListening() {
    _streamSubscription = _paymentCallbackEvent.stream.listen((event) {
      print('###############################################');
      print(event);
      print('###############################################');
    });
  }

  stopListening() {
    _streamSubscription?.cancel();
  }
}
