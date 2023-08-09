import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/model/add-bank.dart';
import 'package:awoof_app/model/airtime-topup.dart';
import 'package:awoof_app/model/all-givers.dart';
import 'package:awoof_app/model/banks.dart';
import 'package:awoof_app/model/create-giveaway.dart';
import 'package:awoof_app/model/create-user.dart';
import 'package:awoof_app/model/free-withdrawals.dart';
import 'package:awoof_app/model/giveaway-conditions.dart';
import 'package:awoof_app/model/giveaway-type.dart';
import 'package:awoof_app/model/giveaways.dart';
import 'package:awoof_app/model/my-airtime-topup-history.dart';
import 'package:awoof_app/model/nigerian-banks.dart';
import 'package:awoof_app/model/notifications.dart';
import 'package:awoof_app/model/operators.dart';
import 'package:awoof_app/model/participants.dart';
import 'package:awoof_app/model/socials.dart';
import 'package:awoof_app/model/top-givers.dart';
import 'package:awoof_app/model/transfer-history.dart';
import 'package:awoof_app/model/user.dart';
import 'package:awoof_app/model/wallet-topup.dart';
import 'package:awoof_app/model/wallet-topup-history.dart';
import 'package:awoof_app/model/surprise-history.dart';
import 'package:awoof_app/networking/network-util.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:awoof_app/model/giveaway-winnings.dart';
import 'package:awoof_app/utils/rflutter_alert-2.0.4/lib/rflutter_alert.dart';
import 'error-handler.dart';
import 'endpoints.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

/// A [RestDataSource] class to do all the send request to the back end
/// and handle the result
class RestDataSource {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// Instantiating a class of the [ErrorHandler]
  var errorHandler = ErrorHandler();

  /// Instantiating a class of the [NetworkHelper]
  NetworkHelper _netUtil = NetworkHelper();

