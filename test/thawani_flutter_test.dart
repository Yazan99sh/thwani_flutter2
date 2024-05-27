import 'package:flutter/src/services/message_codec.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_flutter/models/configuration.dart';
import 'package:thawani_flutter/thawani_flutter.dart';
import 'package:thawani_flutter/thawani_flutter_platform_interface.dart';
import 'package:thawani_flutter/thawani_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockThawaniFlutterPlatform
    with MockPlatformInterfaceMixin
    implements ThawaniFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> makePayment(PaymentConfiguration configuration) {
    // TODO: implement makePayment
    throw UnimplementedError();
  }

  @override
  Future<String?> methodCallHandler(Future<String?> Function(MethodCall p1) helperHandler) {
    // TODO: implement methodCallHandler
    throw UnimplementedError();
  }
}

void main() {
  final ThawaniFlutterPlatform initialPlatform = ThawaniFlutterPlatform.instance;

  test('$MethodChannelThawaniFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelThawaniFlutter>());
  });

  test('getPlatformVersion', () async {
    ThawaniFlutter thawaniFlutterPlugin = ThawaniFlutter();
    MockThawaniFlutterPlatform fakePlatform = MockThawaniFlutterPlatform();
    ThawaniFlutterPlatform.instance = fakePlatform;

    expect('42', '42');
  });
}
