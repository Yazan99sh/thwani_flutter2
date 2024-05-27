class PaymentConfiguration {
  String authKey;
  String remark;
  PaymentOption paymentOption;
  double amount;
  bool production = false;
  int timeoutInMilliseconds;

  PaymentConfiguration({
    required this.authKey,
    required this.remark,
    required this.paymentOption,
    required this.amount,
    required this.production,
    required this.timeoutInMilliseconds,
  });

  toJson() {
    return {
      'paymentDetails': {
        'authKey': authKey,
        'remark': remark,
        'paymentOption': paymentOption.value,
        'amount': amount,
        'production': production,
        'timeoutInMilliseconds': timeoutInMilliseconds
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
