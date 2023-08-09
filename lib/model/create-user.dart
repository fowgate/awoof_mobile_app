import 'package:http/http.dart' as http;

/// A class to hold my [CreateUser] model
class CreateUser {

  /// A string variable to hold my first name
  String? firstName;

  /// A string variable to hold my last name
  String? lastName;

  /// A string variable to hold my user name
  String? userName;

  /// A string variable to hold my email
  String? email;

  /// A string variable to hold my password
  String? password;

  /// A string variable to hold my referral code
  String? referralCode;

  /// A string variable to hold my phone number
  String? phone;

  /// A string variable to hold my date of birth
  String? dateOfBirth;

  /// A string variable to hold my gender
  String? gender;

  /// A string variable to hold my location
  String? location;

  /// A List of dynamic to hold my profile image
  List<http.MultipartFile>? image;

  /// Constructor for [CreateUser] class
  CreateUser();

}