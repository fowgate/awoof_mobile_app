import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/model/payment-card.dart';
import 'package:awoof_app/model/wallet-topup.dart';
import 'package:awoof_app/networking/rest-data.dart';
import 'package:awoof_app/utils/card-input-formatter.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/payment-card-utils.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:awoof_app/utils/rflutter_alert-2.0.4/lib/rflutter_alert.dart';
//import 'package:rflutter_alert/rflutter_alert.dart';

class TopUp extends StatefulWidget {

  final String? amount;

  TopUp({this.amount});

  @override
  _TopUpState createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A double variable to hold the wallet balance
  double _balance = 0;

  /// Variable to hold the paystack public key
  var publicKey = 'pk_live_f2db20f827f2de9c8646547ee71da0f51fa88483';

  /// A [GlobalKey] to hold the form state of my form widget for form validation
  var _formKey = GlobalKey<FormState>();

  /// A [TextEditingController] to control the input text for the card number
  var numberController = TextEditingController();

  /// Instantiating a class of the [MyPaymentCard]
  var _paymentCard = MyPaymentCard();

  /// Boolean variable holding the auto validate
  var autoValidate = false;

  /// String variable holding the encrypted card number
  String? _encryptedNumber;

  /// An integer value holding the state of the button
  int _state = 0;

  /// Variable to hold the email of the user logged in
  String? _userEmail;

  String tabSelected = 'bank';

  var f = new NumberFormat("#,###.##", "en_US");

