/// A class to hold my [Operator] model
class Operator {

  /// Setting constructor for [Operator] class
  Operator({
    this.operatorId,
    this.operatorName,
    this.bundle,
    this.data
  });

  /// Integer variable to hold my operator id
  String? operatorId;

  /// A string variable to hold my operator name
  String? operatorName;

  /// A boolean variable to hold my operator bundle
  bool? bundle;

  /// A boolean variable to hold my operator data
  bool? data;

  /// Creating a method to map my JSON values to the model details accordingly
  factory Operator.fromJson(Map<String, dynamic> json) => Operator(
    operatorId: json["operatorId"].toString(),
    operatorName: json["operatorName"] == null ? json["name"].toString() : json["operatorName"].toString(),
    bundle: json["bundle"],
    data: json["data"],
  );
}