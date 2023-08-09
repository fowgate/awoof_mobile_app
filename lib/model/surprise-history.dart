/// A class to hold my [SurpriseHistory] model
class SurpriseHistory {

  /// Setting constructor for [SurpriseHistory] class
  SurpriseHistory({
    this.id,
    this.amount,
    this.type,
    this.narration,
    this.user,
    this.transactionDate,
  });

  /// A String? variable to hold my surprise id
  String? id;

  /// A String? variable to hold my surprise amount
  String? amount;

  /// A String? variable to hold my surprise type
  String? type;

  /// A String? variable to hold my surprise narration
  String? narration;

  /// A String? variable to hold my surprise user email
  String? user;

  /// A DateTime variable to hold my surprise transaction date
  DateTime? transactionDate;

  /// Creating a method to map my JSON values to the model details accordingly
  factory SurpriseHistory.fromJson(Map<String?, dynamic> json) => SurpriseHistory(
    id: json["_id"],
    amount: json["amount"].toString(),
    type: json["type"],
    narration: json["narration"],
    user: json["user"],
    transactionDate: DateTime.parse(json["createdAt"]),
  );
}
