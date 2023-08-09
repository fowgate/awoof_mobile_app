import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/bloc/select-suggestions.dart';
import 'package:awoof_app/model/add-bank.dart';
import 'package:awoof_app/model/nigerian-banks.dart';
import 'package:awoof_app/networking/rest-data.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:flutter/material.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddBank extends StatefulWidget {

  static const String id = 'add_bank_page';

  @override
  _AddBankState createState() => _AddBankState();
}

class _AddBankState extends State<AddBank> {

  /// A [GlobalKey] to hold the form state of my form widget for form validation
  final _formKey = GlobalKey<FormState>();

  /// A [GlobalKey] to hold the form state of my form widget for pin validation
  final _pinFormKey = GlobalKey<FormState>();

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// String variable to hold the selected bank in the drop down
  String? _selectedBank;

  /// A Map to hold the names of all the banks to its bank codes in the database
  Map<String, String> _nigerianBanks = Map();

  /// A List to hold the names of all the nigerian banks in the database
  List<String> _allNigerianBankNames = [];

  /// A [TextEditingController] to control the input text for the bank name
  TextEditingController _bankNameController = TextEditingController();

  /// A [TextEditingController] to control the input text for the account number
  TextEditingController _accountNumberController = TextEditingController();

  /// A [TextEditingController] to control the input text for the pin
  TextEditingController _pinController = TextEditingController();

  /// A string variable to hold the bank code of the selected bank
  String? _bankCode;

  /// A string variable to hold the account number
  String? _accountNumber;

  /// A string variable to hold the account name
  String? _accountName;

  /// Function to fetch all the nigerian banks from the database to
  /// [_nigerianBanks]
  void _allBankNames() async {
    Future<List<NigerianBanks>> names = futureValue.getAllBanksFromDB();
    await names.then((value) {
      for (int i = 0; i < value.length; i++){
        _allNigerianBankNames.add(value[i].name!);
        _nigerianBanks[value[i].name!] = value[i].code!;
      }
    }).catchError((error){
      print(error);
      Constants.showError(context, error);
    });
  }

  /// An integer value holding the state of the button
  int _state = 0;

  /// A boolean variable to hold whether account is verified or not
  bool _isVerified = false;

  Map<String, String> banks = {};

