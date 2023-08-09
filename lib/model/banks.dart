/// A class to hold my [Banks] model
class Banks {
  /// Setting constructor for [Banks] class
  Banks({
    this.id,
    required this.bankName,
    required this.bankCode,
    required this.accountName,
    required this.accountNumber,
    this.userEmail,
    this.createdAt
  });

  /// A String? variable to hold my user id
  String? id;

  /// A String? variable to hold my bank name
  String? bankName;

  /// A String? variable to hold my bank code
  String? bankCode;

  /// A String? variable to hold my account name
  String? accountName;

  /// A String? variable to hold my account number
  String? accountNumber;

  /// A String? variable to hold my user email
  String? userEmail;

  /// A String? variable to hold the created at time
  String? createdAt;

  /// Creating a method to map my JSON values to the model details accordingly
  factory Banks.fromJson(Map<String?, dynamic> json) {
    return Banks(
      id: json["_id"] == null ? null : json["_id"].toString(),
      bankName: json["bankName"] == null ? null : json["bankName"].toString(),
      bankCode: json["bankCode"] == null ? null : json["bankCode"].toString(),
      accountName: json["accountName"] == null ? null : json["accountName"].toString(),
      accountNumber: json["accountNumber"] == null ? null : json["accountNumber"].toString(),
      userEmail: json["user"] == null ? null : json["user"].toString(),
      createdAt: json["created_at"] == null ? null : json["created_at"].toString()
    );
  }

}
