import 'package:awoof_app/utils/payment-card-utils.dart';

/// Class holding the the model of payment card details
class MyPaymentCard {
  /// [MyCardType] model holding the type of the card
  MyCardType? type;

  /// String variable holding the card number
  String? number;

  /// String variable holding the card name
  String? name;

  /// String variable holding the card expiry month
  int? expiryMonth;

  /// String variable holding the card expiry year
  int? expiryYear;

  /// String variable holding the card cvc
  int? cvc;

  /// Constructor for my class
  MyPaymentCard({
    this.type,
    this.number,
    this.name,
    this.expiryMonth,
    this.expiryYear,
    this.cvc
  });

  /// A function mapping the details to form a string
  @override
  String toString() {
    return '[Type: $type, Number: $number, Name: $name, Month: $expiryMonth, Year: $expiryYear, CVV: $cvc]';
  }
}