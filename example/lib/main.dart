import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:thawani_flutter/models/configuration.dart';
import 'package:thawani_flutter/thawani_flutter.dart';

late ThawaniFlutter _thawaniFlutterPlugin;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _thawaniFlutterPlugin = ThawaniFlutter();
  _thawaniFlutterPlugin.callBackHandler();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _thawaniFlutterPlugin.paymentCallbackEvent.stream.listen((event) {
      print('###############################################');
      print(event);
      print('###############################################');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ElevatedButton(
          onPressed: () async {
            final result = await _thawaniFlutterPlugin.makePayment(
                PaymentConfiguration(
                    authKey: 'authKey',
                    remark: 'POS TESTING',
                    paymentOption: PaymentOption.cardAccept,
                    amount: 0.15,
                    production: false,
                    timeoutInMilliseconds: 3000));
            print(result);
          },
          child: const Text('Make Payment'),
        ),
      ),
    );
  }
}
