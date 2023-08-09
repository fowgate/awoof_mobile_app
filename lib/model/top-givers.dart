import 'package:awoof_app/model/user.dart';

/// A class to hold my [TopGiversWithAmount] model
class TopGiversWithAmount {

  /// Setting constructor for [TopGiversWithAmount] class
  TopGiversWithAmount({
    this.user,
    this.totalAmount,
    this.totalCount,
  });

  /// A Model of [User] variable to hold my giveaway user
  User? user;

  /// A double variable to hold my total amount
  double? totalAmount;

  /// A double variable to hold my total count
  int? totalCount;

  /// Creating a method to map my JSON values to the model details accordingly
  factory TopGiversWithAmount.fromJson(Map<String, dynamic> json) => TopGiversWithAmount(
    user: json["user"] == null ? User.map(json["admin"]) : User.map(json["user"]),
    totalAmount: double.parse(json["totalAmount"].toString()),
    totalCount: json["totalCount"] != null ? int.parse(json["totalCount"].toString()) : null,
  );

}