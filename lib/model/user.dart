/// A class to hold my [User] model
class User {

  /// A String? variable to hold id
  String? _id;

  /// A String? variable to hold the user's login token
  String? _token;

  /// A String? variable to hold user's balance
  String? _balance;

  /// A bool?ean variable to hold the is verified
  bool? _isVerified;

  /// A bool?ean variable to hold the is admin
  bool? _isAdmin;

  /// A bool?ean variable to hold the is pin set
  bool? _isPinSet;

  /// A bool?ean variable to hold the is account set
  bool? _isAccountSet;

  /// A String? variable to hold first name
  String? _firstName;

  /// A String? variable to hold last name
  String? _lastName;

  /// A String? variable to hold phone number
  String? _phone;

  /// A String? variable to hold email address
  String? _email;

  /// A String? variable to hold gender
  String? _userName;

  /// A String? variable to hold user's location
  String? _location;

  /// A DateTime variable to hold user's sign up date
  String? _signupDate;

  /// A String? variable to hold user's reference
  String? _userRef;

  /// A String? variable to hold user's gender
  String? _gender;

  /// A String? variable to hold image url
  String? _image;

  /// A String? variable to hold user's stars
  String? _stars;

  /// A String? variable to hold user's following
  String? _following;

  /// A String? variable to hold user's followers
  String? _followers;

  /// An Integer variable to hold user's number of giveaways won
  String? _giveawaysWon;

  /// A double variable to hold user's total amount in cash of giveaways won
  String? _giveawaysAmountWon;

  /// A double variable to hold user's total amount of giveaways participated
  String? _giveawaysParticipated;

  /// A variable to hold user's total amount of giveaways done
  String? _giveawaysDone;

  /// Setting constructor for [User] class
  User(
      this._id,
      this._balance,
      this._token,
      this._isPinSet,
      this._isAccountSet,
      this._isVerified,
      this._isAdmin,
      this._firstName,
      this._lastName,
      this._phone,
      this._email,
      this._userName,
      this._signupDate,
      this._userRef,
      this._gender,
      this._location,
      this._image,
      this._stars,
      this._following,
      this._followers,
      this._giveawaysWon,
      this._giveawaysAmountWon,
      this._giveawaysParticipated,
      this._giveawaysDone
  );

  /// Creating getters for my [_token] value
  String? get token => _token;

  /// Creating getters for my [_id] value
  String? get id => _id;

  /// Creating getters for my [_isAdmin] value
  bool? get isAdmin => _isAdmin;

  /// Creating getters for my [_isPinSet] value
  bool? get isPinSet => _isPinSet;

  /// Creating getters for my [_isAccountSet] value
  bool? get isAccountSet => _isAccountSet;

  /// Creating getters for my [_isAccountSet] value
  bool? get isVerified => _isVerified;

  /// Creating getters for my [_userRef] value
  String? get userRef => _userRef;

  /// Creating getters for my [_firstName] value
  String? get firstName => _firstName;

  /// Creating getters for my [_lastName] value
  String? get lastName => _lastName;

  /// Creating getters for my [_phone] value
  String? get phone => _phone;

  /// Creating getters for my [_email] value
  String? get email => _email;

  /// Creating getters for my [_userName] value
  String? get userName => _userName;

  /// Creating getters for my [_balance] value
  String? get balance => _balance;

  /// Creating getters for my [_signupDate] value
  String? get signupDate => _signupDate;

  /// Creating getters for my [_gender] value
  String? get gender => _gender;

  /// Creating getters for my [_location] value
  String? get location => _location;

  /// Creating getters for my [_image] value
  String? get image => _image;

  /// Creating getters for my [_stars] value
  String? get stars => _stars;

  /// Creating getters for my [_following] value
  String? get following => _following;

  /// Creating getters for my [_followers] value
  String? get followers => _followers;

  /// Creating getters for my [_giveawaysWon] value
  String? get giveawaysWon => _giveawaysWon;

  /// Creating getters for my [_giveawaysAmountWon] value
  String? get giveawaysAmountWon => _giveawaysAmountWon;

