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

  Future<Map<Object?, Object?>?> makePayment(PaymentConfiguration configuration) {
    _paymentCallbackEvent.close();
    return ThawaniFlutterPlatform.instance.makePayment(configuration);
  }

  Future<String?> callBackHandler() {
    return _methodCallHandler(
      (event) {
        if (_paymentCallbackEvent.isClosed) {
          _paymentCallbackEvent = StreamController<PaymentResult>();
        }
        var paymentResult = PaymentResult.fromJson(event.arguments);
        _paymentCallbackEvent.add(paymentResult);
        return Future.value("success");
      },
    );
  }

  Future<String?> _methodCallHandler(
      Future<String?> Function(MethodCall) handler) {
    return ThawaniFlutterPlatform.instance.methodCallHandler(handler);
  }

  StreamSubscription? _streamSubscription;

  startListening(Function(PaymentResult) callback) {
    _streamSubscription = _paymentCallbackEvent.stream.listen((event) {
      print('###############################################');
      print(event);
      callback(event);
      print('###############################################');
    });
  }

  stopListening() {
    _streamSubscription?.cancel();
  }
}
