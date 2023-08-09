import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/networking/rest-data.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:flutter/material.dart';
import 'package:awoof_app/ui/welcome.dart';
import 'package:flutter/services.dart';

class SignUpPin extends StatefulWidget {

  static const String id = 'sign_up_pin';

  @override
  _SignUpPinState createState() => _SignUpPinState();
}

class _SignUpPinState extends State<SignUpPin> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A [GlobalKey] to hold the form state of my form widget for form validation
  final _formKey = GlobalKey<FormState>();

  /// Variable to hold the id of the user logged in
  String? _userId;

  /// A [TextEditingController] to control the input text for the user's pin
  TextEditingController _pinController = TextEditingController();

  /// A [TextEditingController] to control the input text for the user's confirm pin
  TextEditingController _confirmPinController = TextEditingController();

  /// A boolean variable to hold the [inAsyncCall] value in my
  /// [ModalProgressHUD] widget
  bool _showSpinner = false;

  /// Setting the current user's id to [_userId]
  void _getCurrentUser() async {
    await futureValue.updateUser();
    await futureValue.getCurrentUser().then((user) {
      if(!mounted)return;
      setState(() {
        _userId = user!.id;
      });
    }).catchError((Object error) {
      print(error);
      Constants.showError(context, error.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0XFF04BD64),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color(0XFF04BD64),
        title: Container(
          width: 91,
          child: Opacity(
            opacity: 0.6,
            child: Image.asset(
              'assets/images/awoof-trans.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Container(
        width: SizeConfig.screenWidth,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 60),
              Text(
                'ALMOST DONE',
                style: TextStyle(
                  color: Color(0xff9EE5C3),
                  fontSize: 13,
                  fontFamily: "Regular",
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Create Transaction Pin',
                style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 22,
                    fontFamily: "Regular",
                    fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: SizeConfig.screenWidth! * 0.8,
                child: Text(
                  'You will use this PIN to authorize every transaction on your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xffEFFBF5),
                    fontSize: 16,
                    fontFamily: "Regular",
                  ),
                ),
              ),
              SizedBox(height: 47),
              _buildForm(),
              SizedBox(height: 26),
              Container(
                width: SizeConfig.screenWidth! * 0.85,
                height: 56,
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    if(_formKey.currentState!.validate()){
                      if(!mounted)return;
                      setState(() {
                        _showSpinner = true;
                      });
                      _setPin();
                    }
                  },
                  child: Center(
                    child: _showSpinner
                        ? CircularProgressIndicator()
                        : Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: "Bold",
                        color: Color(0xFF1FD47D),
                      ),
                    ),
                  ),
                ),
              ),
              /*SizedBox(height: 22),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(Welcome.id, (Route<dynamic> route) => false);
                },
                child: Text(
                  'I’ll Do This Later',
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: "Bold",
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),*/
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  /// A function to build the form widget where users enter their details
  Widget _buildForm(){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            width: SizeConfig.screenWidth! * 0.85,
            child: TextFormField(
              style: TextStyle(
                color: Color(0xffFFFFFF),
                fontSize: 16,
                fontFamily: "Regular",
              ),
              keyboardType: TextInputType.numberWithOptions(),
              inputFormatters: [
                LengthLimitingTextInputFormatter(4),
              ],
              controller: _pinController,
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your pin';
                }
                if (value.length != 4){
                  return 'Enter a valid 4 digit pin';
                }
                return null;
              },
              decoration: kTextPinDecoration.copyWith(
                hintText: 'Enter Pin',
                hintStyle: TextStyle(
                  color: Color(0xffFFFFFF),
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
                          color: Color(0xFFFFFFFF).withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
          Container(
            width: SizeConfig.screenWidth! * 0.85,
            child: TextFormField(
              style: TextStyle(
                color: Color(0xffFFFFFF),
                fontSize: 16,
                fontFamily: "Regular",
              ),
              keyboardType: TextInputType.numberWithOptions(),
              inputFormatters: [
                LengthLimitingTextInputFormatter(4),
              ],
              controller: _confirmPinController,
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your pin';
                }
                if (value != _pinController.text || value.length != 4){
                  return 'Pins do not match';
                }
                return null;
              },
              decoration: kTextPinDecoration.copyWith(
                hintText: 'Confirm Pin',
                hintStyle: TextStyle(
                  color: Color(0xffFFFFFF),
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
                            Radius.circular(5),
                          ),
                          color: Color(0xFFFFFFFF).withOpacity(0.1),
                        ),
                        child: Container(
                            width: 14,
                            height: 14,
                            child: Center(
                              child: Image.asset(
                                'assets/images/check-circle.png',
                                fit: BoxFit.contain,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Function that saves a user transaction pin by calling
  /// [setPin] in the [RestDataSource] class
  Future<void> _setPin() async {
    var api = RestDataSource();
    await api.setPin(_userId!, _pinController.text).then((value) async {
      _pinController.clear();
      _confirmPinController.clear();
      if(!mounted)return;
      setState(() {
        _showSpinner = false;
      });
      Constants.showSuccess(
        context,
        'Transaction pin successfully saved',
        where: (){
          Navigator.of(context).pushNamedAndRemoveUntil(Welcome.id, (Route<dynamic> route) => false);
        }
      );
    }).catchError((error) {
      if(!mounted)return;
      setState(() {
        _showSpinner = false;
      });
      _pinController.clear();
      _confirmPinController.clear();
      print(error);
      Constants.showError(context, error);
    });
  }

}
