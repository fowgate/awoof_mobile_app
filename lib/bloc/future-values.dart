import 'package:awoof_app/database/user-db-helper.dart';
import 'package:awoof_app/model/banks.dart';
import 'package:awoof_app/model/free-withdrawals.dart';
import 'package:awoof_app/model/giveaway-conditions.dart';
import 'package:awoof_app/model/giveaway-type.dart';
import 'package:awoof_app/model/giveaways.dart';
import 'package:awoof_app/model/my-airtime-topup-history.dart';
import 'package:awoof_app/model/nigerian-banks.dart';
import 'package:awoof_app/model/notifications.dart';
import 'package:awoof_app/model/participants.dart';
import 'package:awoof_app/model/socials.dart';
import 'package:awoof_app/model/top-givers.dart';
import 'package:awoof_app/model/transfer-history.dart';
import 'package:awoof_app/model/user.dart';
import 'package:awoof_app/model/giveaway-winnings.dart';
import 'package:awoof_app/model/wallet-topup-history.dart';
import 'package:awoof_app/model/surprise-history.dart';
import 'package:awoof_app/networking/rest-data.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// A class to handle my asynchronous methods linking to the server or database
class FutureValues{

  /// Method to get the current [user] in the database using the
  /// [DatabaseHelper] class
  Future<User?> getCurrentUser() async {
    var dbHelper = DatabaseHelper();
    Future<User?> user = dbHelper.getUser();
    return user;
  }

  /// Method to get the current [user] in the database using the
  /// [DatabaseHelper] class and update in the sqlite table
  Future<void> updateUser() async {
    var data = RestDataSource();
    var db = DatabaseHelper();
    await data.getCurrentUser().then((value) async {
      User user = value['user'];
      String token = value['token'];
      var myUpdate = User(
          user.id,
          user.balance,
          token,
          user.isPinSet,
          user.isAccountSet,
          user.isVerified,
          user.isAdmin,
          user.firstName,
          user.lastName,
          user.phone,
          user.email,
          user.userName,
          user.signupDate,
          user.userRef,
          user.gender,
          user.location,
          user.image,
          user.stars,
          user.following,
          user.followers,
          user.giveawaysWon,
          user.giveawaysAmountWon,
          user.giveawaysParticipated,
          user.giveawaysDone
      );
      await db.updateUser(myUpdate);
    }).catchError((error) {
      print(error);
    });
  }

  /// Function to get all the user notifications in the database with
  /// the help of [RestDataSource]
  /// It returns a list of [MyNotifications]
  Future<List<MyNotifications>> getAllUserNotifications() {
    var data = RestDataSource();
    Future<List<MyNotifications>> notifications = data.getNotifications();
    return notifications;
  }

  /// Function to get all registered phone number in the database with
  /// the help of [RestDataSource]
  /// It returns a list of [String]
  Future<List<String>> getAllPhilantroContacts() {
    var data = RestDataSource();
    Future<List<String>> contacts = data.getContacts();
    return contacts;
  }

  /// Function to get all the user socials in the database with
  /// the help of [RestDataSource]
  /// It returns a model of [SocialAccounts]
  Future<SocialAccounts> getAllUserSocialsFromDB() {
    var data = RestDataSource();
    Future<SocialAccounts> socials = data.fetchMySocials();
    return socials;
  }

  /// Function to get all the user banks in the database with
  /// the help of [RestDataSource]
  /// It returns a list of [NigerianBanks]
  Future<List<Banks>> getAllUserBanksFromDB() {
    var data = RestDataSource();
    Future<List<Banks>> banks = data.fetchUserBanks();
    return banks;
  }

  /// Function to get all the nigerian bank names in the database with
  /// the help of [getAllBanksFromDB()]
  /// It returns a list of [String]
  Future<List<String>> getAllBankNames() async {
    List<String> bankNames = [];
    Future<List<NigerianBanks>> banks = getAllBanksFromDB();
    await banks.then((value){
      for(int i = 0; i < value.length; i++){
        bankNames.add(value[i].name!);
      }
    }).catchError((e){
      print(e);
      throw e;
    });
    return bankNames;
  }

  /// Function to get all the nigerian banks in the database with
  /// the help of [RestDataSource]
  /// It returns a list of [NigerianBanks]
  Future<List<NigerianBanks>> getAllBanksFromDB() {
    var data = RestDataSource();
    Future<List<NigerianBanks>> banks = data.fetchAllBanks();
    return banks;
  }

  /// Function to get all the user's wallet top up history in the database with
  /// the help of [RestDataSource]
  /// It returns a list of [WalletTopUpHistory]
  Future<List<WalletTopUpHistory>> getWalletTopUpHistory() {
    var data = RestDataSource();
    Future<List<WalletTopUpHistory>> history = data.fetchWalletTopupHistory();
    return history;
  }

