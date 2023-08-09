class GiveawayType {

  /// Setting constructor for [GiveawayType] class
  GiveawayType({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  /// A string variable to hold my giveaway condition id
  String id;

  /// A string variable to hold my giveaway condition name
  String name;

  /// A DateTime variable to hold my giveaway condition created at
  DateTime createdAt;

  /// Creating a method to map my JSON values to the model details accordingly
  factory GiveawayType.fromJson(Map<String, dynamic> json) => GiveawayType(
    id: json["_id"],
    name: json["name"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  /// Function to map user's details to a JSON object
  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "createdAt": createdAt.toIso8601String(),
  };
}