/// A class to hold my [TransferHistory] model
class TransferHistory {

  /// Setting constructor for [TransferHistory] class
  TransferHistory({
    this.id,
    this.amount,
    this.phoneNumber,
    this.narration,
    this.user,
    this.transactionDate,
  });

  /// A string variable to hold my transfer id
  String? id;

  /// A string variable to hold my transfer amount
  String? amount;

  /// A string variable to hold my transfer phone number
  String? phoneNumber;

  /// A string variable to hold my transfer narration
  String? narration;

  /// A string variable to hold my transfer user email
  String? user;

  /// A DateTime variable to hold my transfer transaction date
  DateTime? transactionDate;

  /// Creating a method to map my JSON values to the model details accordingly
  factory TransferHistory.fromJson(Map<String, dynamic> json) => TransferHistory(
    id: json["_id"],
    amount: json["amount"].toString(),
    phoneNumber: json["phoneNumber"],
    narration: json["narration"],
    user: json["user"],
    transactionDate: DateTime.parse(json["transaction_date"]),
  );
}
