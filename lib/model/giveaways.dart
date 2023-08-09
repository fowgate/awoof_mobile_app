import 'package:awoof_app/model/user.dart';

/// A class to hold my [AllGiveaways] model
class AllGiveaways {

  /// Setting constructor for [AllGiveaways] class
  AllGiveaways({
     this.isAnonymous,
     this.likePostOnFacebook,
     this.id,
     this.user,
     this.type,
     this.amount,
     this.amountPerWinner,
     this.numberOfWinners,
     this.frequency,
     this.message,
     this.platformOfEngagement,
     this.postLinkOnFacebook,
     this.followPageOnFacebook,
     this.giveawayRef,
     this.paymentReference,
     this.paymentStatus,
     this.gatewayResponse,
     this.createdAt,
     this.likeTweet,
     this.followTwitter,
     this.likeInstagram,
     this.followInstagram,
     this.likeFacebook,
     this.paymentType,
     this.likeTweetLink,
     this.followTwitterLink,
     this.likeInstagramLink,
     this.followInstagramLink,
     this.likeFacebookLink,
    this.star,
     this.expiry,
     this.hidden,
     this.completed,
     this.image,
     this.endAt
  });

  /// A bool?ean variable to hold my giveaway is anonymous
  bool? isAnonymous;

  /// A string variable to hold my giveaway id
  String? id;

  /// A Model of [User] variable to hold my giveaway user
  dynamic user;

  /// A string variable to hold my giveaway type
  String? type;

  /// A string variable to hold my giveaway amount
  String? amount;

  /// A string variable to hold my giveaway amount per winner
  String? amountPerWinner;

  /// A string variable to hold my giveaway number of winners
  int? numberOfWinners;

  /// A string variable to hold my giveaway frequency
  String? frequency;

  /// A string variable to hold my giveaway message
  String? message;

  /// A bool?ean variable to hold my giveaway like tweet on twitter
  bool? likeTweet;

  /// A bool?ean variable to hold my giveaway follow account on twitter
  bool? followTwitter;

  /// A bool?ean variable to hold my giveaway like post on instagram
  bool? likeInstagram;

  /// A bool?ean variable to hold my giveaway follow account on instagram
  bool? followInstagram;

  /// A bool?ean variable to hold my giveaway like facebook account
  bool? likeFacebook;

  /// A string variable to hold my link to tweet on twitter
  String? likeTweetLink;

  /// A string variable to hold my link to account on twitter
  String? followTwitterLink;

  /// A string variable to hold my link to post on instagram
  String? likeInstagramLink;

  /// A string variable to hold my link to instagram account
  String? followInstagramLink;

  /// A string variable to hold my link to facebook account
  String? likeFacebookLink;

  /// A string variable to hold my giveaway platform of engagement
  String? platformOfEngagement;

  /// A bool?ean variable to hold my giveaway like post on facebook
  bool? likePostOnFacebook;

  /// A string variable to hold my giveaway post link
  String? postLinkOnFacebook;

  /// A string variable to hold my giveaway follow link
  bool? followPageOnFacebook;

  /// A string variable to hold my giveaway reference
  String? giveawayRef;

  /// A string variable to hold my payment type
  String? paymentType;

  /// A string variable to hold my giveaway payment reference
  String? paymentReference;

  /// A string variable to hold my giveaway payment status
  String? paymentStatus;

  /// A string variable to hold my giveaway gateway response
  String? gatewayResponse;

  /// A string variable to hold my giveaway gateway response
  dynamic imageObject;

  /// A string variable to hold my image url
  String? image;

  /// A string variable to hold my expiry date
  String? expiry;

  /// A bool?ean variable to hold my giveaway if to be hidden or not
  bool? hidden;

  /// A string variable to hold number of stars needed
  String? star;

  /// A bool?ean variable to hold my giveaway completed true or false
  bool? completed;

  /// A DateTime variable to hold my giveaway end at
  DateTime? endAt;

  /// A DateTime variable to hold my giveaway created at
  DateTime? createdAt;

