/// A class to hold my [SocialAccounts] model
class SocialAccounts {
  /// Setting constructor for [SocialAccounts] class
  SocialAccounts({
    this.id,
    this.user,
    this.twitter,
    this.facebook,
    this.instagram,
  });

  /// A String? variable to hold my social id
  String? id;

  /// A String? variable to hold my user id
  String? user;

  /// A String? variable to hold my twitter handle
  String? twitter;

  /// A String? variable to hold my facebook handle
  String? facebook;

  /// A String? variable to hold my instgram handle
  String? instagram;

  /// Creating a method to map my JSON values to the model details accordingly
  factory SocialAccounts.fromJson(Map<String?, dynamic> json) {
    return SocialAccounts(
        id: json["_id"].toString(),
        user: json["user"].toString(),
        twitter: json["twitter"] != null ? json["twitter"].toString() : '',
        facebook: json["facebook"] != null ? json["facebook"].toString() : '',
        instagram: json["instagram"] != null ? json["instagram"].toString() : '',
    );
  }

}
