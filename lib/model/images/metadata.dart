import 'dart:convert';

/// A class to hold my [Metadata] model
class Metadata {

  /// Setting constructor for [Metadata] class
  Metadata({
    required this.fieldName,
  });

  /// A string variable to hold my field name
  String fieldName;

  /// A factory method to map my raw JSON values to the model details accordingly
  factory Metadata.fromRawJson(String str) => Metadata.fromJson(json.decode(str));

  /// A method to send my raw JSON values of the class
  String toRawJson() => json.encode(toJson());

  /// Creating a method to map my JSON values to the model details accordingly
  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    fieldName: json["fieldName"].toString(),
  );

  /// Creating a method to map my values to JSON values with the model details accordingly
  Map<String, dynamic> toJson() => {
    "fieldName": fieldName,
  };
}