  /// Creating a method to map my JSON values to the model details accordingly
  factory AllGiveaways.fromJson(Map<String?, dynamic> json) {
    if(json["user"].runtimeType == String){
      return AllGiveaways(
        isAnonymous: json["isAnonymous"],
        likePostOnFacebook: json["likePostOnFacebook"] ?? null,
        id: json["_id"],
        user: json["user"] == null ? null : json["user"],
        type: json["type"],
        amount: json["amount"].toString(),
        amountPerWinner: json["amountPerWinner"].toString(),
        numberOfWinners: double.parse(json["numberOfWinners"].toString()).round(),
        frequency: json["frequency"] ?? null,
        message: json["message"] ?? null,
        platformOfEngagement: json["platformOfEngagement"] ?? null,
        postLinkOnFacebook: json["postLinkOnFacebook"] ?? null,
        followPageOnFacebook: json["followPageOnFacebook"] ?? null,
        giveawayRef: json["giveaway_ref"] ?? null,
        paymentReference: json["payment_reference"] ?? null,
        paymentStatus: json["payment_status"] ?? null,
        gatewayResponse: json["gateway_response"] ?? null,
        createdAt: DateTime.parse(json["createdAt"]),
        likeTweet: json["likeTweet"] ?? null,
        followTwitter: json["followTwitter"] ?? null,
        likeInstagram: json["likeInstagram"] ?? null,
        followInstagram: json["followInstagram"] ?? null,
        likeFacebook: json["likeFacebook"] ?? null,
        likeFacebookLink: json["likeFacebookLink"] ?? null,
        paymentType: json["payment_type"] ?? null,
        likeTweetLink: json["likeTweetLink"] ?? null,
        followTwitterLink: json["followTwitterLink"] ?? null,
        likeInstagramLink: json["likeInstagramLink"] ?? null,
        followInstagramLink: json["followInstagramLink"] ?? null,
        completed: json["completed"] ?? null,
        star: json["minimumstars"].toString() ?? null,
        expiry: json["expiry"] ?? null,
        hidden: json["hidden"] ?? null,
        image: json["image"] == null ? null : json["image"]["location"],
        endAt: json["endAt"] == null ? null : DateTime.parse(json["endAt"]),
      );
    }
    else if(json["admin"].runtimeType == String){
      return AllGiveaways(
        isAnonymous: json["isAnonymous"],
        likePostOnFacebook: json["likePostOnFacebook"] ?? null,
        id: json["_id"],
        user: json["admin"] == null ? null : json["admin"],
        type: json["type"],
        amount: json["amount"].toString(),
        amountPerWinner: json["amountPerWinner"].toString(),
        numberOfWinners: double.parse(json["numberOfWinners"].toString()).round(),
        frequency: json["frequency"] ?? null,
        message: json["message"] ?? null,
        platformOfEngagement: json["platformOfEngagement"] ?? null,
        postLinkOnFacebook: json["postLinkOnFacebook"] ?? null,
        followPageOnFacebook: json["followPageOnFacebook"] ?? null,
        giveawayRef: json["giveaway_ref"] ?? null,
        paymentReference: json["payment_reference"] ?? null,
        paymentStatus: json["payment_status"] ?? null,
        gatewayResponse: json["gateway_response"] ?? null,
        createdAt: DateTime.parse(json["createdAt"]),
        likeTweet: json["likeTweet"] ?? null,
        followTwitter: json["followTwitter"] ?? null,
        likeInstagram: json["likeInstagram"] ?? null,
        followInstagram: json["followInstagram"] ?? null,
        likeFacebook: json["likeFacebook"] ?? null,
        paymentType: json["payment_type"] ?? null,
        likeTweetLink: json["likeTweetLink"] ?? null,
        followTwitterLink: json["followTwitterLink"] ?? null,
        likeInstagramLink: json["likeInstagramLink"] ?? null,
        followInstagramLink: json["followInstagramLink"] ?? null,
        likeFacebookLink: json["likeFacebookLink"] ?? null,
        completed: json["completed"] ?? null,
        star: json["minimumstars"].toString() ?? null,
        expiry: json["expiry"] ?? null,
        hidden: json["hidden"] ?? null,
        image: json["image"] == null ? null : json["image"]["location"],
        endAt: json["endAt"] == null ? null : DateTime.parse(json["endAt"]),
      );
    }
    else if(json["user"] == null && json["admin"] == null){
      return AllGiveaways();
    }
    else {
      return AllGiveaways(
        isAnonymous: json["isAnonymous"],
        likePostOnFacebook: json["likePostOnFacebook"] ?? null,
        id: json["_id"],
        user: json["user"] == null ? User.map(json["admin"]) : User.map(json["user"]),
        type: json["type"],
        amount: json["amount"].toString(),
        amountPerWinner: json["amountPerWinner"].toString(),
        numberOfWinners: double.parse(json["numberOfWinners"].toString()).round(),
        frequency: json["frequency"] ?? null,
        message: json["message"] ?? null,
        platformOfEngagement: json["platformOfEngagement"] ?? null,
        postLinkOnFacebook: json["postLinkOnFacebook"] ?? null,
        followPageOnFacebook: json["followPageOnFacebook"] ?? null,
        giveawayRef: json["giveaway_ref"] ?? null,
        paymentReference: json["payment_reference"] ?? null,
        paymentStatus: json["payment_status"] ?? null,
        gatewayResponse: json["gateway_response"] ?? null,
        createdAt: DateTime.parse(json["createdAt"]),
        likeTweet: json["likeTweet"] ?? null,
        followTwitter: json["followTwitter"] ?? null,
        likeInstagram: json["likeInstagram"] ?? null,
        followInstagram: json["followInstagram"] ?? null,
        likeFacebook: json["likeFacebook"] ?? null,
        paymentType: json["payment_type"] ?? null,
        likeTweetLink: json["likeTweetLink"] ?? null,
        followTwitterLink: json["followTwitterLink"] ?? null,
        likeInstagramLink: json["likeInstagramLink"] ?? null,
        followInstagramLink: json["followInstagramLink"] ?? null,
        likeFacebookLink: json["likeFacebookLink"] ?? null,
        completed: json["completed"] ?? null,
        star: json["minimumstars"].toString() ?? null,
        expiry: json["expiry"] ?? null,
        hidden: json["hidden"] ?? null,
        image: json["image"] == null ? null : json["image"]["location"],
        endAt: json["endAt"] == null ? null : DateTime.parse(json["endAt"]),
      );
    }
  }

}