  /// Function to get all the user's transfer history in the database with
  /// the help of [RestDataSource]
  /// It returns a list of [FreeWithdrawalHistory]
  Future<List<FreeWithdrawalHistory>> getFreeWithdrawalHistory() {
    var data = RestDataSource();
    Future<List<FreeWithdrawalHistory>> history = data.fetchFreeWithdrawalHistory();
    return history;
  }

  /// Function to get all the user's transfer history in the database with
  /// the help of [RestDataSource]
  /// It returns a list of [TransferHistory]
  Future<List<TransferHistory>> getTransferHistory() {
    var data = RestDataSource();
    Future<List<TransferHistory>> history = data.fetchTransferHistory();
    return history;
  }

  /// Function to get all the user's surprise history in the database with
  /// the help of [RestDataSource]
  /// It returns a list of [SurpriseHistory]
  Future<List<SurpriseHistory>> getSurpriseHistory() {
    var data = RestDataSource();
    Future<List<SurpriseHistory>> history = data.fetchSurpriseHistory();
    return history;
  }

  /// Function to get an access token for reloadly in the database with
  /// the help of [RestDataSource]
  /// It returns a map value
  Future<dynamic> getAccessToken() {
    var data = RestDataSource();
    Future<dynamic> result = data.fetchAccessToken();
    return result;
  }

  /// Function to get all the airtime topup history in the database with
  /// the help of [RestDataSource]
  /// It returns a list of [AirtimeTopUpHistory]
  Future<List<AirtimeTopUpHistory>> getAirtimeHistory() {
    var data = RestDataSource();
    Future<List<AirtimeTopUpHistory>> history = data.fetchAirtimeTopUpHistory();
    return history;
  }

  /// Function to get all the total giveaway details in the database with
  /// the help of [RestDataSource]
  /// It returns [Map<String, String>]
  Future<Map<String, String>> getGiveawayDetails() {
    var data = RestDataSource();
    Future<Map<String, String>> details = data.fetchGiveawayDetails();
    return details;
  }

  /// Function to get all the giveaway winners in the database with
  /// the help of [RestDataSource]
  /// It returns [List<Participants>]
  Future<List<Participants>> getGiveawayWinners(String id) {
    var data = RestDataSource();
    Future<List<Participants>> winners = data.fetchGiveawayWinner(id);
    return winners;
  }

  /// Function to get all the top givers in the database with
  /// the help of [RestDataSource]
  /// It returns a list of [TopGiversWithAmount]
  Future<List<TopGiversWithAmount>> getTopGivers({bool? refresh}) {
    var data = RestDataSource();
    Future<List<TopGiversWithAmount>> givers = data.fetchTopGivers(refresh: refresh);
    return givers;
  }

  /// Function to get all the givers in the database with
  /// the help of [RestDataSource]
  /// It returns a list of [dynamic]
  Future<List<dynamic>> getAllGivers({bool? refresh}) {
    var data = RestDataSource();
    Future<List<dynamic>> givers = data.fetchAllGivers(refresh: refresh);
    return givers;
  }

  /// Function to get all the top givers in the database with
  /// the help of [RestDataSource]
  /// It returns [Map<String, List<Participants>>]
  Future<Map<String, List<Participants>>> getTopAndRecentWinners({bool? refresh}) {
    var data = RestDataSource();
    Future<Map<String, List<Participants>>> winners = data.fetchTopAndRecentWinner(refresh: refresh);
    return winners;
  }

  /// Function to get all the giveaways in the database with
  /// the help of [RestDataSource]
  /// It returns a list of [AllGiveaways]
  Future<List<AllGiveaways>> getAllGiveaways({bool? refresh}) async {
    List<AllGiveaways> sortedGiveaways = [];
    List<AllGiveaways> sortedExpiredGiveaways = [];
    var data = RestDataSource();
    Future<List<AllGiveaways>> giveaways = data.fetchAllGiveaways(refresh: refresh);
    await giveaways.then((value){
      for(int i = 0; i < value.length; i++){
        if(value[i] != null){
          if(value[i].hidden == null || value[i].hidden == false){
            if(value[i].completed != null){
              if(value[i].completed!){
              sortedExpiredGiveaways.add(value[i]);
              }
              else {
                sortedGiveaways.add(value[i]);
              }
            } else {
              sortedGiveaways.add(value[i]);
            }
          }
        }
      }
      sortedExpiredGiveaways.sort((a, b) => getTimeDifference(a.createdAt).compareTo(getTimeDifference(b.createdAt)));
      sortedGiveaways.sort((a, b) => getTimeDifference(a.createdAt).compareTo(getTimeDifference(b.createdAt)));
      sortedGiveaways.addAll(sortedExpiredGiveaways);
    }).catchError((e){
      throw e;
    });
    return sortedGiveaways;
  }

  /// Function to get all my giveaways in the database with
  /// the help of [RestDataSource]
  /// It returns a list of [AllGiveaways]
  Future<List<AllGiveaways>> getMyGiveaways() async {
    List<AllGiveaways> sortedGiveaways = [];
    var data = RestDataSource();
    Future<List<AllGiveaways>> giveaways = data.fetchMyGiveaway();
    await giveaways.then((value){
      sortedGiveaways.addAll(value);
      sortedGiveaways.sort((a, b) => getTimeDifference(a.createdAt).compareTo(getTimeDifference(b.createdAt)));
    }).catchError((e){
      throw e;
    });
    return sortedGiveaways;
  }

