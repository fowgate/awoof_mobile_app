/// A class to hold my [NigerianBanks] model
class NigerianBanks {
  /// Setting constructor for [NigerianBanks] class
  NigerianBanks({
    this.name,
    this.slug,
    this.code,
    this.longcode,
    this.gateway,
    this.payWithBank,
    this.active,
    this.isDeleted,
    this.country,
    this.currency,
    this.type,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  /// A String? variable to hold my bank name
  String? name;

  /// A String? variable to hold my bank slug
  String? slug;

  /// A String? variable to hold my bank code
  String? code;

  /// A String? variable to hold my bank long code
  String? longcode;

  /// A String? variable to hold my bank gateway
  String? gateway;

  /// A bool variable to hold if to pay with bank
  dynamic payWithBank;

  /// A bool variable to hold if to bank is active
  dynamic active;

  /// A bool variable to hold if bank is deleted
  dynamic isDeleted;

  /// A String? variable to hold the bank country
  String? country;

  /// A String? variable to hold the bank currency
  String? currency;

  /// A String? variable to hold the bank type
  String? type;

  /// An int variable to hold the bank id
  dynamic id;

  /// A String? variable to hold the bank created at
  String? createdAt;

  /// A String? variable to hold the bank updated at
  String? updatedAt;

  /// Creating a method to map my JSON values to the model details accordingly
  factory NigerianBanks.fromJson(Map<String?, dynamic> json) {
    return NigerianBanks(
      name: json["name"].toString(),
      slug: json["slug"].toString(),
      code: json["code"].toString(),
      longcode: json["longcode"].toString(),
      gateway: json["gateway"] == null ? null : json["gateway"].toString(),
      payWithBank: json["pay_with_bank"] ?? null,
      active: json["active"] ?? null,
      isDeleted: json["is_deleted"] ?? null,
      country: json["country"].toString(),
      currency: json["currency"].toString(),
      type: json["type"].toString(),
      id: json["id"] ?? null,
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
    );
  }

}
