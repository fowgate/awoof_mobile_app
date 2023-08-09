import 'package:http/http.dart' as http;

/// A class to hold my [CreateGiveaway] model
class CreateGiveaway {

  /// Setting constructor for [CreateGiveaway] class
  CreateGiveaway();

  /// A string variable to hold my giveaway type
  String? type;

  /// A boolean variable to hold my giveaway is anonymous
  bool? isAnonymous;

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

  /// A boolean variable to hold my giveaway like tweet on twitter
  bool? likeTweet;

  /// A boolean variable to hold my giveaway follow account on twitter
  bool? followTwitter;

  /// A boolean variable to hold my giveaway like post on instagram
  bool? likeInstagram;

  /// A boolean variable to hold my giveaway follow account on instagram
  bool? followInstagram;

  /// A boolean variable to hold my giveaway like facebook account
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
  String? likefacebookLink;

  /// A string variable to hold my giveaway platform of engagement
  String? platformOfEngagement;

  /// A boolean variable to hold my giveaway like post on facebook
  bool? likePostOnFacebook;

  /// A string variable to hold my giveaway post link
  String? postLinkOnFacebook;

  /// A string variable to hold my giveaway follow link
  String? followPageOnFacebook;

  /// A string variable to hold my giveaway reference
  String? giveawayRef;

  /// A string variable to hold my giveaway payment reference
  String? paymentReference;

  /// A string variable to hold my giveaway payment status
  String? paymentStatus;

  /// A string variable to hold my giveaway gateway response
  String? gatewayResponse;

  /// A List of dynamic to hold my ad image
  List<http.MultipartFile>? image;

  /// A string variable to hold my expiry date
  String? expiry;

  /// A DateTime variable to hold my expiry date
  DateTime? endAt;

  /// A string variable to hold my payment type
  String? paymentType;

}