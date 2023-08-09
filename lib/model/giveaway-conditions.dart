/// A class to hold my [GiveawayCondition] model
class GiveawayCondition {

  /// Setting constructor for [GiveawayCondition] class
  GiveawayCondition({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  /// A string variable to hold my giveaway condition id
  String? id;

  /// A string variable to hold my giveaway condition name
  String? name;

  /// A DateTime variable to hold my giveaway condition created at
  DateTime? createdAt;

  /// Creating a method to map my JSON values to the model details accordingly
  factory GiveawayCondition.fromJson(Map<String, dynamic> json) => GiveawayCondition(
    id: json["_id"],
    name: json["name"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  /// Function to map user's details to a JSON object
  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "createdAt": createdAt!.toIso8601String(),
  };
}