  /// A function that sends fcm token for notifications
  Future<dynamic> sendFCM(String token) async {
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.post(FCM_URL, headers: header, body: {
      "token": token,
      "device_type": Platform.operatingSystem
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return 'Success';
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that checks if email exists
  Future<dynamic> emailCheck(String email) async {
    Map<String, String>? header = {
      "content-Type": "application/json"
    };
    return _netUtil.post(EMAIL_CHECK_URL, headers: header, body: {
      "email": email
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return 'Valid';
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

    /// Send giveaway payment mail
  Future<dynamic> giveawayPay(String id) async {
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    String? token;
    header = {"content-Type": "application/json"};
    await user.then((value) {
      print(value!.token);
      if(value!.token == null) throw ("You're unauthorized, log out and login back to continue");
      token = value.token!;
      header = {"x-auth-token": "${value.token}", "content-Type": "application/json"};
    });
    return _netUtil.get("$SEND_GIVEAWAY_PAY_MAIL/$id" , headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return {
        'user': User.map(res["data"]),
        'token': token
      };
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }


  /// A function that checks if username exists
  Future<dynamic> usernameCheck(String username) async {
    Map<String, String>? header = {
      "content-Type": "application/json"
    };
    return _netUtil.post(USERNAME_CHECK_URL, headers: header, body: {
      "username": username
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return 'Valid';
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that checks if phone number exists
  Future<dynamic> phoneCheck(String phone) async {
    Map<String, String>? header = {
      "content-Type": "application/json"
    };
    return _netUtil.post(PHONE_CHECK_URL, headers: header, body: {
      "phoneNumber": phone
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return 'Valid';
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that verifies login details from the database POST.
  /// with [email] and [password]
  Future<User> login(String email, String password) {
    Map<String, String>? header = {"content-Type": "application/json"};
    return _netUtil.postLogin(LOGIN_URL, headers: header, body: {
      "email": email,
      "password": password
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return User.map(res["data"]);
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that creates a new user POST with [CreateUser] model
  Future<User> signUp(CreateUser createUser, String token) {
    Map<String, String> body;
    body = {
      "firstName": createUser.firstName!,
      "lastName": createUser.lastName!,
      "username": createUser.userName!,
      "email": createUser.email!,
      "phoneNumber": createUser.phone!,
      "password": createUser.password!,
      "location": createUser.location!,
      "dateOfBirth": createUser.dateOfBirth!,
      "referralCode": createUser.referralCode!,
      "gender": createUser.gender!,
      "token": token,
    };
    return _netUtil.postForm(Uri.parse(SIGN_UP_URL), createUser.image,
        body: body).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return User.map(res["data"]);
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that sets user's transaction pin PUT.
  /// with [Pin]
  Future<dynamic> setPin(String id, String pin) async{
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    final SET_PIN = SET_PIN_URL + "/$id";
    return _netUtil.put(SET_PIN, headers: header, body: {
      "oldPin": pin,
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return res["message"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that verifies user transaction pin with [pin]
  Future<dynamic> verifyPin(String pin) async{
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.post(VERIFY_PIN_URL, headers: header, body: {
      "pin": pin
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return res["message"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that does the 2 factor authentication by verifying the phone
  /// number with [phoneNumber] and [token]
  Future<dynamic> twoFaVerify(String phoneNumber, String token) async{
    Map<String, String>? header = {"content-Type": "application/json"};
    return _netUtil.post(TWO_FA_URL, headers: header, body: {
      "phoneNumber": phoneNumber,
      "token": token
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return res["message"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that re-sends 2fa code to user's phone number
  /// with [phoneNumber]
  Future<dynamic> twoFaResend(String phoneNumber) async{
    Map<String, String>? header = {"content-Type": "application/json"};
    return _netUtil.post(TWO_FA_RESEND, headers: header, body: {
      "phoneNumber": phoneNumber
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return res["message"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that re-sends 2fa code to user's email with [phoneNumber]
  /// and [email]
  Future<dynamic> twoFaResendEmail(String phone, String email) async{
    Map<String, String>? header = {"content-Type": "application/json"};
    return _netUtil.post(TWO_FA_RESEND_EMAIL, headers: header, body: {
      "phoneNumber": phone,
      "email": email
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return res["message"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that forget user's password POST with [email]
  Future<dynamic> forgetPassword(String email, String word) async{
    Map<String, String>? header = {"content-Type": "application/json"};
    return _netUtil.post(FORGET_PASSWORD_URL, headers: header, body: {
      "email": email,
      "word": word
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return res["message"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that reset user's password POST with [email], [password]
  /// and [token]
  Future<dynamic> resetPassword(String email, String password, String token) async{
    Map<String, String>? header = {"content-Type": "application/json"};
    return _netUtil.post(RESET_PASSWORD_URL, headers: header, body: {
      "email": email,
      "password": password,
      "token": token
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return res["message"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that reset user's pin POST with [pin] and [token]
  Future<dynamic> resetPin(String pin, String token) async{
    String? email;
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value!.token == null) throw ("You're unauthorized, log out and login back to continue");
      email = value.email!;
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.post(RESET_PIN_URL, headers: header, body: {
      "email": email,
      "token": token,
      "pin": pin
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return res["message"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that changes user's transaction pin PUT.
  /// with [oldPin] and [newPin]
  Future<dynamic> changePin(String oldPin, String newPin) async{
    Map<String, String>? header;
    String? id;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value!.token == null) throw ("You're unauthorized, log out and login back to continue");
      id = value.id!;
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    final CHANGE_PIN =  "$CHANGE_PIN_URL $id";
    return _netUtil.put(CHANGE_PIN, headers: header, body: {
      "oldPin": oldPin,
      "newPin": newPin,
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return res["message"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that changes user's transaction pin PUT.
  /// with [oldPin] and [newPin]
  Future<dynamic> changePassword(String currentPassword, String newPassword) async{
    Map<String, String>? header;
    String? id;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value!.token == null) throw ("You're unauthorized, log out and login back to continue");
      id = value.id!;
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    final CHANGE_PASSWORD = "$CHANGE_PASSWORD_URL $id"; //CHANGE_PASSWORD_URL + `/${id}`;
    return _netUtil.put(CHANGE_PASSWORD, headers: header, body: {
      "password": currentPassword,
      "newPassword": newPassword,
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return res["message"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that creates a new user POST with [CreateUser] model
  Future<dynamic> changeProfilePicture(List<http.MultipartFile> image/*, String picture*/) async {
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.postForm(Uri.parse(CHANGE_PICTURE_URL), image, header: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return res["message"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that update user's profile pin PUT.
  /// with [name], [email] and [phone]
  Future<dynamic> updateProfile(String lastName, String firstName, String userName, String phone) async{
    Map<String, String>? header;
    String? id;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value!.token == null) throw ("You're unauthorized, log out and login back to continue");
      id = value.id!;
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    final UPDATE_PROFILE = "$UPDATE_PROFILE_URL $id";
    return _netUtil.put(UPDATE_PROFILE, headers: header, body: {
      "firstName": firstName,
      "lastName": lastName,
      "username": userName,
      "phoneNumber": phone,
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return res["message"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that deduct user's balance POST.
  /// with [id] and [amount]
  Future<dynamic> deductBalance(String id, String amount) async{
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value!.token == null) throw ("You're unauthorized, log out and login back to continue");
      id = value.id!;
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    final DEDUCT_BALANCE = DEDUCT_USER_BALANCE + "/$id";
    return _netUtil.post(DEDUCT_BALANCE, headers: header, body: {
      "amount": amount,
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return 'Successfully deducted payment from your wallet';
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches the particular current logged in user
  /// into a model of [User] GET.
  Future<dynamic> getCurrentUser() async {
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    String? token;
    await user.then((value) {
      if(value!.token == null) throw ("You're unauthorized, log out and login back to continue");
      token = value.token!;
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.get(FETCH_CURRENT_USER, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return {
        'user': User.map(res["data"]),
        'token': token
      };
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that retrieves a particular user from the database
  /// into a model of [User] GET.
  Future<User> retrieveUser(String id) async {
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value!.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    final RETRIEVE_USER = SIGN_UP_URL + "/$id";
    return _netUtil.get(RETRIEVE_USER, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return User.map(res["data"]);
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches all the notifications of the particular current
  /// logged in user into a model of [MyNotifications] GET.
  Future<List<MyNotifications>> getNotifications() async {
    List<MyNotifications> notifications;
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.get(USER_NOTIFICATIONS, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      var rest = res["data"] as List;
      notifications = rest.map<MyNotifications>((json) => MyNotifications.fromJson(json)).toList();
      return notifications;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches all contacts on awoof GET
  Future<List<String>> getContacts() async {
    List<String> result = [];
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.get(FETCH_ALL_CONTACTS, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      var rest = res["data"] as List;
      result = rest.map<String>((json) => json['phoneNumber']).toList();
      return result;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches a particular user's social accounts from the database
  /// into a model of [SocialAccounts] GET.
  Future<SocialAccounts> fetchMySocials() async {
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value!.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.get(FETCH_MY_SOCIALS, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      if(res["data"].length == 0) throw ('The User with the given ID was not found.');
      return SocialAccounts.fromJson(res["data"].first);
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that add my social account details POST.
  /// with [SocialAccounts] model
  Future<dynamic> addMySocials(String twitter, String facebook, String ig) async {
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value!.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.post(ADD_MY_SOCIALS, headers: header, body: {
      "twitter": twitter,
      "facebook": facebook,
      "instagram": ig,
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return res["status"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that updates social account PUT.
  Future<dynamic> updateMySocials(String twitter, String facebook, String ig) async {
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.put(UPDATE_MY_SOCIALS, headers: header, body: {
      "twitter": twitter ?? '',
      "facebook": facebook ?? '',
      "instagram": ig ?? '',
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return res["message"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches all Banks in Nigeria from paystack database
  /// into a model of [NigerianBanks] GET.
  Future<List<NigerianBanks>> fetchAllBanks() async {
    List<NigerianBanks> banks;
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value!.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.get(FETCH_ALL_NIGERIAN_BANKS, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      var rest = jsonDecode(res["data"])["data"] as List;
      banks = rest.map<NigerianBanks>((json) => NigerianBanks.fromJson(json)).toList();
      return banks;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches all Banks of a registered user from the database
  /// into a model of [Banks] GET.
  Future<List<Banks>> fetchUserBanks() async {
    List<Banks> banks;
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.get(FETCH_USER_BANK_ACCOUNTS, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      var rest = res["data"] as List;
      banks = rest.map<Banks>((json) => Banks.fromJson(json)).toList();
      return banks;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches a particular Bank of a registered user from the database
  /// with id into a model of [Bank] GET.
  Future<Banks> fetchBank(String id) async {
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    final FETCH_BANK = FETCH_USER_BANK + "/$id";
    return _netUtil.get(FETCH_BANK, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return Banks.fromJson(res["data"]);
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that add a new bank account to a user POST.
  /// with [AddMyBank] model
  Future<dynamic> addBankAccount(AddMyBank addBank) async {
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.post(ADD_USER_BANK_ACCOUNTS, headers: header, body: {
      "bankName": addBank.bankName,
      "bankCode": addBank.bankCode,
      "accountName": addBank.accountName,
      "accountNumber": addBank.accountNumber,
      "newPin": addBank.newPin,
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return res["message"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that verify bank account from server POST.
  Future<dynamic> verifyBankAccount(String bankCode, String accountNumber) async {
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.post(VERIFY_USER_BANK_ACCOUNTS, headers: header, body: {
      "bankCode": bankCode,
      "accountNumber": accountNumber,
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      var rest = res["data"];
      return 'tempvalid';
      // if(rest["status"] && rest["data"]["account_name"] != "Not found")
      //   return rest["data"]["account_name"];
      // throw "No user found";
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that delete a particular user bank from the database
  /// with DELETE.
  Future<dynamic> deleteBankAccount(String id) async {
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    final DELETE_BANK = DELETE_USER_BANK_ACCOUNT + "/$id";
    return _netUtil.delete(DELETE_BANK, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return res["message"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that initializes payment POST.
  /// with [amount]
  Future<dynamic> initializePayment(double amount) async{
    Map<dynamic, dynamic> data = Map();
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.post(INITIALIZE_PAYMENT, headers: header, body: {
      "amount": amount.toString()
    }).then((dynamic res) {
      if(!res["status"]) throw res["message"];
      data['authorization_url'] = res['data']['authorization_url'];
      data['access_code'] = res['data']['access_code'];
      data['reference'] = res['data']['reference'];
      return data;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that verifies payment POST with [reference]
  /// It returns a model of [Data]
  Future<dynamic> verifyPayment(String reference) async{
    Map<dynamic, dynamic> data = Map();
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.post(VERIFY_PAYMENT, headers: header, body: {
      "reference": reference
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      var rest = jsonDecode(res["data"]["body"])["data"];
      data['reference'] = rest['reference'];
      data['status'] = rest['status'];
      data['gateway_response'] = rest['gateway_response'];
      return data;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches all your airtime top up history from the database
  /// into a model of [AirtimeTopUpHistory] GET.
  Future<List<AirtimeTopUpHistory>> fetchAirtimeTopUpHistory() async {
    List<AirtimeTopUpHistory> history;
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.get(FETCH_MY_AIRTIME_TOPUP_HISTORY, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      var rest = res["data"] as List;
      history = rest.map<AirtimeTopUpHistory>((json) => AirtimeTopUpHistory.fromJson(json)).toList();
      return history;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetch your access token to telco operaators from the database
  /// GET.
  Future<dynamic> fetchAccessToken() async {
    Map result = {};
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.get(AIRTIME_ACCESS_TOKEN, headers: header).then((dynamic res) {
      if(res["error"]) throw (res["message"]);
      result["access_token"] = res["data"]["access_token"];
      result["token_type"] = res["data"]["token_type"];
      return result;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches all telco operators from the database
  /// into a model of [Operator] GET.
  Future<List<Operator>> fetchTelcoOperators(String accessToken) async {
    List<Operator> operators;
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.post(FETCH_TELCO_OPERATORS, headers: header, body: {
      "countryCode": 'NG',
      "accessToken": accessToken,
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      var rest = jsonDecode(res["data"]) as List;
      operators = rest.map<Operator>((json) => Operator.fromJson(json)).toList();
      return operators;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that does airitme top up to a recipient phone number POST.
  /// with [AirtimeTopup] model
  Future<dynamic> airtimeTopUp(AirtimeTopup topup) async {
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.post(AIRTIME_TOPUP, headers: header, body: {
      "accessToken": topup.accessToken,
      "operatorId": topup.operatorId,
      "amount": topup.amount,
      "recipientPhoneCountryCode": topup.recipientPhoneCountryCode,
      "recipientPhoneNumber": topup.recipientPhoneNumber
    }).then((dynamic res) {
      if(res["error"]) throw (res["message"]);
      return res["message"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that auto detect recipient phone number [phone] POST.
  /// with [accessToken] and returns a model of [Operator]
  Future<Operator> detectNumber(String phone, String accessToken) async {
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.post(AUTODETECT_NUMBER, headers: header, body: {
      "recipientPhoneNumber": phone,
      "accessToken": accessToken,
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return Operator.fromJson(res["data"]);
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that gets all the total giveaway details GET
  Future<Map<String, String>> fetchGiveawayDetails() async {
    Map<String, String> giveawayDetails = {};
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.get(GIVEAWAY_DETAILS_URL, headers: header).then((dynamic res) {
      if(res["error"]) throw res["status"];
      giveawayDetails['winners'] = res["data"]['winners'].toString();
      giveawayDetails['giveaways'] = res["data"]['giveaways'].toString();
      giveawayDetails['totalAmount'] = res["data"]['totalAmount'].toString();
      return giveawayDetails;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that creates a new giveaway POST with [CreateGiveaway] model
  Future<dynamic> postGiveaway(CreateGiveaway giveaway) async {
    // Map<String, String> body;
    // body = {
    //   "amount": giveaway.amount!,
    //   "type": giveaway.type!,
    //   "amountPerWinner": giveaway.amountPerWinner!,
    //   "isAnonymous": giveaway.isAnonymous.toString(),
    //   "frequency": giveaway.frequency!,
    //   "message": giveaway.message!,
    //   "payment_type": giveaway.paymentType!,
    //   "likeTweet": giveaway.likeTweet.toString(),
    //   "followTwitter": giveaway.followTwitter.toString(),
    //   "likeTweetLink": giveaway.likeTweetLink.toString(),
    //   "followTwitterLink": giveaway.followTwitterLink.toString(),
    //   "likeInstagram": giveaway.likeInstagram.toString(),
    //   "followInstagram": giveaway.followInstagram.toString(),
    //   "likeInstagramLink": giveaway.likeInstagramLink.toString(),
    //   "followInstagramLink": giveaway.followInstagramLink.toString(),
    //   "likeFacebook": giveaway.likeFacebook.toString(),
    //   "likeFacebookLink": giveaway.likefacebookLink.toString(),
    //   "followPageOnFacebook": giveaway.followPageOnFacebook.toString(),
    //   "likePostOnFacebook": giveaway.likePostOnFacebook.toString(),
    //   "payment_reference": giveaway.paymentReference ?? '',
    //   "payment_status": giveaway.paymentStatus!,
    //   "gateway_response": giveaway.gatewayResponse!,
    //   "expiry": giveaway.expiry!,
    //   "endAt": giveaway.endAt.toString(),
    // }; 
    Map<String, String> body; 
    Map<String, String>? header;
    String msg= 'nil';
    String paymentType= 'nil';
    String likeTweetLink= 'nil';
    String followTwitterLink= 'nil';
    String likeInstagramLink= 'nil';
    String followInstagramLink= 'nil';
    String likeFacebookLink= 'nil';
    String payment_reference= 'nil';
    String payment_status= 'nil';
    String gateway_response= 'nil';
    String expiry= 'nil';

    if(giveaway.message!=null && giveaway.message!.isNotEmpty){
      msg= giveaway.message!;
    }
    if(giveaway.paymentType !=null && giveaway.paymentType!.isNotEmpty){
      paymentType= giveaway.paymentType!;
    }
    if(giveaway.likeTweetLink?.toString() !=null && giveaway.likeTweetLink.toString().isNotEmpty){
      likeTweetLink= giveaway.likeTweetLink.toString();
    }
    if(giveaway.followTwitterLink?.toString() !=null && giveaway.followTwitterLink.toString().isNotEmpty){
      followTwitterLink= giveaway.followTwitterLink.toString();
    }
    if(giveaway.likeInstagramLink?.toString() !=null && giveaway.likeInstagramLink.toString().isNotEmpty){
      likeInstagramLink= giveaway.likeInstagramLink.toString();
    }
    if(giveaway.followInstagramLink?.toString() !=null && giveaway.followInstagramLink.toString().isNotEmpty){
      followInstagramLink= giveaway.followInstagramLink.toString();
    }
    if(giveaway.likefacebookLink?.toString() !=null && giveaway.likefacebookLink.toString().isNotEmpty){
      likeFacebookLink= giveaway.likefacebookLink.toString();
    }
    if(giveaway.paymentReference !=null && giveaway.paymentReference!.isNotEmpty){
      payment_reference= giveaway.paymentReference!;
    }
    if(giveaway.paymentStatus !=null && giveaway.paymentStatus!.isNotEmpty){
      payment_status= giveaway.paymentStatus!;
    }
    if(giveaway.gatewayResponse !=null && giveaway.gatewayResponse!.isNotEmpty){
      gateway_response= giveaway.gatewayResponse!;
    }
    if(giveaway.expiry !=null && giveaway.expiry!.isNotEmpty){
      expiry= giveaway.expiry!;
    }


    body = {
      "amount": giveaway.amount!,
      "type": giveaway.type!,
      "amountPerWinner": giveaway.amountPerWinner!,
      "isAnonymous": giveaway.isAnonymous.toString(),
      "frequency": giveaway.frequency!,
      "message": msg,
      "payment_type": paymentType,
      "likeTweet": giveaway.likeTweet.toString(),
      "followTwitter": giveaway.followTwitter.toString(),
      "likeTweetLink": likeTweetLink,
      "followTwitterLink": followTwitterLink,
      "likeInstagram": giveaway.likeInstagram.toString(),
      "followInstagram": giveaway.followInstagram.toString(),
      "likeInstagramLink": likeInstagramLink,
      "followInstagramLink": followInstagramLink,
      "likeFacebook": giveaway.likeFacebook.toString(),
      "likeFacebookLink": likeFacebookLink,
      "followPageOnFacebook": giveaway.followPageOnFacebook.toString(),
      "likePostOnFacebook": giveaway.likePostOnFacebook.toString(),
      "payment_reference": payment_reference,
      "payment_status": payment_status,
      "gateway_response": gateway_response,
      "expiry": expiry,
      "endAt": giveaway.endAt.toString(),
    };
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.postForm(Uri.parse(GIVEAWAY_URL), giveaway.image,
        header: header, body: body).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return res["message"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that checks if a user has participated in this giveaway [giveawayId]
  Future<dynamic> checkIfParticipated(String giveawayId) async {
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    final CHECK_PARTICIPANT_URL = CHECK_IF_PARTICIPATED + "/$giveawayId";
    return _netUtil.get(CHECK_PARTICIPANT_URL, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return res;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that creates a new giveaway entry POST with [giveawayId]
  Future<dynamic> joinGiveaway(String giveawayId) async {
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    final JOIN_GIVEAWAY_URL = JOIN_GIVEAWAY + "/$giveawayId";
    return _netUtil.get(JOIN_GIVEAWAY_URL, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return res["message"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches all giveaways from the database
  /// into a model of [AllGiveaways] GET.
  Future<List<AllGiveaways>> fetchMyGiveawayContests() async {
    List<AllGiveaways> giveaways;
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.get(MY_CONTESTS, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      var rest = res["data"] as List;
      giveaways = rest.map<AllGiveaways>((json) => AllGiveaways.fromJson(json)).toList();
      return giveaways;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches all participants of a giveaway from the database
  /// into a model of [Participants] GET.
  Future<List<Participants>> fetchMyGiveawayParticipants(String giveawayId) async {
    List<Participants> participants;
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    final MY_GIVEAWAY_PARTICIPANTS_URL = MY_GIVEAWAY_PARTICIPANTS + "/$giveawayId";
    return _netUtil.get(MY_GIVEAWAY_PARTICIPANTS_URL, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      var rest = res["data"] as List;
      participants = rest.map<Participants>((json) => Participants.fromJson(json)).toList();
      return participants;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches all giveaways from the database
  /// into a model of [AllGiveaways] GET.
  Future<List<AllGiveaways>> fetchAllGiveaways({bool? refresh}) async {
    List<AllGiveaways> giveaways;
    String fileName = 'giveaways.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);
    if(refresh == false && file.existsSync()){
      final data = file.readAsStringSync();
      final res = jsonDecode(data);
      var rest = res["data"] as List;
      giveaways = rest.map<AllGiveaways>((json) => AllGiveaways.fromJson(json)).toList();
      return giveaways;
    }

    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.get(GIVEAWAY_URL, headers: header).then((dynamic res) {
      if(res["error"] == true) throw res["message"];
      file.writeAsStringSync(jsonEncode(res), flush: true, mode: FileMode.write);
      var rest = res["data"] as List;
      giveaways = rest.map<AllGiveaways>((json) => AllGiveaways.fromJson(json)).toList();
      return giveaways;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches all my giveaways from the database
  /// into a model of [AllGiveaways] GET.
  Future<List<AllGiveaways>> fetchMyGiveaway() async {
    List<AllGiveaways> giveaways;
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.get(FETCH_MY_GIVEAWAY_LIST, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      var rest = res["data"] as List;
      giveaways = rest.map<AllGiveaways>((json) => AllGiveaways.fromJson(json)).toList();
      return giveaways;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches all my giveaway conditions from the database
  /// into a model of [GiveawayCondition] GET.
  Future<List<GiveawayCondition>> fetchGiveawayConditions() async {
    List<GiveawayCondition> conditions;
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.get(GIVEAWAY_CONDITIONS, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      var rest = res["data"] as List;
      conditions = rest.map<GiveawayCondition>((json) => GiveawayCondition.fromJson(json)).toList();
      return conditions;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches a giveaway condition from the database
  /// into a model of [GiveawayCondition] GET.
  Future<GiveawayCondition> fetchAGiveawayCondition(String id) async {
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    final GIVEAWAY_CONDITION = GIVEAWAY_CONDITIONS + "/$id";
    return _netUtil.get(GIVEAWAY_CONDITION, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return GiveawayCondition.fromJson(res["data"]);
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches all my giveaway conditions from the database
  /// into a model of [GiveawayType] GET.
  Future<List<GiveawayType>> fetchGiveawayTypes() async {
    List<GiveawayType> types;
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.get(GIVEAWAY_TYPES, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      var rest = res["data"] as List;
      types = rest.map<GiveawayType>((json) => GiveawayType.fromJson(json)).toList();
      return types;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches a giveaway condition from the database
  /// into a model of [GiveawayType] GET.
  Future<GiveawayType> fetchGiveawayType(String id) async {
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    final GIVEAWAY_TYPE = GIVEAWAY_TYPES + "/$id";
    return _netUtil.get(GIVEAWAY_TYPE, headers: header).then((dynamic res) {
      if(res["error"]) throw (res["message"]);
      return GiveawayType.fromJson(res["data"]);
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches winners of a giveaway
  /// into a map of model of [Participants] GET.
  Future<List<Participants>> fetchGiveawayWinner(String giveawayId) async {
    List<Participants> winners = [];
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    final GIVEAWAY_WINNERS = GIVEAWAY_WINNERS_URL + "/$giveawayId";
    return _netUtil.get(GIVEAWAY_WINNERS, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      var rest = res["data"] as List;
      winners = rest.map<Participants>((json) => Participants.fromJson(json)).toList();
      return winners;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches all top and recent winners of giveaways
  /// into a map of string and model of [Participants] GET.
  Future<Map<String, List<Participants>>> fetchTopAndRecentWinner({bool? refresh}) async {
    Map<String, List<Participants>> data = Map();

    String fileName = 'winners.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);
    if(refresh == false && file.existsSync()){
      final fileData = file.readAsStringSync();
      final res = jsonDecode(fileData);
      var recent = res["data"]['latest'] as List;
      var top = res["data"]['top'] as List;
      data['recent'] = recent.map<Participants>((json) => Participants.fromJson(json)).toList();
      data['top'] = top.map<Participants>((json) => Participants.fromJson(json)).toList();
      return data;
    }

    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.get(TOP_AND_RECENT_WINNERS, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      file.writeAsStringSync(jsonEncode(res), flush: true, mode: FileMode.write);
      var recent = res["data"]['latest'] as List;
      var top = res["data"]['top'] as List;
      data['recent'] = recent.map<Participants>((json) => Participants.fromJson(json)).toList();
      data['top'] = top.map<Participants>((json) => Participants.fromJson(json)).toList();
      return data;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches all top givers of giveaways
  /// into a map of string and model of [User] GET.
  Future<List<TopGiversWithAmount>> fetchTopGivers({bool? refresh}) async {
    List<TopGiversWithAmount> givers = [];

    String fileName = 'givers.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);
    if(refresh == false && file.existsSync()){
      final fileData = file.readAsStringSync();
      final res = jsonDecode(fileData);
      var rest = res["data"] as List;
      givers = rest.map<TopGiversWithAmount>((json) => TopGiversWithAmount.fromJson(json)).toList();
      return givers;
    }

    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.get(TOP_GIVERS, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      file.writeAsStringSync(jsonEncode(res), flush: true, mode: FileMode.write);
      var rest = res["data"] as List;
      givers = rest.map<TopGiversWithAmount>((json) => TopGiversWithAmount.fromJson(json)).toList();
      return givers;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches all givers of giveaways
  /// into a map of string and model of [User] GET.
  Future<List<dynamic>> fetchAllGivers({bool? refresh}) async {
    List<dynamic> result = [];
    List<TopGiversWithAmount> giversWithAmount = [];
    List<TopGiversWithCount> giversWithCount = [];

    String fileName = 'allGivers.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);
    if(refresh == false && file.existsSync()){
      final fileData = file.readAsStringSync();
      final res = jsonDecode(fileData);
      var restWithAmount = res["data"][0] as List;
      var restWithCount = res["data"][1] as List;
      giversWithAmount = restWithAmount.map<TopGiversWithAmount>((json) => TopGiversWithAmount.fromJson(json)).toList();
      result.add(giversWithAmount);
      giversWithCount = restWithCount.map<TopGiversWithCount>((json) => TopGiversWithCount.fromJson(json)).toList();
      result.add(giversWithCount);
      return result;
    }

    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.get(ALL_GIVERS, headers: header).then((dynamic res) {
      if(res["error"]) throw (res["message"]);
      file.writeAsStringSync(jsonEncode(res), flush: true, mode: FileMode.write);
      var restWithAmount = res["data"][0] as List;
      var restWithCount = res["data"][1] as List;
      giversWithAmount = restWithAmount.map<TopGiversWithAmount>((json) => TopGiversWithAmount.fromJson(json)).toList();
      result.add(giversWithAmount);
      giversWithCount = restWithCount.map<TopGiversWithCount>((json) => TopGiversWithCount.fromJson(json)).toList();
      result.add(giversWithCount);
      return result;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches all my winnings of a giveaway
  /// into a model of [dynamic] GET.
  Future<List<GiveawayWinnings>> fetchMyGiveawayWinnings() async {
    List<GiveawayWinnings> winnings;
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.get(MY_GIVEAWAY_WINNINGS, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      var rest = res["data"] as List;
      winnings = rest.map<GiveawayWinnings>((json) => GiveawayWinnings.fromJson(json)).toList();
      return winnings;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches all my wallet topup history from the database
  /// into a model of [WalletTopUpHistory] GET.
  Future<List<WalletTopUpHistory>> fetchWalletTopupHistory() async {
    List<WalletTopUpHistory> history;
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.get(FETCH_WALLET_TOPUP_HISTORY, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      var rest = res["data"] as List;
      history = rest.map<WalletTopUpHistory>((json) => WalletTopUpHistory.fromJson(json)).toList();
      return history;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches a wallet topup history from the database
  /// into a model of [WalletTopUpHistory] GET.
  Future<WalletTopUpHistory> fetchWalletTopup(String id) async {
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    final WALLET = WALLET_TOPUP + "/$id";
    return _netUtil.get(WALLET, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return WalletTopUpHistory.fromJson(res["data"]);
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that does wallet top up POST with [WalletTopup] model
  Future<dynamic> walletTopUp(WalletTopup topup) async {
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.post(WALLET_TOPUP, headers: header, body: {
      "amount": topup.amount,
      "payment_reference": topup.paymentReference,
      "payment_status": topup.paymentStatus,
      "gateway_response": topup.gatewayResponse,
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return res["message"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches all my free withdrawal history from the database
  /// into a model of [FreeWithdrawalHistory] GET.
  Future<List<FreeWithdrawalHistory>> fetchFreeWithdrawalHistory() async {
    List<FreeWithdrawalHistory> history;
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.get(FREE_WITHDRAWAL_HISTORY, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      var rest = res["data"] as List;
      history = rest.map<FreeWithdrawalHistory>((json) => FreeWithdrawalHistory.fromJson(json)).toList();
      return history;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches all my transfer history from the database
  /// into a model of [TransferHistory] GET.
  Future<List<TransferHistory>> fetchTransferHistory() async {
    List<TransferHistory> history;
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.get(FETCH_TRANSFER_HISTORY, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      var rest = res["data"] as List;
      history = rest.map<TransferHistory>((json) => TransferHistory.fromJson(json)).toList();
      return history;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that create transfer POST with [accountNumber] and [bankCode]
  Future<dynamic> createTransfer(String accountNumber, String bankCode) async{
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.post(CREATE_TRANSFER, headers: header, body: {
      "accountNumber": accountNumber,
      "bankCode": bankCode,
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return res["data"]["recipient_code"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that initializes transfer payment POST.
  /// with [amount], [recipientCode] and [pin]
  Future<dynamic> initiateTransfer(String amount, String recipientCode, String pin, String? bank, String? no) async{
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    String? lat;
    String? long;
    await futureValue.getUserLocation(coordinates: true).then((value) {
      lat = value['lat'].toString();
      long = value['long'].toString();
    }).catchError((e){
      print(e);
    });
    return _netUtil.post(INITIATE_TRANSFER, headers: header, body: {
      "amount": amount,
      "recipient_code": recipientCode,
      "transaction_pin": pin,
      "bankName": bank,
      "accountNumber": no,
      "latitude": lat,
      "longitude": long
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return res["message"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that initializes transfer payment POST.
  /// with [amount], [recipientCode] and [pin]
  Future<dynamic> freeWithdrawal(Banks bank, String amount, String recipientCode) async{
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    String? lat;
    String? long;
    await futureValue.getUserLocation(coordinates: true).then((value) {
      lat = value['lat'].toString();
      long = value['long'].toString();
    }).catchError((e){
      print(e);
    });
    return _netUtil.post(FREE_WITHDRAWAL, headers: header, body: {
      "amount": amount,
      "recipient_code": recipientCode,
      "bankCode": bank.bankCode,
      "accountNumber": bank.accountNumber,
      "bankName": bank.bankName,
      "accountName": bank.accountName,
      "latitude": lat,
      "longitude": long
    }).then((dynamic res) {
      if(res["error"]) throw (res["message"]);
      return res["message"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that does wallet to wallet transfer payment POST.
  /// with [amount], [recipientCode] and [pin]
  Future<dynamic> w2wTransfer(String amount, String phone, String pin) async{
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.post(W2W_TRANSFER, headers: header, body: {
      "amount": amount,
      "phoneNumber": phone,
      "narration": 'Gift',
      "transaction_pin": pin,
    }).then((dynamic res) {
      if(res["error"]) throw res["message"];
      return res["message"];
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

  /// A function that fetches all my surprise history from the database
  /// into a model of [SurpriseHistory] GET.
  Future<List<SurpriseHistory>> fetchSurpriseHistory() async {
    List<SurpriseHistory> history;
    Map<String, String>? header;
    Future<User?> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value?.token == null) throw ("You're unauthorized, log out and login back to continue");
      header = {"x-auth-token": "${value!.token}", "content-Type": "application/json"};
    });
    return _netUtil.get(SURPRISE_HISTORY, headers: header).then((dynamic res) {
      if(res["error"]) throw res["message"];
      var rest = res["data"] as List;
      history = rest.map<SurpriseHistory>((json) => SurpriseHistory.fromJson(json)).toList();
      return history;
    }).catchError((e){
      errorHandler.handleError(e);
    });
  }

}