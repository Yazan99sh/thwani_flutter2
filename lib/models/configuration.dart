class PaymentConfiguration {
  String authKey;
  String remark;
  PaymentOption paymentOption;
  double amount;
  bool production = false;
  int timeoutInMilliseconds;
  bool sendNotification;
  String? notificationToken;
  String? notificationTopic;

  PaymentConfiguration({
    required this.authKey,
    required this.remark,
    required this.paymentOption,
    required this.amount,
    required this.production,
    required this.timeoutInMilliseconds,
    required this.sendNotification,
    required this.notificationToken,
    required this.notificationTopic,
  });

  toJson() {
    return {
      'paymentDetails': {
        'authKey': authKey,
        'remark': remark,
        'paymentOption': paymentOption.value,
        'amount': amount,
        'production': production,
        'timeoutInMilliseconds': timeoutInMilliseconds,
        'sendNotification': sendNotification,
        'notificationToken': notificationToken,
        'notificationTopic': notificationTopic,
      },
    };
  }
}

enum PaymentOption {
  cardAccept('card_accept'),
  cardDecline('card_reject'),
  threeDSAccept('card_d_s_accept'),
  threeDSReject('card_d_s_reject'),
  ;

  final String value;

  const PaymentOption(this.value);
}
