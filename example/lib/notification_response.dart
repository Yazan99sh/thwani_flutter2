import 'package:thawani_flutter_example/notification_type.dart';

class NotificationResponse {
  NotificationTypeEnum? notificationType;
  bool? paymentStatus;
  String? transacionsReference;
  String? message;

  NotificationResponse({
    this.paymentStatus,
    this.transacionsReference,
    this.message,
    this.notificationType,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      NotificationResponse(
        paymentStatus: json['paymentStatus'] as bool?,
        transacionsReference: json['transacionsReference'] as String?,
        message: json['message'] as String?,
        notificationType: NotificationTypeEnum.getEnum(json['notificationType'] as int)
      );
}
