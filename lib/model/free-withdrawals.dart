/// A class to hold my [FreeWithdrawalHistory] model
class FreeWithdrawalHistory {

  /// Setting constructor for [FreeWithdrawalHistory] class
  FreeWithdrawalHistory({
    required this.id,
    required this.user,
    required this.amount,
    required this.recipientCode,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    required this.bankCode,
    required this.paid,
    this.status,
    required this.payAt,
    required this.transactionDate,
  });

  /// A String? variable to hold my transfer user email
  String? id;

  /// A String? variable to hold my transfer user email
  String? user;

  /// A String? variable to hold my transfer amount
  double? amount;

  /// A String? variable to hold my recipient code
  String? recipientCode;

  /// A String? variable to hold my account name
  String? accountName;

  /// A String? variable to hold my account number
  String? accountNumber;

  /// A String? variable to hold my bank name
  String? bankName;

  /// A String? variable to hold my bank code
  String? bankCode;

  /// A String? variable to hold my paid status
  bool? paid;

  /// A String? variable to hold my transaction status
  String? status;

  /// A DateTime variable to hold my transaction pay at
  DateTime payAt;

  /// A DateTime variable to hold my transfer transaction date
  DateTime transactionDate;

  /// Creating a method to map my JSON values to the model details accordingly
  factory FreeWithdrawalHistory.fromJson(Map<String?, dynamic> json) => FreeWithdrawalHistory(
    id: json["_id"],
    user: json["user"],
    amount: double.parse(json["amount"].toString()),
    recipientCode: json["recipient_code"] ?? null,
    accountName: json["accountName"] ?? null,
    accountNumber: json["accountNumber"] ?? null,
    bankName: json["bankName"] ?? null,
    bankCode: json["bankCode"] ?? null,
    paid: json["paid"] ?? null,
    payAt: DateTime.parse(json["payAt"]),
    transactionDate: DateTime.parse(json["createdAt"]),
  );
}
