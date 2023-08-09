import 'package:awoof_app/model/user.dart';
import 'package:awoof_app/model/giveaways.dart';

/// A class to hold my [Participants] model
class Participants {

  /// Setting constructor for [Participants] class
  Participants({
    this.id,
    this.giveawayId,
    this.user,
    this.count,
    this.win,
    this.createdAt
  });


  /// A string variable to hold my participant id
  String? id;

  /// An integer variable to hold my participant count
  int? count;

  /// A string variable to hold my participant giveaway id
  AllGiveaways? giveawayId;

  /// A Model of [User] variable to hold my giveaway user
  User? user;

  /// A Boolean variable to hold my participant win [True] or [False]
  bool? win;

  /// A DateTime variable to hold my participant created at
  DateTime? createdAt;

  /// Creating a method to map my JSON values to the model details accordingly
  factory Participants.fromJson(Map<String, dynamic> json) {
    if(json["giveaway_id"].runtimeType == String){
      return Participants(
        id: json["_id"] == null ? null : json["_id"].toString(),
        giveawayId: null,
        user: json["user"] == null ? User.map(json["admin"]) : User.map(json["user"]),
        count: json["count"] == null ? null : json["count"],
        win: json["win"] == null ? null : json["win"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      );
    }
    else {
      return Participants(
        id: json["_id"] == null ? null : json["_id"].toString(),
        giveawayId: json["giveaway_id"] == null ? null : AllGiveaways.fromJson(json["giveaway_id"]),
        user: json["user"] == null ? User.map(json["admin"]) : User.map(json["user"]),
        count: json["count"] == null ? null : json["count"],
        win: json["win"] == null ? null : json["win"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      );
    }
  }

}
