import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:thawani_flutter/models/configuration.dart';

import 'thawani_flutter_method_channel.dart';

abstract class ThawaniFlutterPlatform extends PlatformInterface {
  /// Constructs a ThawaniFlutterPlatform.
  ThawaniFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static ThawaniFlutterPlatform _instance = MethodChannelThawaniFlutter();

  /// The default instance of [ThawaniFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelThawaniFlutter].
  static ThawaniFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ThawaniFlutterPlatform] when
  /// they register themselves.
  static set instance(ThawaniFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> makePayment(PaymentConfiguration configuration) {
    throw UnimplementedError('makePayment() has not been implemented.');
  }

  Future<String?> methodCallHandler(
      Future<String?> Function(MethodCall) helperHandler) {
    throw UnimplementedError('methodCallHandler() has not been implemented.');
  }
}