  @override
  void initState() {
    super.initState();
    _allBankNames();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Container(
          width: 90,
          child: Image.asset(
            'assets/images/awoof-blue.png',
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            size: 20,
            color: Color(0XFF060D25),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 15),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Text(
                    'Add new bank account',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Regular',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                _isVerified
                    ? _buildMyAccount()
                    : _buildAddAccount(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Function to set up button states in sync with [_state]
  Widget _setUpButton(){
    if(_state == 0){
      return ElevatedButton(
        //color: Color(0xFF1FD47D),
        onPressed: () {
          if(_formKey.currentState!.validate()){
            if(!mounted)return;
            setState(() {
              _state = 1;
            });
            _verifyAccount();
          }
        },
        child: Text(
          'Verify',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 17,
              fontFamily: "Regular",
              color: Colors.white,
              fontWeight: FontWeight.w600
          ),
        ),
      );
    }
    else if(_state == 1){
      return ElevatedButton(
        //color: Color(0xFF1FD47D),
        onPressed: (){},
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }
    else if(_state == 2){
      return ElevatedButton(
       // color: Color(0xFF1FD47D),
        onPressed: () {
          if(_pinFormKey.currentState!.validate()){
            if(!mounted)return;
            setState(() {
              _state = 1;
            });
            _saveNewBank();
          }
        },
        child: Text(
          'Add Account',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 17,
              fontFamily: "Regular",
              color: Colors.white,
              fontWeight: FontWeight.w600
          ),
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

  Widget _buildAddAccount(){
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _bankNameController,
                style: TextStyle(
                  color: Color(0xff808998),
                  fontSize: 16,
                  fontFamily: "Regular",
                ),
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Select Bank',
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
                            borderRadius:
                            BorderRadius.all(
                              Radius.circular(
                                5,
                              ),
                            ),
                            color: Color(0x00EFF5E8),
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
                if(_selectedBank == null){
                  return 'Select a bank';
                }
                return null;
              },
              suggestionsCallback: (pattern) async {
                return await Suggestions.getSuggestions(pattern, _allNigerianBankNames);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(
                    suggestion,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "Regular",
                      fontWeight: FontWeight.bold,
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
                  _bankCode = _nigerianBanks[_selectedBank];
                });
              },
              onSaved: (value) {
                _selectedBank = value;
                if (!mounted) return;
                setState(() {
                  _bankCode = _nigerianBanks[_selectedBank];
                });
              },
            ),
          ),
          /*Container(
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        value: _selectedBank,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedBank = newValue;
                            _bankCode = _nigerianBanks[_selectedBank];
                          });
                        },
                        iconEnabledColor: Color(0XFFC0C0C0),
                        autovalidate: validate,
                        validator: (value) {
                          if(_selectedBank == null){
                            return 'Select a bank';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Select Bank',
                          hintStyle: TextStyle(
                            color: Color(0xff808998),
                            fontSize: 16,
                            fontFamily: "Regular",
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFFB9B9B9),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFFFFFFFF),
                            ),
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
                                    borderRadius:
                                    BorderRadius.all(
                                      Radius.circular(
                                        5,
                                      ),
                                    ),
                                    color: Color(0x00EFF5E8),
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
                        items: _allNigerianBankNames.map((name) {
                          return DropdownMenuItem(
                            value: name,
                            child: Text(
                              name,
                              style: TextStyle(
                                color: Color(0xff808998),
                                fontSize: 16,
                                fontFamily: "Regular",
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),*/
          SizedBox(height: 17),
          Container(
            width: MediaQuery.of(context).size.width,
            child: TextFormField(
              style: TextStyle(
                color: Color(0xff707988),
                fontSize: 16,
                fontFamily: "Regular",
              ),
              keyboardType: TextInputType.numberWithOptions(),
              controller: _accountNumberController,
              validator: (value) {
                if(value == null || value.length != 10){
                  return 'Enter a valid bank account number';
                }
                return null;
              },
              onChanged: (value){
                if(!mounted) return;
                setState(() {
                  _accountNumber = value;
                });
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
                          borderRadius:
                          BorderRadius.all(
                            Radius.circular(
                              5,
                            ),
                          ),
                          color: Color(0x00EFF5E8),
                        ),
                        child: Icon(
                          Icons.dialpad,
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
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 350,
            child: Transform.translate(
              offset: Offset(0, -40),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  child: _setUpButton(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyAccount(){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30),
              Row(
                children: <Widget>[
                  Container(
                    width: SizeConfig.screenWidth! / 2 - 40,
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Bank',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Regular',
                            color: Color(0XFF808998),
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          _selectedBank!,
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.bold,
                            color: Color(
                              0xFFFFFFFF,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: SizeConfig.screenWidth! / 2 - 40,
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'Account Number',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Regular',
                            color: Color(0XFF808998),
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          _accountNumberController.text,
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.bold,
                            color: Color(
                              0xFFFFFFFF,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: SizeConfig.screenWidth,
                height: 15,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Color(0XFFECECEC),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Container(
                width: SizeConfig.screenWidth! - 43,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Account Name',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Regular',
                        color: Color(0XFF808998),
                      ),
                    ),
                    SizedBox(height: 7),
                    Container(
                      width: SizeConfig.screenWidth,
                      child: Text(
                        _accountName!,
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Regular',
                          fontWeight: FontWeight.bold,
                          color: Color(
                            0xFFFFFFFF,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: SizeConfig.screenWidth,
                height: 15,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Color(0XFFECECEC),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 22),
              Form(
                key: _pinFormKey,
                child: Container(
                  width: SizeConfig.screenWidth,
                  child: TextFormField(
                    style: TextStyle(
                      color: Color(0xff707988),
                      fontSize: 16,
                      fontFamily: "Regular",
                    ),
                    keyboardType: TextInputType.numberWithOptions(),
                    controller: _pinController,
                    obscureText: true,
                    validator: (value) {
                      if(value == null){
                        return 'Please enter your transaction pin';
                      }
                      if(value.length != 4){
                        return 'Pin must be 4 characters';
                      }
                      return null;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Awoof Pin',
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
                                color: Color(0x00EFF5E8),
                              ),
                              child: Icon(
                                Icons.dialpad,
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
              ),
              Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight! - 360,
                child: Transform.translate(
                  offset: Offset(0, -40),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: SizeConfig.screenWidth,
                      height: 56,
                      child: _setUpButton(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Function that verifies a user's bank details by calling [verifyBankAccount]
  /// in the [RestDataSource] class
  void _verifyAccount() async {
    var api = RestDataSource();
    await api.verifyBankAccount(_bankCode!, _accountNumber!).then((value) async {
      if(!mounted)return;
      setState(() {
        _state = 2;
        _accountName = value;
        _isVerified = true;
      });
    }).catchError((error){
      if(!mounted)return;
      setState(() {
        _state = 0;
      });
      Constants.showError(context, error);
    });
  }

  /// Function adds new bank account by calling [addBankAccount] in the
  /// [RestDataSource] class
  void _saveNewBank() async {
    var api = RestDataSource();
    var bank = AddMyBank();
    bank.accountName = _accountName;
    bank.accountNumber = _accountNumber;
    bank.bankName = _selectedBank;
    bank.bankCode = _bankCode;
    bank.newPin = _pinController.text;

    await api.addBankAccount(bank).then((value) {
      if(!mounted)return;
      setState(() {
        _state = 3;
      });
      Constants.showSuccess(
        context,
        'Successfully saved bank',
        where: (){
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      );
    }).catchError((error){
      if(!mounted)return;
      setState(() {
        _state = 2;
      });
      Constants.showError(context, error);
    });
  }

}
