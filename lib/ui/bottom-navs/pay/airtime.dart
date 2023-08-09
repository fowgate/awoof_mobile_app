import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/model/airtime-topup.dart';
import 'package:awoof_app/model/operators.dart';
import 'package:awoof_app/networking/rest-data.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:awoof_app/utils/rflutter_alert-2.0.4/lib/rflutter_alert.dart';
//import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/services.dart';


class Airtime extends StatefulWidget {

  final String amount;

  const Airtime({
    Key? key,
    required this.amount
  }) : super(key: key);

  @override
  _AirtimeState createState() => _AirtimeState();
}

class _AirtimeState extends State<Airtime> {

  /// A [GlobalKey] to hold the form state of my form widget for phone number validation
  final _phoneFormKey = GlobalKey<FormState>();

  /// A [GlobalKey] to hold the form state of my form widget for operator validation
  final _operatorFormKey = GlobalKey<FormState>();

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  Map<String, String> _operators = {};

  /// A String value holding the selected operator
  String? _selectedOperator;

  /// A String value holding the default operator
  String _defaultOperator = '';

  /// A boolean value holding the if operator has been auto detected
  bool autoDetected = false;

  /// A [TextEditingController] to control the input text for the phone number
  TextEditingController _phoneController = TextEditingController();

  /// A [TextEditingController] to control the input text for the transaction pin
  TextEditingController _pinController = TextEditingController();

  List<String> _services = [
    "Airtime Top Up",
    "Data Top Up",
  ];

  /// An integer value holding the state of the button
  int _state = 0;

  String _selectedService = 'Airtime Top Up';

  var f = new NumberFormat("#,###.##", "en_US");
  //String code;

  /// A String variable to hold the reloadly access token
  String _accessToken = '';

  /// Function to fetch all the giveaways from the database to
  /// [_giveAways]
  Future<void> _getAccessToken() async {
    Future<dynamic> giveaways = futureValue.getAccessToken();
    await giveaways.then((value) {
      if(!mounted) return;
      setState(() {
        _accessToken = value["access_token"];
      });
    }).catchError((error){
      print(error);
      Constants.showError(context, error);
    });
  }

