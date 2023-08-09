import 'package:awoof_app/model/user.dart';
import 'package:awoof_app/model/giveaways.dart';

/// A class to hold my [MyNotifications] model
class MyNotifications {

  /// Setting constructor for [MyNotifications] class
  MyNotifications({
    this.id,
    this.message,
    this.type,
    this.seen,
    this.user,
    this.giveaway,
    this.createdAt,
  });

  /// A String? variable to hold my notification id
  String? id;

  /// A String? variable to hold my message value
  String? message;

  /// A String? variable to hold my notification type
  String? type;

  /// A boolean variable to hold my seen value true or false
  bool? seen;

  /// A String? variable to hold the id of my user
  User? user;

  /// A String? variable to hold the giveaway of my user
  AllGiveaways? giveaway;

  /// A DateTime variable to hold my notification transaction date
  DateTime? createdAt;

  /// Creating a method to map my JSON values to the model details accordingly
  factory MyNotifications.fromJson(Map<String , dynamic> value) {
    return MyNotifications(
    id: value["_id"],
    message: value["message"].toString (),
    type: value["type"],
    seen: value["seen"],
    user: User.map(value["user"]),
    giveaway: (value["giveaway"] == null) ? null : AllGiveaways.fromJson(value["giveaway"]),
    createdAt: DateTime.parse(value["createdAt"]),
  );
  }
}