  /// Creating getters for my [_giveawaysParticipated] value
  String? get giveawaysParticipated => _giveawaysParticipated;

  /// Creating getters for my [_giveawaysDone] value
  String? get giveawaysDone => _giveawaysDone;

  /// Function to map user's details from a JSON object
  /// The argument type 'Map<String?, dynamic>' can't be assigned to the parameter type 'Map<String, Object?>'
  User.map(dynamic obj) {
    this._token = obj["idToken"] == null ? null : obj["idToken"].toString();
    this._id = obj["_id"] == null ? null : obj["_id"].toString();
    this._isVerified = obj["isVerified"] == null ? null : obj["isVerified"];
    this._isAdmin = obj["isAdmin"] == null ? null : obj["isAdmin"];
    this._isPinSet = obj["isPinSet"] == null ? null : obj["isPinSet"];
    this._isAccountSet = obj["isAccountSet"] == null ? null : obj["isAccountSet"];
    this._userRef = obj["userRef"] == null ? null : obj["userRef"].toString();
    this._firstName = obj["firstName"] == null ? null : obj["firstName"].toString();
    this._lastName = obj["lastName"] == null ? null : obj["lastName"].toString();
    this._phone = obj["phoneNumber"] == null ? null : obj["phoneNumber"].toString();
    this._email = obj["email"] == null ? null : obj["email"].toString();
    this._userName = obj["username"] == null ? null : obj["username"].toString();
    this._balance = obj["balance"] == null ? null : obj["balance"].toString();
    this._gender = obj["gender"] == null ? null : obj["gender"].toString();
    this._location = obj["location"] == null ? null : obj["location"].toString();
    this._signupDate = obj["signupDate"] == null ? null : obj["signupDate"].toString();
    this._image = obj["image"] == null ? null : obj["image"]["location"].toString();
    this._stars = obj["stars"] == null ? null : obj["stars"].toString();
    this._following = obj["following"] == null ? null : obj["following"].toString();
    this._followers = obj["followers"] == null ? null : obj["followers"].toString();
    this._giveawaysWon = obj["giveawaysWon"] == null ? null : obj["giveawaysWon"].toString();
    this._giveawaysAmountWon = obj["giveawaysAmountWon"] == null ? null : obj["giveawaysAmountWon"].toString();
    this._giveawaysParticipated = obj["giveawaysParticipated"] == null ? null : obj["giveawaysParticipated"].toString();
    this._giveawaysDone = obj["giveawaysDone"] == null ? null : obj["giveawaysDone"].toString();
  }

  /// Function to map user's details to a JSON object
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id == null ? null : _id;
    map["balance"] = _balance == null ? null : _balance;
    map["token"] = _token;
    map["isPinSet"] = (_isPinSet == false ? 0 : 1);
    map["isAccountSet"] = (_isAccountSet == false ? 0 : 1);
    map["isVerified"] = (_isVerified == false ? 0 : 1);
    map["isAdmin"] = (_isAdmin == false ? 0 : 1);
    map["firstName"] = _firstName == null ? null : _firstName;
    map["lastName"] = _lastName == null ? null : _lastName;
    map["phoneNumber"] = _phone == null ? null : _phone;
    map["email"] = _email == null ? null : _email;
    map["userName"] = _userName == null ? null : _userName;
    map["signupDate"] = _signupDate == null ? null : _signupDate;
    map["userRef"] = _userRef == null ? null : _userRef;
    map["gender"] = _gender == null ? null : _gender;
    map["location"] = _location == null ? null : _location;
    map["image"] = _image == null ? null : _image;
    map["stars"] = _stars == null ? null : _stars;
    map["following"] = _following == null ? null : _following;
    map["followers"] = _followers == null ? null : _followers;
    map["giveawaysWon"] = _giveawaysWon == null ? null : _giveawaysWon;
    map["giveawaysAmountWon"] = _giveawaysAmountWon == null ? null : _giveawaysAmountWon;
    map["giveawaysParticipated"] = _giveawaysParticipated == null ? null : _giveawaysParticipated;
    map["giveawaysDone"] = _giveawaysDone == null ? null : _giveawaysDone;
    return map;
  }

}