  @override
  void initState() {
    super.initState();
    _getAccessToken();
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
          'N${f.format(double.parse(widget.amount))}',
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
                /*Container(
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      value: selectedOperator,
                      onChanged: (newValue) {
                        setState(() {
                          selectedOperator = newValue;
                        });
                      },
                      iconEnabledColor: Color(0XFFC0C0C0),
                      autovalidate: true,
                      validator: (value) {
                        return (selectedOperator == null ||
                                selectedOperator.isEmpty)
                            ? 'Select a bank'
                            : null;
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
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Color(0xFFDD0033),
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Color(0xFFDD0033),
                          ),
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
                                      'assets/images/network.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      items: operators
                          .map((code, name) {
                            return MapEntry(
                              name,
                              DropdownMenuItem(
                                value: code,
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    color: Color(0xff808998),
                                    fontSize: 16,
                                    fontFamily: "Regular",
                                  ),
                                ),
                              ),
                            );
                          })
                          .values
                          .toList(),
                    ),
                  ),*/
                SizedBox(height: 20),
                _state == 2
                    ? _operatorForm()
                    : _phoneForm(),
                SizedBox(height: 20),
                Container(
                  width: SizeConfig.screenWidth,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if(_state == 2) {
                        if(_operatorFormKey.currentState!.validate()){
                          _verifyPin();
                          //_buyAirtime();
                        }
                      }
                      else {
                        if(_phoneFormKey.currentState!.validate()){
                          _autoDetect();
                        }
                      }
                    },
                    child: _setUpButton(),
                   // color: Color(0xFF1FD47D),
                  ),
                ),
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
      return Text(
        'Continue',
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
        'Buy',
        style: TextStyle(
          fontSize: 17,
          fontFamily: "Bold",
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

  /// A function to build a form widget for user entering their phone number
  Widget _phoneForm(){
    return Form(
      key: _phoneFormKey,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        width: SizeConfig.screenWidth,
        child: TextFormField(
          style: TextStyle(
            color: Color(0xff707988),
            fontSize: 16,
            fontFamily: "Regular",
          ),
          keyboardType: TextInputType.numberWithOptions(),
          controller: _phoneController,
          validator: (value) {
            if(value == null){
              return 'Enter a valid phone number';
            }
            return null;
          },
          decoration: kTextFieldDecoration.copyWith(
            hintText: 'Enter Phone Number',
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
                        Radius.circular(6),
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
    );
  }

  /// A function to build a form widget for user selecting their operator
  Widget _operatorForm(){
    return Form(
      key: _operatorFormKey,
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(
            _phoneController.text,
            style: TextStyle(
              fontSize: 22,
              fontFamily: "Regular",
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          SizedBox(height: 12),
          Container(
            width: SizeConfig.screenWidth,
            child: DropdownButtonFormField(
              value: _selectedOperator,
              onChanged: (newValue) {
                setState(() {
                  _selectedOperator = newValue!;
                });
              },
              //autovalidate: operatorValidate,
              validator: (value) {
                if(_selectedOperator == null || _selectedOperator!.isEmpty){
                  return 'Select an operator';
                }
                return null;
              },
              iconEnabledColor: Color(0XFFC0C0C0),
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Select Operator',
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
                            Radius.circular(6),
                          ),
                          color: Color(0xFFEFF5E8),
                        ),
                        child: Center(
                          child: Container(
                            width: 14,
                            height: 14,
                            child: Image.asset(
                              'assets/images/network.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              items: _operators
                  .map((code, name) {
                return MapEntry(
                  name,
                  DropdownMenuItem(
                    value: code,
                    child: Text(
                      name,
                      style: TextStyle(
                        color: Color(0xff808998),
                        fontSize: 16,
                        fontFamily: "Regular",
                      ),
                    ),
                  ),
                );
              }).values.toList(),
            ),
          ),
          (autoDetected)
              ? Column(
            children: [
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  _loadAllOperators();
                },
                child: Text(
                  'Not $_defaultOperator?',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Regular",
                    decoration: TextDecoration.underline,
                    color: Color(0xFF1EB27C),
                  ),
                ),
              ),
              SizedBox(height: 15),
            ],
          )
              : Container(),
          Container(
            margin: EdgeInsets.only(bottom: 12),
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
                if (value!.isEmpty) {
                  return 'Enter your pin';
                }
                if (value.length != 4){
                  return 'Enter a valid 4 digit pin';
                }
                return null;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter Transaction Pin',
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
                            Radius.circular(6),
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
          SizedBox(height: 15),
        ],
      ),
    );
  }

  /// Function to auto detect the user's number by calling [detectNumber] in the
  /// rest data source class
  void _autoDetect() async {
    if(!mounted)return;
    setState(() {
      _state = 1;
    });
    if(_accessToken == '' || _accessToken == null || _accessToken == 'Error'){
      await _getAccessToken();
    }
    var api = RestDataSource();
    await api.detectNumber(_phoneController.text, _accessToken).then((Operator operator) {
      if(!mounted)return;
      setState(() {
        _defaultOperator = operator.operatorName!;
        _selectedOperator = operator.operatorId;
        _operators[operator.operatorId!] = operator.operatorName!;

        _state = 2;
        autoDetected = true;
      });
    }).catchError((e){
      print(e);
      Constants.showError(context, e.toString());
    });
  }

  /// Function to load all country operators by calling [fetchTelcoOperators] in the
  /// rest data source class
  void _loadAllOperators() async {
    if(!mounted)return;
    setState(() {
      _state = 1;
    });
    if(_accessToken == '' || _accessToken == null || _accessToken == 'Error'){
      await _getAccessToken();
    }
    var api = RestDataSource();
    await api.fetchTelcoOperators(_accessToken).then((value) {
      if(!mounted)return;
      setState(() {
        _operators.clear();
        _selectedOperator = null;
      });
      for(int i = 0; i < value.length; i++){
        if(value[i].operatorName!.contains('Data')
            || value[i].operatorName!.contains('Bundles')){
          /// skip
          /// No support for data yet
        } else {
          _operators[value[i].operatorId!] = value[i].operatorName!;
        }
      }
      if(!mounted)return;
      setState(() {
        _state = 2;
        autoDetected = true;
      });
    }).catchError((e){
      print(e);
      Constants.showError(context, "An error occurred, please try again later");
    });
  }

  void _verifyPin()async{
    if(!mounted)return;
    setState(() {
      _state = 1;
    });
    var api = RestDataSource();
    await api.verifyPin(_pinController.text).then((value) async {
      _buyAirtime();
    }).catchError((e){
      if(!mounted)return;
      setState(() {
        _state = 0;
      });
      print(e);
      _showAlert(false, e);
    });
  }

  /// Function to by airtime by calling [airtimeTopUp] in the rest data
  /// source class
  void _buyAirtime() async {
    var api = RestDataSource();
    AirtimeTopup topup = AirtimeTopup();
    topup.recipientPhoneNumber = _phoneController.text;
    topup.operatorId = _selectedOperator!;
    topup.amount = widget.amount;
    topup.recipientPhoneCountryCode = 'NG';
    topup.accessToken = _accessToken;
    await api.airtimeTopUp(topup).then((value) async {
      await futureValue.updateUser();
      if(!mounted)return;
      setState(() {
        _state = 3;
      });
      _showAlert(true, "Successfully bought airtime of N${widget.amount}");
    }).catchError((e){
      if(!mounted)return;
      setState(() {
        _state = 0;
      });
      print(e);
      _showAlert(false, 'An error occurred. Try again later');
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
