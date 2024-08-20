import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pushy_flutter/pushy_flutter.dart';
import 'package:thawani_flutter/models/configuration.dart';
import 'package:thawani_flutter/thawani_flutter.dart';
import 'package:thawani_flutter_example/notification_response.dart';
import 'package:thawani_flutter_example/notification_type.dart';
import 'package:thawani_flutter_example/pushy_service.dart';

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
    PushyService.init().whenComplete(() {
      PushyService.pushySubscribe('payment_thwani');
    });
    _thawaniFlutterPlugin.startListening((event) {
      print('===========================================');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: SafeArea(
        top: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  'Payment Awaiting!',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SvgPicture.asset(
              'assets/images/check.svg',
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.1),
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Amount',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Text(
                        'XX AED',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     try {
            //       final result = await _thawaniFlutterPlugin
            //           .makePayment(PaymentConfiguration(
            //         authKey: 'saddasd',
            //         remark: 'POS TESTING',
            //         paymentOption: PaymentOption.cardAccept,
            //         amount: 1,
            //         production: false,
            //         timeoutInMilliseconds: 3000,
            //         sendNotification: false,
            //         notificationToken:
            //             '',
            //         notificationTopic: 'payment_receiver',
            //       ));
            //     } on PlatformException catch (e) {
            //       print(e);
            //     }
            //   },
            //   child: const Text('Open Thawani POS'),
            // ),


          ],
        ),
      )),
    );
  }
}

@pragma('vm:entry-point')
void backgroundNotificationListener(Map<String, dynamic> data) {
  // Print notification payload data
  // TODO : in case of testing  print('Received notification: $data');

  // Notification title
  String notificationTitle = 'MyApp';

  // Attempt to extract the "message" property from the payload: {"message":"Hello World!"}
  String notificationText = data['message'] ?? 'Hello World!';

  // Android: Displays a system notification
  // iOS: Displays an alert dialog
  //Pushy.notify(notificationTitle, notificationText, data);
  if (data['notificationType'] == 1) {
    _thawaniFlutterPlugin.makePayment(PaymentConfiguration(
      authKey: 'asdasdad',
      remark: 'POS TESTING',
      paymentOption: PaymentOption.cardAccept,
      amount: ((data['amount'] as num?)?.toDouble() ?? 10.0) / 10,
      production: false,
      timeoutInMilliseconds: 3000,
      sendNotification: true,
      notificationToken:
          'dasda',
      notificationTopic: 'sdadasd',
    ));
  }
}

// parseNotification(Map<String, dynamic> data) {
//   var notification = NotificationResponse.fromJson(data);
//   if (notification.notificationType == NotificationTypeEnum.payment) {
//     if (notification.paymentStatus == true) {
//       donationSuccessMode();
//     } else {
//       donationMode();
//       print('Error', 'Payment failed : ${notification.message}');
//     }
//   }
// }