  /// Setting the current user's email, id and account balance to
  /// [_userEmail], [_userId], [_balance]
  void _getCurrentUser() async {
    await futureValue.updateUser();
    await futureValue.getCurrentUser().then((user) {
      if(!mounted)return;
      setState(() {
        _userEmail = user!.email;
        _balance = double.parse(user.balance!);
      });
    }).catchError((Object error) {
      print(error);
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _paymentCard.type = MyCardType.Others;
    numberController.addListener(_getCardTypeFrmNumber);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            size: 22,
            color: Color(0XFFA0A0A0),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'N${f.format(double.parse(widget.amount!))}',
          style: TextStyle(
            fontSize: 18,
            fontFamily: "Bold",
            color: Color(0xFF808998),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Container(
                width: SizeConfig.screenWidth,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(3),
                  ),
                  border: Border.all(
                    width: 1,
                    color: Color(0XFFB9B9B9),
                  ),
                  color: Color(0XFFF3F3F3),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
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
                            child: Icon(
                              Icons.credit_card,
                              color: Color(0xFF1FD47D),
                              size: 14,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Current Balance: ',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: "Regular",
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7A8392),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'N${f.format(_balance)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Bold",
                          color: Color(0xFF7A8392),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
//                Row(
//                  children: <Widget>[
//                    GestureDetector(
//                      onTap: () {
//                        setState(() {
//                          tabSelected = 'bank';
//                        });
//                      },
//                      child: Container(
//                        width: (MediaQuery.of(context).size.width - 40) / 2,
//                        height: 45,
//                        decoration: BoxDecoration(
//                          border: Border(
//                            bottom: BorderSide(
//                              width: 2,
//                              color: (tabSelected == 'bank')
//                                  ? Color(0XFFDDDDDD)
//                                  : Color(0XFFEDEDED),
//                            ),
//                          ),
//                        ),
//                        child: Center(
//                          child: Text(
//                            'New Card',
//                            style: TextStyle(
//                              fontSize: 15,
//                              fontWeight: (tabSelected == 'bank')
//                                  ? FontWeight.bold
//                                  : FontWeight.normal,
//                              fontFamily: 'Regular',
//                              color: Color(0XFF808998),
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                    GestureDetector(
//                      onTap: () {
//                        setState(() {
//                          tabSelected = 'philantro';
//                        });
//                      },
//                      child: Container(
//                        width: (MediaQuery.of(context).size.width - 40) / 2,
//                        height: 45,
//                        decoration: BoxDecoration(
//                          border: Border(
//                            bottom: BorderSide(
//                              width: 2,
//                              color: (tabSelected == 'philantro')
//                                  ? Color(0XFFDDDDDD)
//                                  : Color(0XFFEDEDED),
//                            ),
//                          ),
//                        ),
//                        child: Center(
//                          child: Text(
//                            'Select Card',
//                            style: TextStyle(
//                              fontSize: 15,
//                              fontWeight: (tabSelected == 'philantro')
//                                  ? FontWeight.bold
//                                  : FontWeight.normal,
//                              fontFamily: 'Regular',
//                              color: Color(0XFF808998),
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//                SizedBox(height: 20),
              _buildPaymentForm(),
//                Transform.translate(
//                  offset: Offset(-10, 0),
//                  child: Row(
//                    children: <Widget>[
//                      IconButton(
//                        icon: (saveCard == true)
//                            ? Icon(
//                                Icons.check_box_outline_blank,
//                              )
//                            : Icon(
//                                Icons.check_box,
//                              ),
//                        onPressed: () {
//                          setState(() {
//                            saveCard = !saveCard;
//                          });
//                        },
//                      ),
//                      Text(
//                        'Save Card',
//                        style: TextStyle(
//                          color: Color(0xff707988),
//                          fontSize: 14,
//                          fontFamily: "Regular",
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
              SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF1FD47D),
                  onPrimary: Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(4)
                    ),
                  )
                ),
                onPressed: () async {
                  if(_state == 0){
                    _validateInputs();
                  }
                },
                child: Container(
                  width: SizeConfig.screenWidth,
                  height: 60,
                  child: Center(
                    child: _setUpButton(),
                  ),
                ),
              ),
              SizedBox(height: 19),
              Container(
                width: SizeConfig.screenWidth,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 22,
                      height: 22,
                      margin: EdgeInsets.only(right: 5.0),
                      child: Image.asset(
                        'assets/images/secure.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth! - 67,
                      alignment: Alignment.center,
                      child: Text(
                        'Powered by Paystack and secured by AWS cryptography',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Regular",
                          color: Color(0XFFB3B9C6),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentForm(){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: TextFormField(
              style: TextStyle(
                color: Color(0xff707988),
                fontSize: 16,
                fontFamily: "Regular",
              ),
              keyboardType: TextInputType.numberWithOptions(),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(19),
                CardNumberInputFormatter()
              ],
              controller: numberController,
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Card Number',
                hintStyle: TextStyle(
                  color: Color(0xff808998),
                  fontSize: 16,
                  fontFamily: "Regular",
                ),
                prefixIcon: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
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
                        child: Icon(
                          Icons.credit_card,
                          color: Color(0xFF1FD47D),
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                suffixIcon: CardUtils.getCardIcon(_paymentCard.type!),
              ),
              onSaved: (String? value) {
                print('onSaved = $value');
                print('Num controller has = ${numberController.text}');
                _paymentCard.number = CardUtils.getCleanedNumber(value!);
              },
              validator: CardUtils.validateCardNum,
            ),
          ),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: (MediaQuery.of(context).size.width - 55) / 2,
                child: TextFormField(
                  style: TextStyle(
                    color: Color(0xff707988),
                    fontSize: 16,
                    fontFamily: "Regular",
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                    CardMonthInputFormatter()
                  ],
                  validator: CardUtils.validateDate,
                  onSaved: (value) {
                    List<int> expiryDate = CardUtils.getExpiryDate(value!);
                    _paymentCard.expiryMonth = expiryDate[0];
                    _paymentCard.expiryYear = expiryDate[1];
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'MM/YY',
                    hintStyle: TextStyle(
                      color: Color(0xff808998),
                      fontSize: 16,
                      fontFamily: "Regular",
                    ),
                    prefixIcon: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
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
                            child: Icon(
                              Icons.date_range,
                              color: Color(0xFF1FD47D),
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width - 55) / 2,
                child: TextFormField(
                  style: TextStyle(
                    color: Color(0xff707988),
                    fontSize: 16,
                    fontFamily: "Regular",
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'CVV',
                    hintStyle: TextStyle(
                      color: Color(0xff808998),
                      fontSize: 16,
                      fontFamily: "Regular",
                    ),
                    prefixIcon: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
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
                                  'assets/images/zap.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  validator: CardUtils.validateCVV,
                  onSaved: (value) {
                    _paymentCard.cvc = int.parse(value!);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 15.0),
        ],
      ),
    );
  }

  /// Function to set up button states in sync with [_state]
  Widget _setUpButton(){
    if(_state == 0){
      return Text(
        'Add N${f.format(double.parse(widget.amount!))} to Wallet',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 17,
          fontFamily: "Regular",
          fontWeight: FontWeight.w600,
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
    else {
      return Icon(
        Icons.check,
        color: Colors.white,
        size: 20,
      );
    }
  }

  @override
  void dispose() {
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    super.dispose();
  }

  /// Function to get card type from number in order to show the appropriate card
  /// type image
  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    MyCardType cardType = CardUtils.getCardTypeFrmNumber(input);
    if(!mounted)return;
    setState(() {
      this._paymentCard.type = cardType;
    });
  }

  /// Function to validate the inputs from our form with the [_formKey]
  void _validateInputs() {
    final FormState form = _formKey.currentState!;
    if (!_formKey.currentState!.validate()) {
      if(!mounted)return;
      setState(() {
        autoValidate = true; // Start validating on every change.
      });
      return null;
    } else {
      form.save();
      String cleanedNum = CardUtils.getCleanedNumber(_paymentCard.number!);
      if(!mounted)return;
      setState(() {
        _encryptedNumber = '**** **** **** *${cleanedNum.substring(cleanedNum.length - 3)}';
      });
      if(!mounted)return;
      setState(() {
        _state = 1;
      });
      //_chargeCard();
    }
  }

  /// Function that initializes payment by calling
  /// [initializePayment] in the [RestDataSource] class
  /*void _initializePayment(double amount) async {
    var api = RestDataSource();
    await api.initializePayment(amount).then((value) {
      //_chargeCard();
    }).catchError((error) {
      if(!mounted)return;
      setState(() {
        _state = 0;
      });
      Constants.showNormalMessage(error);
    });
  }*/

  /// A function that returns string for our pasytack reference
  String _getReference() {
    return 'T${DateTime.now().millisecondsSinceEpoch}';
  }

  /*/// Function that verifies payment by calling
  /// [verifyPayment] in the [RestDataSource] class
  void _verifyPayment(String reference) async {
    var api = RestDataSource();
    await api.verifyPayment(reference).then((value) {
      if(!mounted)return;
      setState(() {
        _state = 2;
      });
      var topUp = WalletTopup();
      topUp.amount = widget.amount;
      topUp.paymentReference = value["reference"];
      topUp.paymentStatus = value["status"];
      topUp.gatewayResponse = value["gateway_response"];
      _postTopUp(topUp);
    }).catchError((error) {
      if(!mounted)return;
      setState(() {
        _state = 0;
      });
      Constants.showNormalMessage(error);
    });
  }*/

  /// Function that posts the wallet topup details by calling
  /// [walletTopUp] in the [RestDataSource] class
  void _postTopUp(WalletTopup topUp) async {
    var api = RestDataSource();
    await api.walletTopUp(topUp).then((value) async {
      await futureValue.updateUser();
      if(!mounted)return;
      setState(() {
        _state = 3;
      });
      _showAlert(true, "Top up wallet successful");
    }).catchError((err){
      if(!mounted)return;
      setState(() {
        _state = 0;
      });
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
              Navigator.pop(context);
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