import 'dart:io';
import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/bloc/select-suggestions.dart';
import 'package:awoof_app/networking/rest-data.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/location-permission.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:in_app_review/in_app_review.dart';
//import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:awoof_app/utils/rflutter_alert-2.0.4/lib/rflutter_alert.dart';
import 'package:awoof_app/model/banks.dart';
import 'package:awoof_app/model/nigerian-banks.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:awoof_app/ui/bottom-navs/pay/wallet.dart';

class CashOut extends StatefulWidget {

  final String amount;

  const CashOut({
    Key? key,
    required this.amount
  }) : super(key: key);


  @override
  _CashOutState createState() => _CashOutState();
}

class _CashOutState extends State<CashOut> {

  /// A [GlobalKey] to hold the form state of my form widget for bank transfer form validation
  final _bankFormKey = GlobalKey<FormState>();

  /// A boolean variable to hold the [inAsyncCall] value in my
  /// [ModalProgressHUD] widget
  bool _showSpinner = false;

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A [TextEditingController] to control the input text for the pin
  TextEditingController _pinController = TextEditingController();

  /// String variable to hold the selected bank in the drop down
  String? _selectedBank;

  /// A Map to hold the names of all the banks to its bank codes in the database
  Map<String, String> _allBanks = Map();

  /// A List to hold the model of all the my banks in the database
  List<NigerianBanks> _myBanks = [];

  /// A List to hold the names of all the nigerian banks in the database
  List<String> _allMyBankNames = [];

  /// A [TextEditingController] to control the input text for the bank name
  TextEditingController _bankNameController = TextEditingController();

  /// A [TextEditingController] to control the input text for the account number
  TextEditingController _accountNumberController = TextEditingController();

  /// A string variable to hold the bank code of the selected bank
  String? _bankCode;

  /// A string variable to hold the account name of the selected account
  String? _accountName;

  /// A string variable to hold the bank name of the selected account
  String? _bankName;

  /// Function to fetch all the nigerian banks from the database to
  /// [_allBanks]
  void _allBankNames() async {
    Future<List<NigerianBanks>> names = futureValue.getAllBanksFromDB();
    await names.then((value) {
      _myBanks.addAll(value);
      for (int i = 0; i < value.length; i++){
        _allMyBankNames.add(value[i].name!);
        _allBanks[value[i].name!] = value[i].code!;
      }
    }).catchError((error){
      print(error);
      Constants.showError(context, error);
    });
  }

  String _transferWith = 'instant';

  Future<void> _addToBeneficiary() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Material(
              type: MaterialType.transparency,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(17, 20, 17, 20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Color.fromRGBO(250, 250, 250, 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 25, 18, 20),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Add to Beneficiaries',
                              style: TextStyle(
                                color: Color(0XFF808080),
                                fontSize: 18,
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        color: Colors.transparent,
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 25, 0),
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Regular',
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1FD47D),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {

                                    },
                                    child: Container(
                                      height: 35,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        color: Color(0xFF1FD47D),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Regular',
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFFFFFF),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _transferWithModalSheet(context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(builder: (context, StateSetter setModalState) {
            return Material(
              type: MaterialType.transparency,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Color(0XFFF8F8FF),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width - 40,
                          child: Text(
                            'How would you like the transfer to be deposited',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF001431).withOpacity(0.52),
                              fontSize: 18,
                              fontFamily: "Regular",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 35),
                        Container(
                          width: SizeConfig.screenWidth! - 40,
                          height: 1,
                          color: Color(0XFF8F8F8F).withOpacity(0.2),
                        ),
                        SizedBox(height: 25),
                        GestureDetector(
                          onTap: () {
                            if(!mounted)return;
                            setModalState(() {
                              _transferWith = 'instant';
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/images/offline_bolt.png',
                                      height: 24,
                                      width: 24,
                                      fit: BoxFit.contain
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      width: SizeConfig.screenWidth! - 150,
                                      child: Text(
                                        'Instant Transfer (N${_getFee()} fee)',
                                        style: TextStyle(
                                          color: Color(0XFF001431)
                                              .withOpacity(0.5),
                                          fontSize: 15,
                                          fontFamily: 'Regular',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                (_transferWith == 'instant')
                                    ? Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        10,
                                      ),
                                    ),
                                    color: Color(0XFF02CF6D),
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                )
                                    : Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        10,
                                      ),
                                    ),
                                    border: Border.all(
                                      width: 2,
                                      color: Color(0XFFC7C7C7),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: SizeConfig.screenWidth! - 40,
                          height: 1,
                          color: Color(0XFF8F8F8F).withOpacity(0.2),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            if(!mounted)return;
                            setModalState(() {
                              _transferWith = 'standard';
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/images/low_priority.png',
                                        height: 24,
                                        width: 24,
                                        fit: BoxFit.contain
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      width: SizeConfig.screenWidth! - 150,
                                      child: Text(
                                        'Standard Transfer (3-5 days, free)',
                                        style: TextStyle(
                                          color: Color(0XFF001431)
                                              .withOpacity(0.5),
                                          fontSize: 15,
                                          fontFamily: 'Regular',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                (_transferWith == 'standard')
                                    ? Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        10,
                                      ),
                                    ),
                                    color: Color(0XFF02CF6D),
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                )
                                    : Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        10,
                                      ),
                                    ),
                                    border: Border.all(
                                      width: 2,
                                      color: Color(0XFFC7C7C7),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        Container(
                          width: SizeConfig.screenWidth! - 40,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              if(!mounted)return;
                              setModalState(() {
                                _showSpinner = true;
                              });
                              _verifyBank(
                                  _selectedBank!,
                                  _accountNumberController.text,
                                  _bankCode!,
                                  setModalState
                              );
                            },
                            child: _showSpinner
                                ? Center(child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF)))
                            )
                                : Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Bold",
                                color: Colors.white,
                              ),
                            ),
                            //color: Color(0xFF1FD47D),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  double _getFee(){
    if((5 / 100) * double.parse(widget.amount) > 52.5){
      return (5 / 100) * double.parse(widget.amount);
    } else {
      return 52.5;
    }
  }

