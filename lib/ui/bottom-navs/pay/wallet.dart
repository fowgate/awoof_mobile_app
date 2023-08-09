import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/model/free-withdrawals.dart';
import 'package:awoof_app/model/my-airtime-topup-history.dart';
import 'package:awoof_app/model/transfer-history.dart';
import 'package:awoof_app/model/giveaway-winnings.dart';
import 'package:awoof_app/model/user.dart';
import 'package:awoof_app/model/wallet-topup.dart';
import 'package:awoof_app/model/wallet-topup-history.dart';
import 'package:awoof_app/model/surprise-history.dart';
import 'package:awoof_app/networking/rest-data.dart';
import 'package:awoof_app/ui/blessing/paystack-webview.dart';
import 'package:awoof_app/ui/bottom-navs/home/giveaway/giveaway-details.dart';
import 'package:awoof_app/ui/bottom-navs/pay/airtime.dart';
import 'package:awoof_app/ui/bottom-navs/pay/cash-out.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:awoof_app/utils/rflutter_alert-2.0.4/lib/rflutter_alert.dart';
//import 'package:rflutter_alert/rflutter_alert.dart';

class Wallet extends StatefulWidget {

  static const String id = 'wallet_page';

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {

  var f = new NumberFormat("#,###.##", "en_US");

  String display = '';

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// GlobalKey of a my RefreshIndicatorState to refresh my list items in the page
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  /// A List to hold the all the wallet history a user has
  List<dynamic> _walletHistory = [];

  /// An Integer variable to hold the length of [_walletHistory]
  int? _walletHistoryLength;

  /// A double variable to hold the wallet balance
  double _balance = 0;

  bool _balanceLoaded = false;

  Widget _creditIcon = Container(
    width: 26,
    height: 26,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(13),
      ),
      color: Color(0xFF09AB5D).withOpacity(0.4),
    ),
    child: Icon(
      Icons.arrow_downward,
      size: 15,
      color: Color(0xFF09AB5D)
    ),
  );

  Widget _debitIcon =  Container(
    width: 26,
    height: 26,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(13),
      ),
      color: Color(0xFFF5B7B1).withOpacity(0.4),
    ),
    child: Icon(
      Icons.arrow_upward,
      size: 15,
      color: Color(0xFFE64C3C),
    ),
  );

  /// Setting the current user's account balance to [_balance]
  void _getCurrentUser() async {
    await futureValue.updateUser();
    await futureValue.getCurrentUser().then((user) {
      if(!mounted)return;
      setState(() {
        _balance = double.parse(user!.balance!);
        _balanceLoaded = true;
      });
    }).catchError((Object error) {
      print(error);
    });
  }

  void initState() {
    super.initState();
    _getCurrentUser();
    _allHistory();
  }

  /// Function to fetch all the history from the database to
  /// [_walletHistoryLength]
  Future<void> _allHistory() async {
    _walletHistoryLength = null;
    _walletHistory.clear();
    Future<List<dynamic>> history = futureValue.getAllHistory();
    await history.then((value) {
      if(value.isEmpty || value.length == 0){
        if(!mounted)return;
        setState(() {
          _walletHistoryLength = 0;
          _walletHistory = [];
        });
      } else if (value.length > 0){
        if(!mounted)return;
        setState(() {
          _walletHistory.addAll(value);
          _walletHistoryLength = value.length;
        });
      }
    })/*.catchError((error){
      print(error);
      if(!mounted)return;
      Constants.showError(context, error);
    })*/;
  }

  /// Function to refresh the balance of the user
  /// similar to [_getCurrentUser()]
  Future<Null> _refresh() async {
    if(!mounted)return;
    setState(() { _balanceLoaded = false; });
    await futureValue.updateUser();
    _allHistory();
    Future<User?> user = futureValue.getCurrentUser();
    return user.then((user) {
      if(!mounted)return;
      setState(() {
        _balance = double.parse(user!.balance!);
        _balanceLoaded = true;
      });
    }).catchError((e){
      print(e);
      Constants.showError(context, e);
    });
  }

  /// A function to build the list of all the transfer history the user has
  Widget _buildList() {
    if(_walletHistory.length > 0 && _walletHistory.isNotEmpty){
      return ListView.builder(
        itemCount: _walletHistory == null ? 0 : _walletHistory.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          Widget item;
          if(_walletHistory[index] is AirtimeTopUpHistory){
            AirtimeTopUpHistory topUp = _walletHistory[index];
            item = Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _debitIcon,
                        SizedBox(width: 10),
                        Container(
                          width: (SizeConfig.screenWidth! - 60) * 0.55,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Airtime Recharge',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Regular',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF777777),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${_getTimeDifference(topUp.transactionDate!)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Regular',
                                  color: Color(0xFF99A1AD),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: (SizeConfig.screenWidth! - 60) * 0.33,
                      child: Text(
                        Constants.money(double.parse(topUp.amount!), 'N'),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Regular',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Container(
                  color: Color(0xFFD7D7D7),
                  height: 1,
                  width: SizeConfig.screenWidth,
                ),
                SizedBox(height: 15),
              ],
            );
          }
          else if(_walletHistory[index] is TransferHistory){
            TransferHistory transfer = _walletHistory[index];
            item = Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _debitIcon,
                        SizedBox(width: 10),
                        Container(
                          width: (SizeConfig.screenWidth! - 60) * 0.55,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                transfer.narration ?? 'Cash Out',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Regular',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF777777),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${_getTimeDifference(transfer.transactionDate!)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Regular',
                                  color: Color(0xFF99A1AD),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: (SizeConfig.screenWidth! - 60) * 0.33,
                      child: Text(
                        Constants.money(double.parse(transfer.amount!), 'N'),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Regular',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Container(
                  color: Color(0xFFD7D7D7),
                  height: 1,
                  width: SizeConfig.screenWidth,
                ),
                SizedBox(height: 15),
              ],
            );
          }
          else if(_walletHistory[index] is WalletTopUpHistory){
            WalletTopUpHistory wallet = _walletHistory[index];
            item = Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _creditIcon,
                        SizedBox(width: 10),
                        Container(
                          width: (SizeConfig.screenWidth! - 60) * 0.55,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Wallet Top-up',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Regular',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF777777),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${_getTimeDifference(wallet.transactionDate!)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Regular',
                                  color: Color(0xFF99A1AD),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: (SizeConfig.screenWidth! - 60) * 0.33,
                      child: Text(
                        Constants.money(double.parse(wallet.amount!), 'N'),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Regular',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Container(
                  color: Color(0xFFD7D7D7),
                  height: 1,
                  width: SizeConfig.screenWidth,
                ),
                SizedBox(height: 15),
              ],
            );
          }
          else if(_walletHistory[index] is GiveawayWinnings){
            GiveawayWinnings wallet = _walletHistory[index];
            item = InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GiveawayDetails(
                      giveaway: wallet.giveaway!,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          _creditIcon,
                          SizedBox(width: 10),
                          Container(
                            width: (SizeConfig.screenWidth! - 60) * 0.55,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  wallet.giveaway != null
                                      ? wallet.giveaway!.user.runtimeType is String
                                          ? 'Giveaway Winnings'
                                          : 'Giveaway Winnings from ${wallet.giveaway!.isAnonymous! ? 'Anonymous Giver' : wallet.giveaway!.user.userName ?? ''}'
                                      : 'Giveaway Winnings',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Regular',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF777777),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${_getTimeDifference(wallet.transactionDate)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Regular',
                                    color: Color(0xFF99A1AD),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: (SizeConfig.screenWidth! - 60) * 0.33,
                        child: Text(
                          Constants.money(double.parse(wallet.amount), 'N'),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    color: Color(0xFFD7D7D7),
                    height: 1,
                    width: SizeConfig.screenWidth,
                  ),
                  SizedBox(height: 15),
                ],
              ),
            );
          }
          else if(_walletHistory[index] is SurpriseHistory){
            SurpriseHistory wallet = _walletHistory[index];
            item = Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _creditIcon,
                        SizedBox(width: 10),
                        Container(
                          width: (SizeConfig.screenWidth! - 60) * 0.55,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                wallet.narration ?? 'Awoof Surprise',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Regular',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF777777),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${_getTimeDifference(wallet.transactionDate!)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Regular',
                                  color: Color(0xFF99A1AD),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: (SizeConfig.screenWidth! - 60) * 0.33,
                      child: Text(
                        Constants.money(double.parse(wallet.amount!), 'N'),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Regular',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Container(
                  color: Color(0xFFD7D7D7),
                  height: 1,
                  width: SizeConfig.screenWidth,
                ),
                SizedBox(height: 15),
              ],
            );
          }
          else if(_walletHistory[index] is FreeWithdrawalHistory){
            FreeWithdrawalHistory wallet = _walletHistory[index];
            item = Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _debitIcon,
                        SizedBox(width: 10),
                        Container(
                          width: (SizeConfig.screenWidth! - 60) * 0.55,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Free Withdrawal to your ${wallet.bankName} account',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Regular',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF777777),
                                ),
                              ),
                              SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Regular',
                                    color: Color(0xFF99A1AD),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '${_getTimeDifference(wallet.transactionDate)} - ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Regular',
                                        color: Color(0xFF99A1AD),
                                      ),
                                    ),
                                    TextSpan(
                                      text: wallet.paid! ? 'Paid' : 'Pending',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Regular',
                                        color: wallet.paid! ? Color(0xFF09AB5D) : Colors.amber,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: (SizeConfig.screenWidth! - 60) * 0.33,
                      child: Text(
                        Constants.money(wallet.amount!, 'N'),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Regular',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Container(
                  color: Color(0xFFD7D7D7),
                  height: 1,
                  width: SizeConfig.screenWidth,
                ),
                SizedBox(height: 15),
              ],
            );
          }
          else {
            item = Container();
          }
          return item;
        },
      );
    }
    else if(_walletHistoryLength == 0){
      return Container(
        alignment: AlignmentDirectional.center,
        child: Center(
            child: Text(
              "No Transaction History Yet",
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Regular",
                letterSpacing: -0.2,
                color: Color(0XFF09AB5D),
              ),
            )),
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0XFF09AB5D)),
        ),
      ),
    );
  }

  void show(String char) {
    if (display.contains('.') && display.split('.')[1].length > 1) {
      print('limit');
    } else {
      if (display.length < 18) {
        if (char == '.') {
          if (!display.contains('.') && display.length > 0) {
            setState(() {
              display += char;
            });
          }
        } else {
          setState(() {
            display += char;
          });
        }
      }
    }
  }

  void backspace() {
    if (display.length > 0) {
      if (display.length == 1) {
        setState(() {
          display = '';
        });
      } else {
        setState(() {
          display = display.substring(0, display.length - 1);
        });
      }
    }
  }

  bool _state = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xFF09AB5D),
      appBar: AppBar(
        backgroundColor: Color(0XFF09AB5D),
        title: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            historyModalSheet(context);
          },
          splashColor: Color(0xFFE8E8E8).withOpacity(0.1),
          child: _walletHistoryLength != null
              ? Container(
            margin: EdgeInsets.all(10),
            child: Text(
              'History',
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Regular",
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFFFFF),
              ),
            ),
          )
              : Container(
                margin: EdgeInsets.all(10),
                child: SizedBox(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF))
            ),
            height: 15.0,
            width: 15.0,
          ),
              ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: Column(
              crossAxisAlignment: _balanceLoaded ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 12),
                Text(
                  'Balance:',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Regular",
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
                SizedBox(height: 2),
                _balanceLoaded
                    ? Text(
                  Constants.money(_balance, 'N'),
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Regular",
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF),
                  ),
                )
                    : Center(
                      child: SizedBox(
                  child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF))
                  ),
                  height: 15.0,
                  width: 15.0,
                ),
                    ),
              ],
            ),
          ),
        ],
        elevation: 0,
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        color: Color(0xFF09AB5D),
        child: SingleChildScrollView(
          child: Container(
            width: SizeConfig.screenWidth,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight! - 136,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: '',
                        style: TextStyle(
                          fontSize: 45,
                          fontFamily: "Regular",
                          color: Color(0xFFFFFFFF),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'N',
                            style: TextStyle(
                              fontSize: 45,
                              fontFamily: "Regular",
                              decoration: TextDecoration.lineThrough,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          TextSpan(
                            text: (display == '')
                                ? '0'
                                : (display[display.length - 1] == '.')
                                ? '${f.format(double.parse(display))}.'
                                : '${f.format(double.parse(display))}',
                            style: TextStyle(
                              fontSize: 45,
                              fontFamily: "Regular",
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        show('1');
                                      },
                                      style: TextButton.styleFrom(
                                          shape: CircleBorder()
                                      ),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        child: Center(
                                          child: Text(
                                            '1',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Regular",
                                              color: Color(0xFFFFFFFF),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        show('4');
                                      },
                                      style: TextButton.styleFrom(
                                          shape: CircleBorder()
                                      ),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        child: Center(
                                          child: Text(
                                            '4',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Regular",
                                              color: Color(0xFFFFFFFF),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        show('7');
                                      },
                                      style: TextButton.styleFrom(
                                          shape: CircleBorder()
                                      ),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        child: Center(
                                          child: Text(
                                            '7',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Regular",
                                              color: Color(0xFFFFFFFF),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        show('.');
                                      },
                                      style: TextButton.styleFrom(
                                          shape: CircleBorder()
                                      ),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        child: Center(
                                          child: Text(
                                            '.',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Regular",
                                              color: Color(0xFFFFFFFF),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        show('2');
                                      },
                                      style: TextButton.styleFrom(
                                          shape: CircleBorder()
                                      ),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        child: Center(
                                          child: Text(
                                            '2',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Regular",
                                              color: Color(0xFFFFFFFF),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        show('5');
                                      },
                                      style: TextButton.styleFrom(
                                          shape: CircleBorder()
                                      ),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        child: Center(
                                          child: Text(
                                            '5',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Regular",
                                              color: Color(0xFFFFFFFF),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        show('8');
                                      },
                                      style: TextButton.styleFrom(
                                          shape: CircleBorder()
                                      ),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        child: Center(
                                          child: Text(
                                            '8',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Regular",
                                              color: Color(0xFFFFFFFF),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        show('0');
                                      },
                                      style: TextButton.styleFrom(
                                          shape: CircleBorder()
                                      ),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        child: Center(
                                          child: Text(
                                            '0',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Regular",
                                              color: Color(0xFFFFFFFF),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        show('3');
                                      },
                                      style: TextButton.styleFrom(
                                          shape: CircleBorder()
                                      ),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        child: Center(
                                          child: Text(
                                            '3',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Regular",
                                              color: Color(0xFFFFFFFF),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        show('6');
                                      },
                                      style: TextButton.styleFrom(
                                          shape: CircleBorder()
                                      ),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        child: Center(
                                          child: Text(
                                            '6',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Regular",
                                              color: Color(0xFFFFFFFF),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        show('9');
                                      },
                                      style: TextButton.styleFrom(
                                          shape: CircleBorder()
                                      ),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        child: Center(
                                          child: Text(
                                            '9',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Regular",
                                              color: Color(0xFFFFFFFF),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        backspace();
                                      },
                                      style: TextButton.styleFrom(
                                          shape: CircleBorder()
                                      ),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        child: Center(
                                          child: Text(
                                            'X',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Regular",
                                              color: Color(0xFFFFFFFF),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: (SizeConfig.screenWidth! - 42) / 2,
                                child: GestureDetector(
                                  onTap: () async {
                                    HapticFeedback.mediumImpact();
                                    if (display.length > 0 && double.parse(display) > 9.0) {
                                      if (double.parse(display) > _balance) {
                                        Constants.showError(context, 'Insufficient funds, top up your wallet');
                                        /*var message = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TopUp(
                                              amount: display,
                                            ),
                                          ),
                                        );
                                        if (message != null && message) {
                                          setState(() {
                                            display = '';
                                          });
                                          _refresh();
                                        }*/
                                      }
                                      else {
                                        var message = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Airtime(
                                              amount: display,
                                            ),
                                          ),
                                        );
                                        if (message != null && message) {
                                          setState(() {
                                            display = '';
                                          });
                                          _refresh();
                                        }
                                      }
                                    }
                                    else {
                                      Constants.showError(context, 'Enter an amount of N10 or more');
                                    }
                                  },
                                  child: Container(
                                    width: SizeConfig.screenWidth,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      color: Color(0XFF089A54),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Airtime',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Bold",
                                          color: Color(0xFFFFFFFF),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: (SizeConfig.screenWidth! - 42) / 2,
                                child: GestureDetector(
                                  onTap: () async {
                                    HapticFeedback.mediumImpact();
                                    if (display.length > 0 && double.parse(display) >= 1000.0) {
                                      if ((double.parse(display) /*+ ((5 / 100) * double.parse(display))*/) > _balance) {
                                        Constants.showError(context, 'Insufficient funds');
                                      }
                                      else {
                                        var message = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CashOut(
                                              amount: display
                                            ),
                                          ),
                                        );
                                        if (message != null && message) {
                                          setState(() {
                                            display = '';
                                          });
                                          _refresh();
                                        }
                                      }
                                    }
                                    else {
                                      Constants.showError(context, 'Enter an amount of N1,000 or more');
                                    }
                                  },
                                  child: Container(
                                    width: SizeConfig.screenWidth,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      color: Color(0XFF089A54),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Cash Out',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Bold",
                                          color: Color(0xFFFFFFFF),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              /*Container(
                                width: (SizeConfig.screenWidth - 42) / 2,
                                child: GestureDetector(
                                  onTap: () async {
                                    if (display.length > 0 && double.parse(display) > 9.0) {
                                      if (double.parse(display) > _balance) {
                                        Constants.showError(context, 'Insufficient funds, top up your wallet');
                                        var message = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TopUp(
                                              amount: display,
                                            ),
                                          ),
                                        );
                                        if (message != null && message) {
                                          setState(() {
                                            display = '';
                                          });
                                          _refresh();
                                        }
                                      } else {
                                        var message = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Transfer(
                                              amount: display,
                                            ),
                                          ),
                                        );
                                        if (message != null && message) {
                                          setState(() {
                                            display = '';
                                          });
                                          _refresh();
                                        }
                                      }
                                    } else {
                                      Constants.showError(context, 'Enter an amount of N10 or more');
                                    }
                                  },
                                  child: Container(
                                    width: SizeConfig.screenWidth,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      color: Color(0XFF089A54),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Transfer',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Bold",
                                          color: Color(0xFFFFFFFF),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),*/
                            ],
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: (SizeConfig.screenWidth! - 42) / 2,
                            child: GestureDetector(
                              onTap: () async {
                                HapticFeedback.mediumImpact();
                                if (display.length > 0 &&  double.parse(display) >= 1000) {
                                  /*var message = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TopUp(
                                        amount: display,
                                      ),
                                    ),
                                  );
                                  if (message != null && message) {
                                    setState(() {
                                      display = '';
                                    });
                                    _refresh();
                                  }*/
                                  _initializePayment(double.parse(display) * 100);
                                } else {
                                  Constants.showError(context, 'Enter an amount of N1000 or more');
                                }
                              },
                              child: Container(
                                width: SizeConfig.screenWidth,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  color: Color(0XFF089A54),
                                ),
                                child: Center(
                                  child: !_state
                                      ? Text(
                                    'Top Up Wallet',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Bold",
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  )
                                      : SizedBox(
                                    child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF))
                                    ),
                                    height: 20.0,
                                    width: 20.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          /*Container(
                            width: (SizeConfig.screenWidth - 42) / 2,
                            child: GestureDetector(
                              onTap: () async {
                                if (display.length > 0 && double.parse(display) > 9.0) {
                                  if (double.parse(display) > _balance) {
                                    Constants.showError(context, 'Insufficient funds');
                                  } else {
                                    var message = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CashOut(
                                          amount: display,
                                        ),
                                      ),
                                    );
                                    if (message != null && message) {
                                      setState(() {
                                        display = '';
                                      });
                                      _refresh();
                                    }
                                  }
                                } else {
                                  Constants.showError(context, 'Enter an amount of N10 or more');
                                }
                              },
                              child: Container(
                                width: SizeConfig.screenWidth,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  color: Color(0XFF089A54),
                                ),
                                child: Center(
                                  child: Text(
                                    'Cash Out',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Bold",
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Function to show full modal of transaction history
  Future<void> historyModalSheet(context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight! - 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  color: Color(0XFFF8F8FF),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Transform.translate(
                        offset: Offset(5, 21),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              size: 22,
                              color: Color(0XFF09AB5D),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Transaction History',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF060D25),
                          fontSize: 18,
                          fontFamily: "Regular",
                        ),
                      ),
                      SizedBox(height: 25),
                      Expanded(
                        child: _buildList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }

  /// A function to return the time difference from transaction date [time]
  /// till now
  String _getTimeDifference(DateTime time){
    if(DateTime.now().difference(time).inSeconds < 60 && DateTime.now().difference(time).inSeconds > 1){
      if(DateTime.now().difference(time).inSeconds > 1){
        return '${DateTime.now().difference(time).inSeconds} secs ago';
      } else {
        return '${DateTime.now().difference(time).inSeconds} sec ago';
      }
    }
    else if(DateTime.now().difference(time).inMinutes < 60 && DateTime.now().difference(time).inMinutes > 1){
      if(DateTime.now().difference(time).inMinutes > 1){
        return '${DateTime.now().difference(time).inMinutes} mins ago';
      } else {
        return '${DateTime.now().difference(time).inMinutes} min ago';
      }
    }
    else if(DateTime.now().difference(time).inHours < 24 && DateTime.now().difference(time).inHours > 1){
      if(DateTime.now().difference(time).inHours > 1){
        return '${DateTime.now().difference(time).inHours} hrs ago';
      } else {
        return '${DateTime.now().difference(time).inHours} hr ago';
      }
    }
    else {
      if(DateTime.now().difference(time).inDays > 1){
        return '${DateTime.now().difference(time).inDays} days ago';
      } else {
        return '${DateTime.now().difference(time).inDays} day ago';
      }
    }
  }

  /// Function that initializes payment by calling
  /// [initializePayment] in the [RestDataSource] class
  void _initializePayment(double amount) async {
    if(!mounted)return;
    setState(() { _state = true; });
    var api = RestDataSource();
    await api.initializePayment(amount).then((value) {
      if(!mounted)return;
      setState(() { _state = true; });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaystackView(
              authorizationUrl: value['authorization_url']
          ),
        ),
      ).then((val) {
        if(val == 'success'){
          if(!mounted)return;
          setState(() { _state = true; });
          _verifyPayment(value['reference']);
        }
        else {
          if(!mounted)return;
          setState(() { _state = false; });
        }
      });
    }).catchError((error) {
      if(!mounted)return;
      setState(() { _state = false; });
      if(!mounted)return;
      Constants.showError(context, error);
    });
  }

  /// Function that verifies payment by calling
  /// [verifyPayment] in the [RestDataSource] class
  void _verifyPayment(String reference) async {
    var api = RestDataSource();
    await api.verifyPayment(reference).then((value) async {
      if(!mounted)return;
      setState(() { _state = true; });
      var topUp = WalletTopup();
      topUp.amount = display;
      topUp.paymentReference = value["reference"];
      topUp.paymentStatus = value["status"];
      topUp.gatewayResponse = value["gateway_response"];
      _postTopUp(topUp);
    }).catchError((error) {
      if(!mounted)return;
      setState(() { _state = false; });
      if(!mounted)return;
      Constants.showError(context, error);
    });
  }

  /// Function that posts the wallet topup details by calling
  /// [walletTopUp] in the [RestDataSource] class
  void _postTopUp(WalletTopup topUp) async {
    var api = RestDataSource();
    await api.walletTopUp(topUp).then((value) async {
      if(!mounted)return;
      setState(() {
        _state = false;
        display = '';
      });
      _showAlert(true, "Top up wallet successful");
    }).catchError((err){
      if(!mounted)return;
      setState(() { _state = false; });
      print(err);
      _showAlert(false, err.toString());
    });
  }

  void _showAlert(bool success, String message){
    Alert(
      context: context,
      type: success ? AlertType.success : AlertType.error,
      title: success ? "Success" : "Failed",
      desc: message,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          color: success ? Color(0xFF1FD47D) : Colors.red,
          onPressed: () {
            if(success){
              Navigator.pop(context);
              _refresh();
            } else {
              Navigator.pop(context);
            }
          },
          width: 120,
        )
      ],
    ).show();

  }

}
