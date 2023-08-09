/// A class to hold my [AirtimeTopUpHistory] model
class AirtimeTopUpHistory {

  /// Setting constructor for [AirtimeTopUpHistory] class
  AirtimeTopUpHistory({
    this.id,
    this.recipientPhoneNumber,
    this.recipientPhoneCountryCode,
    this.requestedAmount,
    this.deliveredAmount,
    this.deliveredAmountCurrencyCode,
    this.requestedAmountCurrencyCode,
    this.amount,
    this.transactionId,
    this.operatorTransactionId,
    this.operatorId,
    this.operatorName,
    this.user,
    this.transactionDate,
  });

  /// A String? variable to hold my topup id
  String? id;

  /// A String? variable to hold recipeint phone number
  String? recipientPhoneNumber;

  /// A String? variable to hold my recipient country code
  String? recipientPhoneCountryCode;

  /// A String? variable to hold my requested amount
  String? requestedAmount;

  /// A String? variable to hold my delivered amount
  String? deliveredAmount;

  /// A String? variable to hold my delivered amount currency code
  String? deliveredAmountCurrencyCode;

  /// A String? variable to hold my requested amount currency code
  String? requestedAmountCurrencyCode;

  /// A String? variable to hold my amount
  String? amount;

  /// A String? variable to hold my transaction id
  String? transactionId;

  /// A String? variable to hold my operator transaction id
  String? operatorTransactionId;

  /// An integer variable to hold my operator id
  int? operatorId;

  /// A String? variable to hold my operator name
  String? operatorName;

  /// A String? variable to hold my user email
  String? user;

  /// A DateTime variable to hold my transaction date
  DateTime? transactionDate;

  /// Creating a method to map my JSON values to the model details accordingly
  factory AirtimeTopUpHistory.fromJson(Map<String?, dynamic> json) => AirtimeTopUpHistory(
    id: json["_id"].toString(),
    recipientPhoneNumber: json["recipientPhoneNumber"].toString(),
    recipientPhoneCountryCode: json["recipientPhoneCountryCode"].toString(),
    requestedAmount: json["requestedAmount"].toString(),
    deliveredAmount: json["deliveredAmount"].toString(),
    deliveredAmountCurrencyCode: json["deliveredAmountCurrencyCode"].toString(),
    requestedAmountCurrencyCode: json["requestedAmountCurrencyCode"].toString(),
    amount: json["amount"].toString(),
    transactionId: json["transactionId"].toString(),
    operatorTransactionId: json["operatorTransactionId"].toString(),
    operatorId: json["operatorId"],
    operatorName: json["operatorName"].toString(),
    user: json["user"].toString(),
    transactionDate: DateTime.parse(json["transactionDate"]),
  );

}