  /// Function to get all the giveaway contests in the database with
  /// the help of [RestDataSource]
  /// It returns a list of [AllGiveaways]
  Future<List<AllGiveaways>> getAllGiveawayContests() {
    var data = RestDataSource();
    Future<List<AllGiveaways>> giveaways = data.fetchMyGiveawayContests();
    return giveaways;
  }

  /// Function to get all the participants of a giveaway in the database with
  /// the help of [RestDataSource]
  /// It returns a list of [Participants]
  Future<List<Participants>> getMyGiveawayParticipants(String id) {
    var data = RestDataSource();
    Future<List<Participants>> participants = data.fetchMyGiveawayParticipants(id);
    return participants;
  }

  /// Function to get all the give away types in the database with
  /// the help of [RestDataSource]
  /// It returns a list of [GiveawayType]
  Future<List<GiveawayType>> getGiveAwayTypes() {
    var data = RestDataSource();
    Future<List<GiveawayType>> types = data.fetchGiveawayTypes();
    return types;
  }

  /// Function to get all the gice away condition in the database with
  /// the help of [RestDataSource]
  /// It returns a list of [GiveawayCondition]
  Future<List<GiveawayCondition>> getGiveAwayConditions() {
    var data = RestDataSource();
    Future<List<GiveawayCondition>> conditions = data.fetchGiveawayConditions();
    return conditions;
  }

  /// Function to get all my giveaway winnings in the database with
  /// the help of [RestDataSource]
  /// It returns a list of [GiveawayWinnings]
  Future<List<GiveawayWinnings>> getGiveawayWinnings() {
    var data = RestDataSource();
    Future<List<GiveawayWinnings>> winnings = data.fetchMyGiveawayWinnings();
    return winnings;
  }

  /// Function to get difference of a particular date time to the current
  /// dateTime
  /// It returns an Integer
  int getTimeDifference(DateTime? dateTime){
    if(dateTime != null){
      var now = DateTime.now();
      var time = dateTime;
      var difference = now.difference(time).inDays;
      return difference;
    } else{
      return 0;
    }
  }

  /// Function to get all the wallet transaction in the database with
  /// by calling [getAllCreditTransactionFromDB()] and [getAllDebitTransactionFromDB()]
  /// It returns a list of [dynamic]
  Future<List<dynamic>> getAllHistory() async {
    List<dynamic> sortedHistory = [];
    List<dynamic> history = [];
    Future<List<AirtimeTopUpHistory>> airtime = getAirtimeHistory();
    await airtime.then((value) async {
      history.addAll(value);
      Future<List<TransferHistory>> transfer = getTransferHistory();
      await transfer.then((value) async {
        history.addAll(value);
        Future<List<WalletTopUpHistory>> topUp = getWalletTopUpHistory();
        await topUp.then((value) async {
          history.addAll(value);
          Future<List<GiveawayWinnings>> winnings = getGiveawayWinnings();
          await winnings.then((value) async {
            history.addAll(value);
            Future<List<SurpriseHistory>> surprise = getSurpriseHistory();
            await surprise.then((value) async {
              for(int i = 0; i < value.length; i++){
                if(value[i].type!.contains('cash')) history.add(value[i]);
              }
              Future<List<FreeWithdrawalHistory>> freeWithdrawal = getFreeWithdrawalHistory();
              await freeWithdrawal.then((value) {
                history.addAll(value);
                history.sort((a, b) => getTimeDifference(a.transactionDate).compareTo(getTimeDifference(b.transactionDate)));
                sortedHistory.addAll(history);
              }).catchError((e){
                throw e;
              });
            }).catchError((e){
              throw e;
            });
          }).catchError((e){
            throw e;
          });
        }).catchError((e  ){
          throw e;
        });
      }).catchError((e){
        throw e;
      });
    }).catchError((e){
      throw e;
    });
    return sortedHistory;
  }

  /// This function gets the state and country from the coordinates
  /// [latitude] and [longitude]
  Future<String> getAddress(double latitude, double longitude)async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placeMarks[0];
    return '${place.locality ?? ''}, ${place.country ?? ''}';
  }

  /// This function gets the user's location
  /// It returns the longitude and latitude in a Map if [coordinates] is true
  /// It returns the address by calling [getAddress()] if [coordinates] is
  /// false or null
  Future<dynamic> getUserLocation({bool? coordinates}) async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final result = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    Map<String, double> cord = {"lat": result.latitude, "long": result.longitude};
    if(coordinates == true) return cord;
    String? myAddress;
    await getAddress(result.latitude, result.longitude).then((address) {
      myAddress = address;
    }).catchError((e){
      print(e);
      throw(e);
    });
    if(coordinates == null) return myAddress;
    return myAddress;
  }

}