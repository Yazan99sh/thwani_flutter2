import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:thawani_flutter/models/configuration.dart';

import 'thawani_flutter_platform_interface.dart';

/// An implementation of [ThawaniFlutterPlatform] that uses method channels.
class MethodChannelThawaniFlutter extends ThawaniFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('thawani_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> makePayment(PaymentConfiguration configuration) async {
    final result = await methodChannel.invokeMethod<String>(
        'makePayment', configuration.toJson());
    return result;
  }

  @override
  Future<String?> methodCallHandler(
      Future<String?> Function(MethodCall) helperHandler) async {
    methodChannel.setMethodCallHandler((call) => helperHandler(call));
    return null;
  }
}
