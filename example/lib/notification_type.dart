enum NotificationTypeEnum {
  payment,
  unkown,
  ;

  const NotificationTypeEnum();

  static NotificationTypeEnum getEnum(int value) {
    switch (value) {
      case 1:
        return NotificationTypeEnum.payment;
      case -1:
        return NotificationTypeEnum.unkown;
      default:
        return NotificationTypeEnum.unkown;
    }
  }
}
