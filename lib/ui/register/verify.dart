import 'package:awoof_app/networking/rest-data.dart';
import 'package:awoof_app/ui/register/signinemail.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/services.dart';
import 'package:awoof_app/utils/rflutter_alert-2.0.4/lib/rflutter_alert.dart';
//import 'package:rflutter_alert/rflutter_alert.dart';

class Verify extends StatefulWidget {

  static const String id = 'verify_screen_page';

  final String email;

  ///  1 for reset password, 2 for reset pin
  final int payload;

  const Verify({
    Key? key,
    required this.email,
    required this.payload
  }) : super(key: key);

  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {

  /// A [GlobalKey] to hold the form state of my form widget for form validation
  final _formKey = GlobalKey<FormState>();

  /// A [GlobalKey] to hold the form state of my form widget for pin form validation
  final _pinFormKey = GlobalKey<FormState>();

  /// A [TextEditingController] to control the input text for the user's password
  TextEditingController _passwordController = TextEditingController();

  /// A [TextEditingController] to control the input text for the user's confirm password
  TextEditingController _confirmPasswordController = TextEditingController();

  /// A [TextEditingController] to control the input text for the user's pin
  TextEditingController _pinController = TextEditingController();

  /// A [TextEditingController] to control the input text for the user's confirm pin
  TextEditingController _confirmPinController = TextEditingController();

  /// A boolean variable to hold the [inAsyncCall] value in my
  /// [ModalProgressHUD] widget
  bool _showSpinner = false;

  /// A boolean variable to hold whether the password should be shown or hidden
  bool _obscurePassTextLogin = true;

  /// A boolean variable to hold whether the confirm password should be shown or hidden
  bool _obscureConfirmPassTextLogin = true;


  TextEditingController one = TextEditingController();
  TextEditingController two = TextEditingController();
  TextEditingController three = TextEditingController();
  TextEditingController four = TextEditingController();
  FocusNode oneFocus = FocusNode();
  FocusNode twoFocus = FocusNode();
  FocusNode threeFocus = FocusNode();
  FocusNode fourFocus = FocusNode();

  /// Map to hold each number for transaction pin
  Map<int, String> _pin = {
    0: '', 1: '', 2: '', 3: '',
  };

  /// A string variable to hold your 4 digit transaction pin
  String _digitCode = '';

  @override
  void initState() {
    super.initState();
    oneFocus.requestFocus();
  }

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
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Color(0xFF1FD47D),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  /*Image.asset(
                    'assets/images/verify.png',
                    width: 304,
                    height: 202,
                    fit: BoxFit.contain,
                  ),*/
                  SizedBox(height: 15),
                  Text(
                    'Verify Your Email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF052328),
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Regular",
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: SizeConfig.screenWidth! * 0.8,
                    child: Text(
                      'Please enter the 4 digit code sent to ${widget.email}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff525252),
                        fontSize: 16,
                        fontFamily: "Regular",
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        width: 60,
                        height: 56,
                        child: TextFormField(
                          style: TextStyle(
                            color: Color(0xff000000),
                            fontSize: 16,
                            fontFamily: "Regular",
                          ),
                          maxLength: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          focusNode: oneFocus,
                          controller: one,
                          textAlign: TextAlign.center,
                          onChanged: (value){
                            if(!mounted) return;
                            setState(() {
                              _pin[0] = value;
                            });
                            if (one.text.length > 0) {
                              twoFocus.requestFocus();
                            }
                          },
                          decoration: InputDecoration(
                            counterText: '',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xffB9B9B9),
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(3),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(3),
                                bottomRight: Radius.circular(0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFF1FD47D),
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(3),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(3),
                                bottomRight: Radius.circular(0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 56,
                        child: TextFormField(
                          style: TextStyle(
                            color: Color(0xff000000),
                            fontSize: 16,
                            fontFamily: "Regular",
                          ),
                          maxLength: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          focusNode: twoFocus,
                          controller: two,
                          textAlign: TextAlign.center,
                          onChanged: (value){
                            if(!mounted) return;
                            setState(() {
                              _pin[1] = value;
                            });
                            if (two.text.length > 0) {
                              threeFocus.requestFocus();
                            }
                          },
                          decoration: InputDecoration(
                            counterText: '',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xffB9B9B9),
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFF1FD47D),
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 56,
                        child: TextFormField(
                          style: TextStyle(
                            color: Color(0xff000000),
                            fontSize: 16,
                            fontFamily: "Regular",
                          ),
                          maxLength: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          focusNode: threeFocus,
                          controller: three,
                          textAlign: TextAlign.center,
                          onChanged: (value){
                            if(!mounted) return;
                            setState(() {
                              _pin[2] = value;
                            });
                            if (three.text.length > 0) {
                              fourFocus.requestFocus();
                            }
                          },
                          decoration: InputDecoration(
                            counterText: '',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xffB9B9B9),
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFF1FD47D),
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 56,
                        child: TextFormField(
                          style: TextStyle(
                            color: Color(0xff000000),
                            fontSize: 16,
                            fontFamily: "Regular",
                          ),
                          maxLength: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          focusNode: fourFocus,
                          controller: four,
                          textAlign: TextAlign.center,
                          onChanged: (value){
                            if(!mounted) return;
                            setState(() {
                              _pin[3] = value;
                            });
                            if (four.text.length > 0) {
                              FocusScope.of(context).unfocus();
                            }
                          },
                          decoration: InputDecoration(
                            counterText: '',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xffB9B9B9),
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(3),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFF1FD47D),
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(3),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  widget.payload == 1
                      ? _buildForm()
                      : _buildPinForm(),
                  SizedBox(height: 45),
                  Container(
                    width: SizeConfig.screenWidth! * 0.85,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if(widget.payload == 1){
                          if(_formKey.currentState!.validate()){
                            if(!mounted)return;
                            setState(() {
                              _digitCode = _pin[0]! + _pin[1]! + _pin[2]! + _pin[3]!;
                            });
                            if(_digitCode.length != 4){
                              _resetControllers();
                              Constants.showError(context, 'Enter a valid 4 digit pin');
                            } else{
                              if(!mounted)return;
                              setState(() {
                                _showSpinner = true;
                              });
                              _resetPassword();
                            }
                          }
                        }
                        else {
                          if(_pinFormKey.currentState!.validate()){
                            if(!mounted)return;
                            setState(() {
                              _digitCode = _pin[0]! + _pin[1]! + _pin[2]! + _pin[3]!;
                            });
                            if(_digitCode.length != 4){
                              _resetControllers();
                              Constants.showError(context, 'Enter a valid 4 digit pin');
                            } else{
                              if(!mounted)return;
                              setState(() {
                                _showSpinner = true;
                              });
                              _resetPin();
                            }
                          }
                        }
                      },
                      child: _showSpinner
                          ? Center(
                        child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF)),
                        ),
                      )
                          : Center(
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: "Bold",
                            color: Colors.white,
                          ),
                        ),
                      ),
                      //color: Color(0xFF1FD47D),
                    ),
                  ),
                  SizedBox(height: 35),
                ],
              ),
            ),
            Container(
              height: SizeConfig.screenHeight,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: SizeConfig.screenWidth! * 0.316,
                      child: Image.asset(
                        'assets/images/one-left.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth! * 0.256,
                      child: Image.asset(
                        'assets/images/one-right.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Function to build form widget on our page that contains where user enter
  /// their password
  Widget _buildForm(){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 15),
          Container(
            width: SizeConfig.screenWidth! * 0.85,
            child: TextFormField(
              style: TextStyle(
                color: Color(0xff525252),
                fontSize: 16,
                fontFamily: "Regular",
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: _obscurePassTextLogin,
              controller: _passwordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter New Password';
                }
                if (value.length < 6){
                  return 'Password should be at least 6 characters';
                }
                return null;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'New Password',
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
                          color: Color(0xFF009B19).withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.lock_outline,
                          color: Color(0xFF1FD47D),
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: _togglePassLogin,
                  child: Icon(
                    _obscurePassTextLogin
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Color(0xFF1FD47D),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            width: SizeConfig.screenWidth! * 0.85,
            child: TextFormField(
              style: TextStyle(
                color: Color(0xff525252),
                fontSize: 16,
                fontFamily: "Regular",
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: _obscureConfirmPassTextLogin,
              controller: _confirmPasswordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Re-Enter New Password';
                }
                if (value != _passwordController.text){
                  return 'Password mismatch';
                }
                return null;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Re-Enter New Password',
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
                          color: Color(0xFF009B19).withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.lock_outline,
                          color: Color(0xFF1FD47D),
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: _toggleConfirmPassLogin,
                  child: Icon(
                    _obscureConfirmPassTextLogin
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Color(0xFF1FD47D),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Function to build form widget on our page that contains where user enter
  /// their password
  Widget _buildPinForm(){
    return Form(
      key: _pinFormKey,
      child: Column(
        children: [
          SizedBox(height: 15),
          Container(
            width: SizeConfig.screenWidth! * 0.85,
            child: TextFormField(
              style: TextStyle(
                color: Color(0xff525252),
                fontSize: 16,
                fontFamily: "Regular",
              ),
              keyboardType: TextInputType.numberWithOptions(),
              inputFormatters: [
                LengthLimitingTextInputFormatter(4),
              ],
              obscureText: _obscurePassTextLogin,
              controller: _pinController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter New Pin';
                }
                if (value.length != 4){
                  return 'Enter a valid 4 digit Pin';
                }
                return null;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'New Pin',
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
                suffixIcon: GestureDetector(
                  onTap: _togglePassLogin,
                  child: Icon(
                    _obscurePassTextLogin
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Color(0xFF1FD47D),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            width: SizeConfig.screenWidth! * 0.85,
            child: TextFormField(
              style: TextStyle(
                color: Color(0xff525252),
                fontSize: 16,
                fontFamily: "Regular",
              ),
              keyboardType: TextInputType.numberWithOptions(),
              inputFormatters: [
                LengthLimitingTextInputFormatter(4),
              ],
              obscureText: _obscureConfirmPassTextLogin,
              controller: _confirmPinController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Re-Enter New Pin';
                }
                if (value != _pinController.text){
                  return 'Pin mismatch';
                }
                return null;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Re-Enter New Pin',
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
                suffixIcon: GestureDetector(
                  onTap: _toggleConfirmPassLogin,
                  child: Icon(
                    _obscureConfirmPassTextLogin
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Color(0xFF1FD47D),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// A function to toggle if to show the password or not by
  /// changing [_obscurePassTextLogin] value
  void _togglePassLogin() {
    setState(() {
      _obscurePassTextLogin = !_obscurePassTextLogin;
    });
  }

  /// A function to toggle if to show the password or not by
  /// changing [_obscureConfirmPassTextLogin] value
  void _toggleConfirmPassLogin() {
    setState(() {
      _obscureConfirmPassTextLogin = !_obscureConfirmPassTextLogin;
    });
  }

  /// Function to reset all the pin input controllers
  void _resetControllers(){
    four.clear();
    three.clear();
    two.clear();
    one.clear();
  }

  /// Function to forget user's password by calling [resetPassword] in the
  /// RestDataSource class
  void _resetPassword(){
    var api = RestDataSource();
    api.resetPassword(widget.email, _passwordController.text, _digitCode).then((value) async {
      if(!mounted)return;
      setState(() {
        _showSpinner = false;
      });
      _showAlert(
          true,
          "Your password has been updated successfully",
          whereTo: (){
            Navigator.of(context).pushNamedAndRemoveUntil(SignInEmail.id, (Route<dynamic> route) => false);
          }
      );
    }).catchError((error) {
      if(!mounted)return;
      setState(() {
        _showSpinner = false;
      });
      _resetControllers();
      _showAlert(false, error);
    });
  }

  /// Function to reset user's pin by calling [resetPin] in the
  /// RestDataSource class
  void _resetPin(){
    var api = RestDataSource();
    api.resetPin(_pinController.text, _digitCode).then((value) async {
      if(!mounted)return;
      setState(() {
        _showSpinner = false;
      });
      _showAlert(
          true,
          "Your pin has been updated successfully",
          whereTo: (){
            Navigator.pop(context);
          }
      );
    }).catchError((error) {
      if(!mounted)return;
      setState(() {
        _showSpinner = false;
      });
      _resetControllers();
      _showAlert(false, error);
    });
  }

  void _showAlert(bool success, String desc, {Function? whereTo}){
       Alert(
      context: context,
      type: success ? AlertType.success : AlertType.error,
      title: success ? "Success" : "Failed",
      desc: desc,
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