  final InAppReview _inAppReview = InAppReview.instance;

  String _appStoreId = '1548208975';

  bool? _isAvailable;

  /// A String variable to hold the user's username
  String _username = '';

  /// Setting the current user's username to  [_username]
  void _getCurrentUser() async {
    await futureValue.getCurrentUser().then((user) {
      if(!mounted)return;
      setState(() => _username = user!.userName!.trim());
    }).catchError((Object error) {
      print(error);
    });
  }

  @override
  void initState() {
    _getCurrentUser();
    super.initState();
    _allBankNames();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inAppReview
          .isAvailable().then(
              (bool isAvailable) => setState(() => _isAvailable = isAvailable && !Platform.isAndroid)
      ).catchError((_) {
        setState(() => _isAvailable = false);
      });
    });
    _setAppStoreId('1548208975');
  }

  void _setAppStoreId(String id) => _appStoreId = id;

  Future<void> _requestReview() => _inAppReview.requestReview();

  Future<void> _openStoreListing() => _inAppReview.openStoreListing(
    appStoreId: _appStoreId,
  );

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus){
          currentFocus.unfocus();
        }
      },
      child: AbsorbPointer(
        absorbing: _showSpinner,
        child: Scaffold(
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
              Constants.money(double.parse(widget.amount), 'N'),
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
          body: Container(
            width: SizeConfig.screenWidth,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: (SizeConfig.screenWidth! - 40) / 2,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 2,
                              color: Color(0XFFC4C4C4).withOpacity(0.5),
                            ),
                          ),
                        ),
                        child: Text(
                          'Cash Out',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Regular',
                            color: Color(0XFF001431).withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildBankForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// A function that builds the form widget for users that selects bank [_tabSelected]
  Widget _buildBankForm(){
    return Form(
      key: _bankFormKey,
      child: Column(
        children: <Widget>[
         /* Container(
            width: SizeConfig.screenWidth,
            child: TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _bankNameController,
                style: TextStyle(
                  color: Color(0xFF808998),
                  fontSize: 16,
                  fontFamily: "Regular",
                ),
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Select Account',
                  hintStyle: TextStyle(
                    color: Color(0xFF808998),
                    fontSize: 16,
                    fontFamily: "Regular",
                  ),
                  prefixIcon: Container(
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: 22,
                            maxHeight: 22,
                          ),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Color(0xFFEFF5E8),
                          ),
                          child: Icon(
                            Icons.account_balance,
                            color: Color(0xFF1FD47D),
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              validator: (value) {
                if(_selectedAccount == null){
                  return 'Select an Account';
                }
                return null;
              },
              suggestionsCallback: (pattern) {
                return Suggestions.getSuggestions(pattern, _allUserBankNames);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(
                    suggestion,
                    style: TextStyle(
                      color: Color(0xff808998),
                      fontSize: 16,
                      fontFamily: "Regular",
                    ),
                  ),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) {
                _bankNameController.text = suggestion;
                if(!mounted) return;
                setState(() {
                  _selectedAccount = _bankNameController.text;
                });
              },
              onSaved: (value) {
                _selectedAccount = value;
              },
            ),
          ),*/
          Container(
            width: SizeConfig.screenWidth,
            child: TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _bankNameController,
                style: TextStyle(
                  color: Color(0xFF808998),
                  fontSize: 16,
                  fontFamily: "Regular",
                ),
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Select Bank',
                  hintStyle: TextStyle(
                    color: Color(0xFF808998),
                    fontSize: 16,
                    fontFamily: "Regular",
                  ),
                  prefixIcon: Container(
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: 22,
                            maxHeight: 22,
                          ),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Color(0xFFEFF5E8),
                          ),
                          child: Icon(
                            Icons.account_balance,
                            color: Color(0xFF1FD47D),
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              validator: (value) {
                if(_selectedBank == null) return 'Select a bank';
                return null;
              },
              suggestionsCallback: (pattern) async {
                return await Suggestions.getSuggestions(pattern, _allMyBankNames);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(
                    suggestion,
                    style: TextStyle(
                      color: Color(0xff808998),
                      fontSize: 16,
                      fontFamily: "Regular",
                    ),
                  ),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) {
                _bankNameController.text = suggestion;
                if(!mounted) return;
                setState(() {
                  _selectedBank = _bankNameController.text;
                  _bankCode = _allBanks[_selectedBank];
                });
              },
              onSaved: (value) {
                _selectedBank = value;
                if (!mounted) return;
                setState(() { _bankCode = _allBanks[_selectedBank]; });
              },
            ),
          ),
          SizedBox(height: 20.22),
          Container(
            width: SizeConfig.screenWidth,
            child: TextFormField(
              style: TextStyle(
                color: Color(0xff707988),
                fontSize: 16,
                fontFamily: "Regular",
              ),
              keyboardType: TextInputType.numberWithOptions(),
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
              ],
              controller: _accountNumberController,
              validator: (value) {
                if(value == null){
                  return 'Enter your Account Number';
                }
                if(value.length != 10){
                  return 'Invalid Account Number';
                }
                return null;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Account Number',
                hintStyle: TextStyle(
                  color: Color(0xff808998),
                  fontSize: 16,
                  fontFamily: "Regular",
                ),
                prefixIcon: Container(
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
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
                              'assets/images/hash.png',
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
          SizedBox(height: 20.22),
          Container(
            width: SizeConfig.screenWidth,
            child: TextFormField(
              style: TextStyle(
                color: Color(0xff707988),
                fontSize: 16,
                fontFamily: "Regular",
              ),
              keyboardType: TextInputType.numberWithOptions(),
              inputFormatters: [
                LengthLimitingTextInputFormatter(4),
              ],
              obscureText: true,
              controller: _pinController,
              validator: (value) {
                if(value == null){
                  return 'Enter your Pin';
                }
                if(value.length != 4){
                  return 'Pin must be 4 characters';
                }
                return null;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Transaction Pin',
                hintStyle: TextStyle(
                  color: Color(0xff808998),
                  fontSize: 16,
                  fontFamily: "Regular",
                ),
                prefixIcon: Container(
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
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
                              'assets/images/hash.png',
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
          SizedBox(height: 50),
          Container(
            width: SizeConfig.screenWidth,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                if(_bankFormKey.currentState!.validate()){
                  _transferWithModalSheet(context);
                }
              },
              child: Text(
                'Cash Out',
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: "Bold",
                  color: Colors.white,
                ),
              ),
              //color: Color(0xFF1FD47D),
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              Expanded(
                child: Container(
                  width: SizeConfig.screenWidth! - 20,
                  child: Text(
                    'Powered by PayStack and secured by AWS cryptography',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Regular",
                      color: Color(0XFFB3B9C6),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  /// Function to verify user's PIN using the [verifyPin] function in the
  /// [RestDataSource] class
  void _verifyPin(Banks bank, StateSetter setModalState) async {
    var api = RestDataSource();
    await api.verifyPin(_pinController.text).then((value) async {
      _createTransfer(bank, setModalState);
    }).catchError((e){
      if(!mounted)return;
      setModalState(() { _showSpinner = false; });
      print(e);
      _showAlert(false, e);
    });
  }

  /// Function to verify bank details using the [verifyBankAccount] function in
  /// the [RestDataSource] class
  void _verifyBank(String bankName, String accountNumber, String bankCode, StateSetter setModalState) async {
    var api = RestDataSource();
    await api.verifyBankAccount(bankCode, accountNumber).then((value) async {
      var bank = Banks(
        accountName: value,
        accountNumber: accountNumber,
        bankCode: bankCode,
        bankName: bankName,
      );
      _verifyPin(bank, setModalState);
    }).catchError((e){
      if(!mounted)return;
      setModalState(() { _showSpinner = false; });
      print(e);
      _showAlert(false, e);
    });
  }

  /// Function that creates transfer to get the recipient code by calling
  /// [createTransfer] in the [RestDataSource] class
  void _createTransfer(Banks bank, StateSetter setModalState) async {
    // var api = RestDataSource();
    // await api.createTransfer(bank.accountNumber!, bank.bankCode!).then((value) async {
    //   if(_transferWith == 'instant'){
    //     _initiateTransfer(bank, value, setModalState);
    //   } else {
    //     _freeWithdrawal(bank, value, setModalState);
    //   }
    // }).catchError((error) {
    //   if(!mounted)return;
    //   setModalState(() {
    //     _showSpinner = false;
    //   });
    //   Constants.showError(context, error);
    // });
    if(_transferWith == 'instant'){
        _initiateTransfer(bank, 'XXXX', setModalState);
      } else {
        _freeWithdrawal(bank, 'XXXX', setModalState);
      }
  }

  /// Function that initializes transfer by calling
  /// [initiateTransfer] in the [RestDataSource] class
  void _initiateTransfer(Banks bank, String transferCode, StateSetter setModalState) async {
    bool locationApproved = await LocationPermissionCheck().checkLocationPermission();
    if(!locationApproved){
      if (!mounted) return;
      setState(() { _showSpinner = false; });
      LocationPermissionCheck().buildLocationRequest(context);
    }
    else {
      var api = RestDataSource();
      await api.initiateTransfer(widget.amount, transferCode, _pinController.text, _selectedBank!,_accountNumberController.text).then((value) async {
        if(!mounted)return;
        setModalState(() { _showSpinner = false; });
        _showAlert(true, '${Constants.money(double.parse(widget.amount) - _getFee(), 'N')} will be deposited to your bank account shortly');
      }).catchError((error) {
        if(!mounted)return;
        setModalState(() { _showSpinner = false; });
        if(error.toString() == "We are having some trouble depositing your funds right now, please try again later"){
          _showAlert(false, "We are having some trouble depositing your funds right now. Click the button below to redirect you to Awoof Support now for your funds", bank: bank);
        }
        else {
          _showAlert(false, error);
        }
      });
    }
  }

  /// Function that initializes free withdrawal by calling
  /// [freeWithdrawal] in the [RestDataSource] class
  void _freeWithdrawal(Banks bank, String transferCode, StateSetter setModalState) async {
    bool locationApproved = await LocationPermissionCheck().checkLocationPermission();
    if(!locationApproved){
      if (!mounted) return;
      setState(() { _showSpinner = false; });
      LocationPermissionCheck().buildLocationRequest(context);
    }
    else {
      var api = RestDataSource();
      await api.freeWithdrawal(bank, widget.amount, transferCode).then((value) async {
        if(!mounted)return;
        setModalState(() {
          _showSpinner = false;
        });
        _showAlert(true, '${Constants.money(double.parse(widget.amount), 'N')} will be deposited to your bank account shortly');
      }).catchError((error) {
        if(!mounted)return;
        setModalState(() { _showSpinner = false; });
        _showAlert(false, error);
      });
    }
  }

  /// Function to show alert popup either success or failed
  void _showAlert(bool success, String message, {Banks? bank}){
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
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Wallet(),)
              );
              _requestReview();
            }
            else {
              Navigator.pop(context);
              Navigator.pop(context);
              if (bank != null) {
                _sendWhatsappMessage(bank);
              }
              else {
                Navigator.pop(context);
              }
            }
          },
          width: 120,
        )
      ],
    ).show();






  }

  /// Function to send whatsapp message to awoof support when withdrawal fails
  void _sendWhatsappMessage(Banks bank) async {
    String number = "14174133301";
    String accountNo = "Account No: ${bank.accountNumber}";
    String bankName = "Bank: ${bank.bankName}";
    String accountName = "Account Name: ${bank.accountName}";
    String amount = "Amount: ${Constants.money(double.parse(widget.amount), 'N')}";
    String username = "Username: $_username";

    String message = "Hi Awoof, I am Having issues withdrawing%0a$accountNo%0a$bankName%0a$accountName%0a$amount%0a$username";
    String url = "https://api.whatsapp.com/send/?phone=$number&text=${message.replaceAll(" ", "%20")}";

    if (await canLaunch(url)) await launch(url);
    else throw 'Could not launch the url';
  }

}
