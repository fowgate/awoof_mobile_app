/// A class to hold my [WalletTopUpHistory] model
class WalletTopUpHistory {

  /// Setting constructor for [WalletTopUpHistory] class
  WalletTopUpHistory({
    this.id,
    this.amount,
    this.userEmail,
    this.orderRef,
    this.paymentReference,
    this.paymentStatus,
    this.gatewayResponse,
    this.transactionDate,
  });

  /// A string variable to hold my topup id
  String? id;

  /// A string variable to hold my topup amount
  String? amount;

  /// A string variable to hold my topup user email
  String? userEmail;

  /// A string variable to hold my topup order reference
  String? orderRef;

  /// A string variable to hold my topup payment reference
  String? paymentReference;

  /// A string variable to hold my topup payment status
  String? paymentStatus;

  /// A string variable to hold my topup gateway response
  String? gatewayResponse;

  /// A DateTime variable to hold my topup transaction date
  DateTime? transactionDate;

  /// Creating a method to map my JSON values to the model details accordingly
  factory WalletTopUpHistory.fromJson(Map<String, dynamic> json) => WalletTopUpHistory(
    id: json["_id"],
    amount: json["amount"].toString(),
    userEmail: json["user_email"],
    orderRef: json["order_ref"],
    paymentReference: json["payment_reference"],
    paymentStatus: json["payment_status"],
    gatewayResponse: json["gateway_response"],
    transactionDate: DateTime.parse(json["transaction_date"]),
  );

}