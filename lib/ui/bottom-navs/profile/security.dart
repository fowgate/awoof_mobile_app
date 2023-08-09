import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/networking/rest-data.dart';
import 'package:awoof_app/ui/register/signuppin.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/material.dart';
import 'package:awoof_app/utils/rflutter_alert-2.0.4/lib/rflutter_alert.dart';
//import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:awoof_app/ui/register/verify.dart';

class Security extends StatefulWidget {

  static const String id = 'security_page';

  @override
  _SecurityState createState() => _SecurityState();
}

class _SecurityState extends State<Security> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A [GlobalKey] to hold the form state of my form widget for form validation
  final _formKey = GlobalKey<FormState>();

  /// Text Editing Controllers for the password input
  TextEditingController _oldPassword = TextEditingController();
  TextEditingController _newPassword = TextEditingController();

  /// Text Editing Controllers and focus nodes for the old pin input
  TextEditingController _one = TextEditingController();
  TextEditingController _two = TextEditingController();
  TextEditingController _three = TextEditingController();
  TextEditingController _four = TextEditingController();
  FocusNode _oneFocus = FocusNode();
  FocusNode _twoFocus = FocusNode();
  FocusNode _threeFocus = FocusNode();
  FocusNode _fourFocus = FocusNode();

  /// Text Editing Controllers and focus nodes for the new pin input
  TextEditingController _oneNew = TextEditingController();
  TextEditingController _twoNew = TextEditingController();
  TextEditingController _threeNew = TextEditingController();
  TextEditingController _fourNew = TextEditingController();
  FocusNode _oneFocusNew = FocusNode();
  FocusNode _twoFocusNew = FocusNode();
  FocusNode _threeFocusNew = FocusNode();
  FocusNode _fourFocusNew = FocusNode();

  /// Map to hold each number for transaction pin
  Map<int, String> _pin = {
    0: '', 1: '', 2: '', 3: '',
    4: '', 5: '', 6: '', 7: ''
  };

  /// Variable to hold true or false if the pin input should be obscured
  bool _obscurePin = true;

  /// A string variable to hold your 4 digit current transaction pin
  String _currentPin = '';

  /// A string variable to hold your 4 digit new transaction pin
  String _newTransactionPin = '';

  /// Variable to hold true or false if the pin is checked
  bool _pinChecked = false;

  /// An integer value holding the state of the button
  int _state = 0;

  /// A string variable to hold user email
  String? _userEmail;

  /// Setting the current user's isPinSet in to [_isPinSet]
  void _getCurrentUser() async {
    await futureValue.updateUser();
    await futureValue.getCurrentUser().then((user) {
      if(!mounted)return;
      setState(() {
        _userEmail = user!.email;
        if(!user.isPinSet!){
          Navigator.pushNamed(context, SignUpPin.id);
        }
        _pinChecked = true;
      });
    }).catchError((Object error) {
      print(error);
      Constants.showError(context, error.toString());
    });
  }

  /// A boolean variable to hold the [inAsyncCall] value in my
  /// [ModalProgressHUD] widget
  bool _showSpinner = false;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    //_oneFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus){
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
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
              Icons.arrow_back_ios,
              size: 20,
              color: Color(0XFF060D25),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: (!_pinChecked)
          ? Container(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        )
          : ModalProgressHUD(
            inAsyncCall: _showSpinner,
            progressIndicator: CircularProgressIndicator(
               valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1FD47D)),
            ),
            child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 15),
                    _buildChangePassword(),
                    SizedBox(height: 35),
                    _buildChangePin(),
                    /*Text(
                      'Security Question',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Regular',
                        color: Color(0XFF727784),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'What is your Mother’s maiden name?',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Regular',
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 56,
                      child: TextFormField(
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Regular",
                        ),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Enter Answer',
                          hintStyle: TextStyle(
                            color: Color(0xFFB4B6BE),
                            fontSize: 16,
                            fontFamily: "Regular",
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFFB4B6BE),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ),*/
                    SizedBox(height: 30),
                    TextButton(
                      onPressed: () {
                        _forgetPin();
                      },
                      child: Text(
                        'I forgot my pin',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Regular",
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 56,
                      child: _setUpButton(),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
        ),
          ),
      ),
    );
  }

  Widget _buildChangePassword(){
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Change Account Password',
            style: TextStyle(
              fontSize: 17,
              fontFamily: 'Regular',
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF),
            ),
          ),
          SizedBox(height: 25),
          Text(
            'Current Password',
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Regular',
              color: Color(0XFFB1B3BB),
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            child: TextFormField(
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "Regular",
              ),
              keyboardType: TextInputType.visiblePassword,
              controller: _oldPassword,
              validator: (value) {
                if(value == null || value.length < 4){
                  return 'Old password should not be empty';
                }
                return null;
              },
              obscureText: true,
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Old Password',
                hintStyle: TextStyle(
                  color: Color(0xff808998),
                  fontSize: 16,
                  fontFamily: "Regular",
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'New Password',
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Regular',
              color: Color(0XFFB1B3BB),
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            child: TextFormField(
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "Regular",
              ),
              keyboardType: TextInputType.visiblePassword,
              controller: _newPassword,
              obscureText: true,
              validator: (value) {
                if(value == null || value.length < 6){
                  return 'New password should be at least 6 characters';
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangePin(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Change Transaction Pin',
          style: TextStyle(
            fontSize: 17,
            fontFamily: 'Regular',
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Old Pin',
          style: TextStyle(
            fontSize: 13.5,
            fontFamily: 'Regular',
            color: Color(0xFFFFFFFF),
          ),
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 45,
              height: 50,
              child: TextFormField(
                style: TextStyle(
                  color: Color(0xffFFFFFF),
                  fontSize: 16,
                  fontFamily: "Regular",
                ),
                keyboardType: TextInputType.number,
                maxLength: 1,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                focusNode: _oneFocus,
                controller: _one,
                textAlign: TextAlign.center,
                obscureText: _obscurePin,
                onChanged: (value){
                  if(!mounted) return;
                  setState(() {
                    _pin[0] = value;
                  });
                  if (_one.text.length > 0) {
                    _twoFocus.requestFocus();
                  }
                },
                decoration: kTextPinDecoration,
              ),
            ),
            SizedBox(width: 12),
            Container(
              width: 45,
              height: 50,
              child: TextFormField(
                style: TextStyle(
                  color: Color(0xffFFFFFF),
                  fontSize: 16,
                  fontFamily: "Regular",
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                focusNode: _twoFocus,
                controller: _two,
                textAlign: TextAlign.center,
                obscureText: _obscurePin,
                maxLength: 1,
                onChanged: (value){
                  if(!mounted) return;
                  setState(() {
                    _pin[1] = value;
                  });
                  if (_two.text.length > 0) {
                    _threeFocus.requestFocus();
                  }
                },
                decoration: kTextPinDecoration,
              ),
            ),
            SizedBox(width: 12),
            Container(
              width: 45,
              height: 50,
              child: TextFormField(
                style: TextStyle(
                  color: Color(0xffFFFFFF),
                  fontSize: 16,
                  fontFamily: "Regular",
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                focusNode: _threeFocus,
                controller: _three,
                textAlign: TextAlign.center,
                obscureText: _obscurePin,
                maxLength: 1,
                onChanged: (value){
                  if(!mounted) return;
                  setState(() {
                    _pin[2] = value;
                  });
                  if (_three.text.length > 0) {
                    _fourFocus.requestFocus();
                  }
                },
                decoration: kTextPinDecoration,
              ),
            ),
            SizedBox(width: 12),
            Container(
              width: 45,
              height: 50,
              child: TextFormField(
                style: TextStyle(
                  color: Color(0xffFFFFFF),
                  fontSize: 16,
                  fontFamily: "Regular",
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                focusNode: _fourFocus,
                controller: _four,
                textAlign: TextAlign.center,
                obscureText: _obscurePin,
                maxLength: 1,
                onChanged: (value){
                  if(!mounted) return;
                  setState(() {
                    _pin[3] = value;
                  });
                  if (_four.text.length > 0) {
                    FocusScope.of(context).unfocus();
                  }
                },
                decoration: kTextPinDecoration,
              ),
            ),
          ],
        ),
        SizedBox(height: 25),
        Text(
          'New Pin',
          style: TextStyle(
            fontSize: 13.5,
            fontFamily: 'Regular',
            color: Color(0xFFFFFFFF),
          ),
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 45,
              height: 50,
              child: TextFormField(
                style: TextStyle(
                  color: Color(0xffFFFFFF),
                  fontSize: 16,
                  fontFamily: "Regular",
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                focusNode: _oneFocusNew,
                controller: _oneNew,
                textAlign: TextAlign.center,
                obscureText: _obscurePin,
                maxLength: 1,
                onChanged: (value){
                  if(!mounted) return;
                  setState(() {
                    _pin[4] = value;
                  });
                  if (_oneNew.text.length > 0) {
                    _twoFocusNew.requestFocus();
                  }
                },
                decoration: kTextPinDecoration,
              ),
            ),
            SizedBox(width: 12),
            Container(
              width: 45,
              height: 50,
              child: TextFormField(
                style: TextStyle(
                  color: Color(0xffFFFFFF),
                  fontSize: 16,
                  fontFamily: "Regular",
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                focusNode: _twoFocusNew,
                controller: _twoNew,
                textAlign: TextAlign.center,
                obscureText: _obscurePin,
                maxLength: 1,
                onChanged: (value){
                  if(!mounted) return;
                  setState(() {
                    _pin[5] = value;
                  });
                  if (_twoNew.text.length > 0) {
                    _threeFocusNew.requestFocus();
                  }
                },
                decoration: kTextPinDecoration,
              ),
            ),
            SizedBox(width: 12),
            Container(
              width: 45,
              height: 50,
              child: TextFormField(
                style: TextStyle(
                  color: Color(0xffFFFFFF),
                  fontSize: 16,
                  fontFamily: "Regular",
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                focusNode: _threeFocusNew,
                controller: _threeNew,
                textAlign: TextAlign.center,
                obscureText: _obscurePin,
                maxLength: 1,
                onChanged: (value){
                  if(!mounted) return;
                  setState(() {
                    _pin[6] = value;
                  });
                  if (_threeNew.text.length > 0) {
                    _fourFocusNew.requestFocus();
                  }
                },
                decoration: kTextPinDecoration,
              ),
            ),
            SizedBox(width: 12),
            Container(
              width: 45,
              height: 50,
              child: TextFormField(
                style: TextStyle(
                  color: Color(0xffFFFFFF),
                  fontSize: 16,
                  fontFamily: "Regular",
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                focusNode: _fourFocusNew,
                controller: _fourNew,
                textAlign: TextAlign.center,
                obscureText: _obscurePin,
                maxLength: 1,
                onChanged: (value){
                  if(!mounted) return;
                  setState(() {
                    _pin[7] = value;
                  });
                  if (_fourNew.text.length > 0) {
                    FocusScope.of(context).unfocus();
                  }
                },
                decoration: kTextPinDecoration,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Function to set up button states in sync with [_state]
  Widget _setUpButton(){
    if(_state == 0){
      return ElevatedButton(
        //color: Color(0xFF1FD47D),
        onPressed: () {
          if((_oldPassword.text.isNotEmpty || _newPassword.text.isNotEmpty) && _pin.values.every((element) => element == '')){
            if(_formKey.currentState!.validate()){
              if(!mounted)return;
              setState(() {
                _state = 1;
              });
              _changePassword();
            }
          }
          else if(_pin.values.every((element) => element != '') && _oldPassword.text.isEmpty && _newPassword.text.isEmpty){
            if(!mounted)return;
            setState(() {
              _currentPin = _pin[0]! + _pin[1]! + _pin[2]! + _pin[3]!;
              _newTransactionPin = _pin[4]! + _pin[5]! + _pin[6]! + _pin[7]!;
              _state = 1;
            });
            _changePin();
          }
          else if(_oldPassword.text.isNotEmpty || _newPassword.text.isNotEmpty
              && _pin.values.every((element) => element != '')
          ){
            _resetControllers();
            Constants.showError(context, 'You can only change Password or Pin once at a time.\nClear unused fields.');
          }
          else {
            _resetControllers();
            Constants.showError(context, 'Please fill in the details you want to change');
          }
        },
        child: Text(
          'Save Changes',
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
    else {
      return Icon(
        Icons.check,
        color: Colors.white,
        size: 20,
      );
    }
  }

  /// Function to reset all the pin input controllers
  void _resetControllers(){
    _four.clear();
    _three.clear();
    _two.clear();
    _one.clear();
    _fourNew.clear();
    _threeNew.clear();
    _twoNew.clear();
    _oneNew.clear();
    if(!mounted)return;
    setState(() {
      _currentPin = '';
      _newTransactionPin = '';
      _pin.forEach((key, value) {
        _pin[key] = '';
      });
    });
  }

  /// Function that changes a user's password by calling
  /// [changePassword] in the [RestDataSource] class
  void _changePassword() async {
    var api = RestDataSource();
    await api.changePassword(_oldPassword.text, _newPassword.text).then((value) {
      if(!mounted)return;
      setState(() {
        _state = 0;
      });
      _oldPassword.clear();
      _newPassword.clear();
      _showAlert(true, 'Password changed successfully');
    }).catchError((error) {
      if(!mounted)return;
      setState(() {
        _state = 0;
      });
      _oldPassword.clear();
      _newPassword.clear();
      print(error);
      _showAlert(false, error);
    });
  }

  /// Function that changes a user transaction pin by calling
  /// [changePin] in the [RestDataSource] class
  void _changePin() async {
    var api = RestDataSource();
    print(_currentPin);
    print(_newTransactionPin);
    await api.changePin(_currentPin, _newTransactionPin).then((value) {
      if(!mounted)return;
      setState(() {
        _state = 0;
      });
      _resetControllers();
      _showAlert(true, 'Transaction pin changed successfully');
    }).catchError((error) {
      if(!mounted)return;
      setState(() {
        _state = 0;
      });
      _resetControllers();
      print(error);
      _showAlert(false, error);
    });
  }

  /// Function to forget user's pin by calling [forgetPassword] in the
  /// RestDataSource class
  void _forgetPin(){
    if(!mounted)return;
    setState(() {
      _showSpinner = true;
    });
    var api = RestDataSource();
    api.forgetPassword(_userEmail!, 'pin').then((value) async {
      if(!mounted)return;
      setState(() {
        _showSpinner = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Verify(
            email: _userEmail!,
            payload: 2,
          ),
        ),
      );
    }).catchError((error) {
      if(!mounted)return;
      setState(() {
        _showSpinner = false;
      });
      Constants.showError(context, error);
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
