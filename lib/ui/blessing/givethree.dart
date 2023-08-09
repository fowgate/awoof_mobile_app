import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/model/create-giveaway.dart';
import 'package:awoof_app/networking/rest-data.dart';
import 'package:awoof_app/ui/blessing/giveaway-successful.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'paystack-webview.dart';
import 'package:awoof_app/utils/rflutter_alert-2.0.4/lib/rflutter_alert.dart';
import 'package:awoof_app/ui/bottom-navs/home/home.dart';


class GiveThree extends StatefulWidget {

  static const String id = 'give_three_page';

  final CreateGiveaway giveaway;

  final dynamic image;

  const GiveThree({
    Key? key,
    required this.giveaway,
    required this.image
  }) : super(key: key);

  @override
  _GiveThreeState createState() => _GiveThreeState();
}

class _GiveThreeState extends State<GiveThree> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// Variable to hold the paystack public key
  var publicKey = 'pk_live_f2db20f827f2de9c8646547ee71da0f51fa88483';

  /// A List of String variable to hold the giveaway conditions
  List<String> _conditions = [];

  /// A List of Widget to hold the giveaway conditions
  List<Widget> _myConditions = [];

  String payWith = 'wallet';

  int _state = 0;

  String _userId = '';

  String _userEmail = '';

  String? _userImage;

  String _fullName = '';

  double _transferPercent = 2.0;

  double _transferFee = 0.0;

  double _platformPercent = 2.0;

  double _platformFee = 0.0;

  double _totalAmount = 0.0;

  double _balance = 0.0;

  bool _paid = false;

  /// Converting [dateTime] in string format to return a formatted time
  /// of hrs, minutes and am/pm
  String _getFormattedTime() {
    return DateFormat('d, MMMM').format(DateTime.now()).toString();
  }
  
  /// Setting the current user's email to [_userEmail], id to [_userId] and
  /// balance to [_balance]
  void _getCurrentUser() async {
    await futureValue.updateUser();
    await futureValue.getCurrentUser().then((user) {
      if(!mounted)return;
      setState(() {
        _fullName = '${user!.firstName} ${user.lastName}';
        _userImage = user.image;
        _userId = user.id!;
        _userEmail = user.email!;
        _balance = double.parse(user.balance!);
      });
    }).catchError((Object e) {
      print(e.toString());
    });
  }

  void payModalSheet(context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(builder: (context, setModalState) {
            return Material(
              type: MaterialType.transparency,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  color: Color(0XFFF8F8FF),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: SingleChildScrollView(
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
                          'How would you like to pay?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF060D25),
                            fontSize: 18,
                            fontFamily: "Regular",
                          ),
                        ),
                        SizedBox(height: 25),
                        GestureDetector(
                          onTap: () {
                            setModalState(() {
                              payWith = 'wallet';
                            });
                          },
                          child: Opacity(
                            opacity: payWith == 'wallet' ? 1 : 0.5,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(9),
                                ),
                                border: Border.all(
                                  color: (payWith == 'wallet')
                                      ? Color(0XFF02CF6D)
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(25, 54, 205, 0.05),
                                    offset: Offset(0, 8),
                                    blurRadius: 20,
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Awoof Pay',
                                          style: TextStyle(
                                            color: Color(0XFF060D25),
                                            fontSize: 14,
                                            fontFamily: 'Regular',
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          '${Constants.money(_balance, 'N')}',
                                          style: TextStyle(
                                            color: Color(0XFF060D25),
                                            fontSize: 19,
                                            fontFamily: 'Regular',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: 22,
                                        maxHeight: 22,
                                      ),
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            5,
                                          ),
                                        ),
                                        color: Color(0xFFEFF5E8),
                                      ),
                                      child: Center(
                                        child: Container(
                                          width: 14,
                                          height: 14,
                                          child: Image.asset(
                                            'assets/images/wallet-active.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        GestureDetector(
                          onTap: () {
                            setModalState(() {
                              payWith = 'card';
                            });
                          },
                          child: Opacity(
                            opacity: payWith == 'card' ? 1 : 0.5,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(9),
                                ),
                                border: Border.all(
                                  color: (payWith == 'card')
                                      ? Color(0XFF02CF6D)
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(25, 54, 205, 0.05),
                                    offset: Offset(0, 8),
                                    blurRadius: 20,
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Paystack Payment',
                                          style: TextStyle(
                                            color: Color(0XFF060D25),
                                            fontSize: 14,
                                            fontFamily: 'Regular',
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          'Via Paystack',
                                          style: TextStyle(
                                            color: Color(0XFF060D25),
                                            fontSize: 19,
                                            fontFamily: 'Regular',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Image.asset(
                                      'assets/images/paystack.png',
                                      width: 22,
                                      height: 22,
                                      fit: BoxFit.contain,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          width: SizeConfig.screenWidth! - 40,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              if(_state == 3){
                                if(!mounted)return;
                                setModalState(() { _state = 1; });
                                _postGiveAway(widget.giveaway, setModalState);
                              }
                              else if(payWith == 'wallet' && _balance < _totalAmount){
                                Constants.showError(context, "Insufficient funds");
                              }
                              else if(payWith == 'wallet' && _balance >= _totalAmount){
                                if(!mounted)return;
                                setModalState(() { _state = 1; });
                                _deductBalance(_totalAmount, setModalState);
                              }
                              else if (payWith == 'card'){
                                if(!mounted)return;
                                setModalState(() { _state = 1; });
                                _initializePayment(_totalAmount * 100, setModalState);
                                // _initializePayment(200.00 * 100, setModalState);
                                //_verifyPayment('rgtdewx9wk');
                              }
                            },
                            child: _setUpButton(),
                            //color: Color(0xFF1FD47D),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 22,
                              height: 22,
                              child: Image.asset(
                                'assets/images/secure.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'We use 256 bit encryption to encrypt your data',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Regular",
                                color: Color(0XFFB3B9C6),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  void _calculateFees(){
    if(!mounted)return;
    setState(() {
      _transferFee = (_transferPercent / 100) * double.parse(widget.giveaway.amount!);
      _platformFee = (_platformPercent / 100) * double.parse(widget.giveaway.amount!);
      _totalAmount = /*_transferFee + _platformFee +*/ double.parse(widget.giveaway.amount!);
    });
  }

  @override
  void initState() {
    super.initState();
    _calculateFees();
    if(widget.giveaway.isAnonymous == false){
      _getConditions();
    }
    _getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setModalState) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xFF09AB5D),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color(0XFF09AB5D),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: Center(
              child: Text(
                '03 of 03',
                style: TextStyle(
                  color: Color(0XFF8BD7B2),
                  fontSize: 13,
                  fontFamily: 'Regular',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 15),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Review & Pay',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 28,
                      fontFamily: "Regular",
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  height: 35,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  child: Text(
                    'Payment Distribution',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 17,
                      fontFamily: "Regular",
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Giveaway Amount',
                          style: TextStyle(
                            color: Color(0XFF84D5AE),
                            fontSize: 14,
                            fontFamily: 'Regular',
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          '${Constants.money(double.parse(widget.giveaway.amount!), 'N')}',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 22,
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Transfer Fee (2%)',
                          style: TextStyle(
                            color: Color(0XFF84D5AE),
                            fontSize: 14,
                            fontFamily: 'Regular',
                          ),
                        ),
                        SizedBox(height: 3),
                        Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${Constants.money(_transferFee, 'N')}',
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 22,
                                  fontFamily: 'Regular',
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.red,
                                  decorationThickness: 2
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                margin: EdgeInsets.only(bottom: 2),
                                child: Text(
                                  'FREE',
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 12,
                                    fontFamily: 'Regular',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Expires In',
                          style: TextStyle(
                            color: Color(0XFF84D5AE),
                            fontSize: 14,
                            fontFamily: 'Regular',
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          widget.giveaway.expiry!.toUpperCase(),
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 19,
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'No. of Winners',
                          style: TextStyle(
                            color: Color(0XFF84D5AE),
                            fontSize: 14,
                            fontFamily: 'Regular',
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          '${widget.giveaway.numberOfWinners}',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 22,
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Other Fees & Taxes (2%)',
                          style: TextStyle(
                            color: Color(0XFF84D5AE),
                            fontSize: 14,
                            fontFamily: 'Regular',
                          ),
                        ),
                        SizedBox(height: 3),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${Constants.money(_platformFee, 'N')}',
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 22,
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.red,
                                decorationThickness: 2
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              margin: EdgeInsets.only(bottom: 2),
                              child: Text(
                                'FREE',
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 12,
                                  fontFamily: 'Regular',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Show Identity',
                          style: TextStyle(
                            color: Color(0XFF84D5AE),
                            fontSize: 14,
                            fontFamily: 'Regular',
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          widget.giveaway.isAnonymous! ? 'No' : 'Yes',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 19,
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  height: 60,
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Total Amount',
                        style: TextStyle(
                            color: Color(0XFF84D5AE),
                          fontSize: 14,
                          fontFamily: 'Regular',
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '${Constants.money(_totalAmount, 'N')}',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 22,
                          fontFamily: 'Regular',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                widget.giveaway.isAnonymous!
                    ? Container()
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _myConditions,
                ),
                Material(
                  elevation: 10,
                  shadowColor: Color(0xFF09AB5D),
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  child: Container(
                    width: SizeConfig.screenWidth! < 360
                        ? SizeConfig.screenWidth! * 0.85
                        : 306,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 17, 15, 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        widget.giveaway.isAnonymous!
                                            ? "Anonymous Giver"
                                            : _fullName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Regular',
                                          fontWeight: FontWeight.w600,
                                          color: Color(0XFF001431),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(7),
                                          ),
                                          color: Color(0XFF09AB5D),
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          size: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    width: SizeConfig.screenWidth! < 360
                                        ? SizeConfig.screenWidth! * 0.5
                                        : 180,
                                    child: Text(
                                      widget.giveaway.message!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Regular',
                                        color: Color(0XFF676767),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: (_userImage != null && !widget.giveaway.isAnonymous!)
                                      ? CachedNetworkImage(
                                    imageUrl: _userImage!,
                                    fit: BoxFit.contain,
                                    errorWidget: (context, url, error) => Container(color: Color(0xFFE8E8E8)),
                                  )
                                      : Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 25,
                                      color: Color(0xFFBDBDBD),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: SizeConfig.screenWidth! * 0.85,
                          height: SizeConfig.screenWidth! * 0.5,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFE8E8E8), width: 1),
                          ),
                          child: widget.image != null
                              ? Image.file(
                            widget.image,
                            width: SizeConfig.screenWidth! * 0.85,
                            height: SizeConfig.screenWidth! * 0.5,
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                          )
                              : Image.asset(
                            'assets/images/default-image.jpeg',
                            width: SizeConfig.screenWidth! * 0.85,
                            height: SizeConfig.screenWidth! * 0.5,
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            color: Color(0xFF09AB5D),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/images/cash-white.png',
                                      width: 18,
                                      height: 18,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'AMOUNT',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontFamily: 'Regular',
                                        color: Color(0XFF75CFA4),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      Constants.money(double.parse(widget.giveaway.amount!), 'N'),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Bold',
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.schedule,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'EXPIRES IN',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontFamily: 'Regular',
                                        color: Color(0XFF75CFA4),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      widget.giveaway.expiry != null
                                          ? widget.giveaway.expiry!.toUpperCase()
                                          : '3 DAYS',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Bold',
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.history,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'POST DATE',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontFamily: 'Regular',
                                        color: Color(0XFF75CFA4),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      _getFormattedTime(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Bold',
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 35),
                Container(
                  width: SizeConfig.screenWidth,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                       String msg= "Thank you for submitting a Giveaway in Awoof. Please kindly check your email for next steps. Please check your spam if you don't find the mail in your inbox.";
                      //payModalSheet(context);
                     if(!mounted)return;
                      setModalState(() { _state = 1; });
                      _postGiveAway(widget.giveaway, setModalState);
                      _showAlert(true, msg);
                    },
                    child: Text(
                      _state == 3 ? 'Post Giveaway' : 'Proceed to Submit Giveaway',
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: "Bold",
                        color: Color(0xFF1FD47D),
                      ),
                    ),
                   // color: Colors.white,
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
    });
  }

  /// Function to set up button states in sync with [_state]
  Widget _setUpButton(){
    if(_state == 0){
      return Text(
        'Pay Securely',
        style: TextStyle(
          fontSize: 17,
          fontFamily: "Bold",
          color: Colors.white,
        ),
      );
    }
    else if(_state == 1){
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
    else if(_state == 2){
      return Text(
        'Validating ...',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 17,
          fontFamily: "Regular",
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
    }
    else if(_state == 3){
      return Text(
        'Post Giveaway',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 17,
          fontFamily: "Regular",
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
    }
    else {
      return Icon(
        Icons.check,
        color: Colors.white,
        size: 20,
      );
    }
  }

  void _getConditions(){
    if(widget.giveaway.likePostOnFacebook!){
      _conditions.add('Like my post on Facebook');
    }
    if(widget.giveaway.likeFacebook!){
      _conditions.add('Follow ${widget.giveaway.followPageOnFacebook} on Facebook');
    }
    if(widget.giveaway.likeTweet!){
      _conditions.add('Like and retweet my new tweet on Twitter');
    }
    if(widget.giveaway.followTwitter!){
      _conditions.add('Follow ${widget.giveaway.followTwitterLink} on Twitter');
    }
    if(widget.giveaway.likeInstagram!){
      _conditions.add('Like and comment to my new post on Instagram');
    }
    if(widget.giveaway.followInstagram!){
      _conditions.add('Follow ${widget.giveaway.followInstagramLink} on Instagram');
    }
    _getConditionWidget();
  }

  void _getConditionWidget(){
    _myConditions.add(
      Text(
        'Review Giveaway Post',
        style: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 17,
          fontFamily: 'Regular',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    _myConditions.add(
      SizedBox(height: 12),
    );
    if(_conditions.length != 0){
      for (int i = 0; i < _conditions.length; i++){
        _myConditions.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _conditions[i],
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 14,
                    fontFamily: 'Regular',
                  ),
                ),
                SizedBox(height: 12,),
              ],
            )
        );
      }
    } else {
      _myConditions.add(Container());
    }

  }

  /// Function that posts the wallet topup details by calling
  /// [deductBalance] in the [RestDataSource] class
  void _deductBalance(double amount, StateSetter setModalState) async {
    var api = RestDataSource();
    await api.deductBalance(_userId ,amount.toString()).then((value) async {
      await futureValue.updateUser();
      widget.giveaway.paymentType = 'Wallet';
      widget.giveaway.paymentStatus = 'success';
      widget.giveaway.gatewayResponse = 'Approved By Awoof Wallet';
      _postGiveAway(widget.giveaway, setModalState);
    }).catchError((err){
      if(!mounted)return;
      setModalState(() {
        _state = 0;
      });
      print(err);
      Constants.showError(context, err);
    });

  }

  /// Function that initializes payment by calling
  /// [initializePayment] in the [RestDataSource] class
  void _initializePayment(double amount, StateSetter setModalState) async {
    var api = RestDataSource();
    await api.initializePayment(amount).then((value) {
      // _checkOut(value['access_code'], amount);
      if(!mounted)return;
      setModalState(() { _state = 0; });
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
          setModalState(() {
            _state = 1;
          });
          _verifyPayment(value['reference'], setModalState);
        }
        else {
          if(!mounted)return;
          setModalState(() { _state = 0; });
        }
      });
    }).catchError((error) {
      if(!mounted)return;
      setModalState(() {
        _state = 0;
      });
      if(!mounted)return;
      Constants.showError(context, error);
    });
  }

  void _sendMail(){
  var api = RestDataSource();
  api.giveawayPay('12345x')
  .catchError((err){
    if(!mounted)return;
    Constants.showError(context, 'err');
  });
    
  }

  /// Function to show alert popup either success or failed
  void _showAlert(bool success, String message){
    Alert(
      context: context,
      type: success ? AlertType.success : AlertType.error,
      title: success ? "Success" : "Failed",
      desc: message,
      buttons: [
        DialogButton(
          child: Text(
            "Continue to dashboard",
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
          color: success ? Color.fromARGB(255, 84, 135, 245) : Colors.red,
          onPressed: () {
             Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const Home(),
                      ),
                    );
          },
          width: 200,
        )
      ],
    ).show();


  }

  /// Function to make payments and check out using paystack plugin
  /*void _checkOut(String accessCode, double amount, StateSetter setModalState) async {
    try {
      Charge charge = Charge()
        ..amount = amount.round()
        ..accessCode = accessCode
        ..email = _userEmail;
      CheckoutResponse response = await PaystackPlugin.checkout(
        context,
        charge: charge,
        method: CheckoutMethod.selectable,
      );
      if (response.status == true) {
        _verifyPayment(response.reference, setModalState);
      }
      else {
        if(!mounted)return;
        setModalState(() {
          _state = 0;
        });
        Constants.showError(context, response.message);
      }
    } catch (e) {
      print(e);
      if(!mounted)return;
      setModalState(() {
        _state = 0;
      });
      Constants.showError(context, e);
    }
  }*/

   /// Function that verifies payment by calling
  /// [verifyPayment] in the [RestDataSource] class
  void _saveGiveaway( StateSetter setModalState) async {
      widget.giveaway.paymentType = 'pending';
      widget.giveaway.paymentStatus = 'pending';
      widget.giveaway.paymentReference = 'pending';
      widget.giveaway.gatewayResponse = 'Submitted by user';
      await _postGiveAway(widget.giveaway, setModalState);
  }


  /// Function that verifies payment by calling
  /// [verifyPayment] in the [RestDataSource] class
  void _verifyPayment(String reference, StateSetter setModalState) async {
    var api = RestDataSource();
    await api.verifyPayment(reference).then((value) async {
      if(!mounted)return;
      setModalState(() {
        _state = 2;
      });
      widget.giveaway.paymentType = 'Paystack';
      widget.giveaway.paymentStatus = 'success';
      widget.giveaway.paymentReference = reference;
      widget.giveaway.gatewayResponse = 'Approved By Financial Institution';
      await _postGiveAway(widget.giveaway, setModalState);
    }).catchError((error) {
      if(!mounted)return;
      setModalState(() {
        _state = 0;
      });
      if(!mounted)return;
      Constants.showError(context, error);
    });
  }

  /// A function that returns string for our pasytack reference
  String _getReference() {
    return 'T${DateTime.now().millisecondsSinceEpoch}';
  }

  /*/// Function to make payments and check out using paystack plugin
  void _checkOut(double amount) async {
    try {
      Charge charge = Charge()
        ..amount = (amount * 100).round()
        ..reference = _getReference()
        ..email = _userEmail;
      CheckoutResponse response = await PaystackPlugin.checkout(
        context,
        charge: charge,
        method: CheckoutMethod.card,
      );
      if (response.status == true) {
        widget.giveaway.paymentType = 'Paystack';
        widget.giveaway.paymentStatus = 'success';
        widget.giveaway.paymentReference = response.reference;
        widget.giveaway.gatewayResponse = 'Approved By Financial Institution';
        _postGiveAway(widget.giveaway);
      } else {
        if(!mounted)return;
        setState(() {
          _state = 0;
        });
        Constants.showNormalMessage(response.message);
      }
    } catch (e) {
      print(e);
      if(!mounted)return;
      setState(() {
        _state = 0;
      });
      Constants.showNormalMessage(e);
    }
  }*/

  /// Function that posts the giveaway details by calling
  /// [postGiveaway] in the [RestDataSource] class
  Future<void> _postGiveAway(CreateGiveaway giveaway, StateSetter setModalState) async {
    var api = RestDataSource();
    await api.postGiveaway(giveaway).then((value) async {
      if(!mounted)return;
      setModalState(() { _state = 5; });
      //Navigator.pushReplacementNamed(context, GiveawaySuccessful.id);
    }).catchError((e){
      print(e);
      setModalState(() { _state = 3; });
      Constants.showError(context, 'An error occurred, please go back and try again');
    });
  }

}
