import 'package:awoof_app/model/user.dart';

/// A class to hold my [TopGiversWithCount] model
class TopGiversWithCount {

  /// Setting constructor for [TopGiversWithCount] class
  TopGiversWithCount({
    required this.user,
    required this.totalCount,
  });

  /// A Model of [User] variable to hold my giveaway user
  User user;

  /// A double variable to hold my total amount
  int totalCount;

  /// Creating a method to map my JSON values to the model details accordingly
  factory TopGiversWithCount.fromJson(Map<String, dynamic> json) => TopGiversWithCount(
    user: json["user"] == null ? User.map(json["admin"]) : User.map(json["user"]),
    totalCount: int.parse(json["totalGiveaway"].toString()),
  );

}