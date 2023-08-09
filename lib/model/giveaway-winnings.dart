import 'package:awoof_app/model/user.dart';
import 'package:awoof_app/model/giveaways.dart';

/// A class to hold my [GiveawayWinnings] model
class GiveawayWinnings {

  /// Setting constructor for [GiveawayWinnings] class
  GiveawayWinnings({
    required this.id,
    required this.user,
    required this.giveaway,
    required this.narration,
    required this.amount,
    required this.transactionDate,
  });

  /// A string variable to hold my giveaway winning id
  String id;

  /// A variable to hold my user model
  User user;

  /// A variable to hold my giveaway model
  AllGiveaways? giveaway;

  /// A string variable to hold my giveaway winning narration
  String narration;

  /// A string variable to hold my giveaway winning amount
  String amount;

  /// A DateTime variable to hold my giveaway winning transaction date
  DateTime transactionDate;

  /// Creating a method to map my JSON values to the model details accordingly
  factory GiveawayWinnings.fromJson(Map<String, dynamic> json) => GiveawayWinnings(
    id: json["_id"],
    user: json["user"] == null ? User.map(json["admin"]) : User.map(json["user"]),
    giveaway: json["giveaway_id"] != null ? AllGiveaways.fromJson(json["giveaway_id"]) : null,
    narration: json["narration"].toString(),
    amount: json["amount"].toString(),
    transactionDate: DateTime.parse(json["createdAt"]),
  );
}
