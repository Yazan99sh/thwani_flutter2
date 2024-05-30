class PaymentResult {
  bool status;
  String? message;
  String? paymentId;
  String? invoice;
  int? paymentStatus;

  PaymentResult({
    required this.status,
    required this.message,
    this.paymentId,
    this.invoice,
    this.paymentStatus,
  });

  factory PaymentResult.fromJson(Map json) {
    return PaymentResult(
      status: json['status'],
      message: json['message'],
      paymentId: json['paymentId'],
      invoice: json['invoice'],
      paymentStatus: json['paymentStatus'],
    );
  }
}
