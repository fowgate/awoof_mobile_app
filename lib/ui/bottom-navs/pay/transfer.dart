import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/bloc/select-suggestions.dart';
import 'package:awoof_app/model/nigerian-banks.dart';
import 'package:awoof_app/networking/rest-data.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/location-permission.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:awoof_app/utils/rflutter_alert-2.0.4/lib/rflutter_alert.dart';
//import 'package:rflutter_alert/rflutter_alert.dart';

class Transfer extends StatefulWidget {

  final String amount;

  const Transfer({
    Key? key,
    required this.amount
  }) : super(key: key);


  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer> {

  /// A string value holding the selected tab
  String _tabSelected = 'awoof';

  /// A [GlobalKey] to hold the form state of my form widget for awoof user transfer validation
  final _awoofFormKey = GlobalKey<FormState>();

  /// A [GlobalKey] to hold the form state of my form widget for bank transfer form validation
  final _bankFormKey = GlobalKey<FormState>();

  /// A boolean variable to hold the [inAsyncCall] value in my
  /// [ModalProgressHUD] widget
  bool _showSpinner = false;

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

  /// A string variable to hold the bank code of the selected bank
  String? _bankCode;

  /// A string variable to hold the account number
  String? _accountNumber;

  /// A [TextEditingController] to control the input text for the phone number
  TextEditingController _phoneController = TextEditingController();

  /// A [TextEditingController] to control the input text for the pin
  TextEditingController _pinController = TextEditingController();

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

  String transferWith = 'instant';

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
          return StatefulBuilder(builder: (context, setState) {
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
                          width: MediaQuery.of(context).size.width - 40,
                          height: 1,
                          color: Color(0XFF8F8F8F).withOpacity(0.2),
                        ),
                        SizedBox(height: 25),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              transferWith = 'instant';
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
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          150,
                                      child: Text(
                                        'Instant Transfer (N52.5 fee)',
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
                                (transferWith == 'instant')
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
                          width: MediaQuery.of(context).size.width - 40,
                          height: 1,
                          color: Color(0XFF8F8F8F).withOpacity(0.2),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              transferWith = 'standard';
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
                                      'assets/images/low-priority.png',
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          150,
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
                                (transferWith == 'standard')
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
                          width: MediaQuery.of(context).size.width - 40,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {

                            },
                            child: Text(
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

  @override
  void initState() {
    super.initState();
    _allBankNames();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1FD47D)),
      ),
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
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _tabSelected = 'awoof';
                          });
                        },
                        child: Container(
                          width: (SizeConfig.screenWidth! - 40) / 2,
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 2,
                                color: (_tabSelected == 'awoof')
                                    ? Color(0XFFC4C4C4).withOpacity(0.5)
                                    : Color(0XFFC4C4C4).withOpacity(0.3),
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Awoof User',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: (_tabSelected == 'awoof')
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontFamily: 'Regular',
                                color: Color(0XFF001431).withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _tabSelected = 'bank';
                          });
                        },
                        child: Container(
                          width: (SizeConfig.screenWidth! - 40) / 2,
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 2,
                                color: (_tabSelected == 'bank')
                                    ? Color(0XFFC4C4C4).withOpacity(0.5)
                                    : Color(0XFFC4C4C4).withOpacity(0.3),
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Bank Transfer',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: (_tabSelected == 'bank')
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontFamily: 'Regular',
                                color: Color(0XFF001431).withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _tabSelected == 'bank'
                      ? _buildBankForm()
                      : _buildAwoofUserForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// A function that builds the form widget for users that selects awoof [_tabSelected]
  Widget _buildAwoofUserForm(){
    return Form(
      key: _awoofFormKey,
      child: Column(
        children: <Widget>[
          Container(
            width: SizeConfig.screenWidth,
            child: TextFormField(
              controller: _phoneController,
              style: TextStyle(
                color: Color(0xFF707988),
                fontSize: 16,
                fontFamily: "Regular",
              ),
              keyboardType: TextInputType.numberWithOptions(),
              validator: (value) {
                if(value == null || value.length != 11){
                  return 'Enter a valid phone number';
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
                hintText: 'Phone Number',
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
                            Radius.circular(6),
                          ),
                          color: Color(0xFFEFF5E8),
                        ),
                        child: Icon(
                          Icons.phone,
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
          SizedBox(height: 200),
          Container(
            width: SizeConfig.screenWidth,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                if(_awoofFormKey.currentState!.validate()){
                  if(!mounted)return;
                  setState(() {
                    _showSpinner = true;
                  });
                  _w2wTransfer();
                }
              },
              child: Text(
                'Transfer',
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: "Bold",
                  color: Colors.white,
                ),
              ),
              //color: Color(0xFF1FD47D),
            ),
          ),
        ],
      ),
    );
  }

  /// A function that builds the form widget for users that selects bank [_tabSelected]
  Widget _buildBankForm(){
    return Form(
      key: _bankFormKey,
      child: Column(
        children: <Widget>[
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
          SizedBox(height: 20.22),
          Container(
            width: SizeConfig.screenWidth,
            child: TextFormField(
              controller: _accountNumberController,
              style: TextStyle(
                color: Color(0xFF707988),
                fontSize: 16,
                fontFamily: "Regular",
              ),
              keyboardType: TextInputType.numberWithOptions(),
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
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                          color: Color(0xFFEFF5E8),
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
          SizedBox(height: 150),
          Container(
            width: SizeConfig.screenWidth,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                if(_bankFormKey.currentState!.validate()){
                  if(!mounted)return;
                  setState(() {
                    _showSpinner = true;
                  });
                  _createTransfer();
                }
              },
              child: Text(
                'Transfer',
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: "Bold",
                  color: Colors.white,
                ),
              ),
              //color: Color(0xFF1FD47D),
            ),
          ),
        ],
      ),
    );
  }

  /// Function that does wallet to wallet transfer by calling
  /// [w2wTransfer] in the [RestDataSource] class
  void _w2wTransfer() async {
    var api = RestDataSource();
    await api.w2wTransfer(widget.amount, _phoneController.text, _pinController.text).then((value) async {
      if(!mounted)return;
      setState(() {
        _showSpinner = false;
      });
      _showAlert(true, 'Transferred N${widget.amount} successfully');
    }).catchError((error) {
      if(!mounted)return;
      setState(() {
        _showSpinner = false;
      });
      _showAlert(false, error);
    });
  }

  /// Function that creates transfer to get the recipient code by calling
  /// [createTransfer] in the [RestDataSource] class
  void _createTransfer() async {
    var api = RestDataSource();
    await api.createTransfer(_accountNumber!, _bankCode!).then((value) async {
      _initiateTransfer(value);
    }).catchError((error) {
      if(!mounted)return;
      setState(() {
        _showSpinner = false;
      });
      Constants.showError(context, error);
    });
  }

  /// Function that initializes transfer by calling
  /// [initiateTransfer] in the [RestDataSource] class
  void _initiateTransfer(String transferCode) async {
    bool locationApproved = await LocationPermissionCheck().checkLocationPermission();
    if(!locationApproved){
      if (!mounted) return;
      setState(() { _showSpinner = false; });
      LocationPermissionCheck().buildLocationRequest(context);
    }
    else {
      var api = RestDataSource();
      await api.initiateTransfer(widget.amount, transferCode, _pinController.text,_selectedBank, _accountNumberController.text).then((value) async {
        if(!mounted)return;
        setState(() {
          _showSpinner = false;
        });
        _showAlert(true, 'Transferred N${widget.amount} successfully');
      }).catchError((error) {
        if(!mounted)return;
        setState(() {
          _showSpinner = false;
        });
        _showAlert(false, error);
      });
    }
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
