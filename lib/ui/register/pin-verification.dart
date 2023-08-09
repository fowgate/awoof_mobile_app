import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/database/user-db-helper.dart';
import 'package:awoof_app/model/user.dart';
import 'package:awoof_app/model/create-user.dart';
import 'package:awoof_app/networking/rest-data.dart';
import 'package:awoof_app/ui/welcome.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:awoof_app/ui/register/signuppin.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awoof_app/push-notification-manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// A stateful widget to verify your phone number with the code sent to your sms
class PhoneVerification extends StatefulWidget {

  static const String id = 'pin_verification_page';

  /// The details of the current logged in user
  // final User user;

  final CreateUser createUser;

  /// This value holds number for which the page is navigating from
  /// 1 for [SignUp]
  /// 2 for [SignIn]
  final int payload;

  const PhoneVerification({
    Key? key,
    required this.payload,
    required this.createUser,
    // @required this.user
  }) : super(key: key);

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {

  /// Setting a timer object
  Timer? _timer;

  /// An integer variable to hold my time in seconds
  int? _seconds;

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A boolean variable to hold the [inAsyncCall] value in my
  /// [ModalProgressHUD] widget
  bool _showSpinner = false;

  /// Text Editing Controller and focus nodes for the pin input
  TextEditingController _one = TextEditingController();
  TextEditingController _two = TextEditingController();
  TextEditingController _three = TextEditingController();
  TextEditingController _four = TextEditingController();
  TextEditingController _five = TextEditingController();
  TextEditingController _six = TextEditingController();
  FocusNode _oneFocus = FocusNode();
  FocusNode _twoFocus = FocusNode();
  FocusNode _threeFocus = FocusNode();
  FocusNode _fourFocus = FocusNode();
  FocusNode _fiveFocus = FocusNode();
  FocusNode _sixFocus = FocusNode();

  /// Boolean variable to hide pin or not
  bool _obscurePin = false;

  /// Map to hold each number for transaction pin
  Map<int, String> _pin = {
    0: '', 1: '', 2: '', 3: '', 4: '', 5: ''
  };

  /// A string variable to hold your 4 digit transaction pin
  String _confirmPin = '';

  double _pinWidth = 42;

  double _pinHeight = 68;

  /// String variable to hold the phone number of the user logged in
  String? _phoneNumber;

  /// String variable to hold the encrypted phone number of the user logged in
  String? _encryptedPhoneNumber;

  bool _timeOut = false;

  bool _show = false;

  bool _sentToEmail = false;

  int _codeTrial = 1;

  /// Setting the current user's phoneNumber logged in to [_phoneNumber] and also
  /// encrypting the phone number to [_encryptedPhoneNumber]
  void _getCurrentUser()  {
    if(!mounted)return;
    setState(() {
      _phoneNumber = widget.createUser.phone;
      var first3 = _phoneNumber!.substring(0, 3);
      var last3 = _phoneNumber!.substring(_phoneNumber!.length - 3);
      _encryptedPhoneNumber = '${first3}X XXX X$last3';
    });
  }

  String _constructTime(int seconds) {
    int second = seconds % 60;
    return _formatTime(second);
  }

  /// Digital formatting, converting 0-9 time to 00-09
  String _formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }

  /// Function to set details of the timer
  void _setTimer(){
    var now = DateTime.now();
    // Get a 30-seconds interval
    var thirtySeconds = now.add(Duration(seconds: 30)).difference(now);
    // Get the total number of seconds, 1 minute for 60 seconds
    if(!mounted)return;
    setState(() {
      _seconds = thirtySeconds.inSeconds;
    });
    _startTimer();
  }

  @override
  void initState() {
    super.initState();
    _setTimer();
    _getCurrentUser();
    _oneFocus.requestFocus();
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
        backgroundColor:  Colors.white,
        body: Stack(
          children: <Widget>[
            Container(
              height: SizeConfig.screenHeight,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: SizeConfig.screenWidth! * 0.16,
                      child: Image.asset(
                        'assets/images/two-left.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth! * 0.42,
                      child: Image.asset(
                        'assets/images/two-right.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                width: SizeConfig.screenWidth,
                padding: EdgeInsets.fromLTRB(15, 35, 15, 0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(12, 30, 12, 0),
                        child: Center(
                          child: Container(
                            width: 56,
                            height: 48,
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 48),
                      Text(
                        'Check your phone',
                        style: TextStyle(
                          color: Color(0xFF052328),
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Regular",
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: SizeConfig.screenWidth! - 37,
                        child: Text(
                          _sentToEmail
                              ? 'A six digit code has been sent to ${widget.createUser.email}'
                              : 'A six digit code has been sent to $_encryptedPhoneNumber',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF262626).withOpacity(0.8),
                            fontSize: 16,
                            fontFamily: "Regular",
                          ),
                        ),
                      ),
                      SizedBox(height: 49),
                      Text(
                        'Enter PIN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF052328).withOpacity(0.3),
                          fontFamily: 'Regular',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 7),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: _pinWidth,
                            height: _pinHeight,
                            child: TextFormField(
                              style: kPinTextStyle,
                              keyboardType: TextInputType.number,
                              focusNode: _oneFocus,
                              controller: _one,
                              textAlign: TextAlign.center,
                              obscureText: _obscurePin,
                              maxLength: 1,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
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
                          SizedBox(width: 10),
                          Container(
                            width: _pinWidth,
                            height: _pinHeight,
                            child: TextFormField(
                              style: kPinTextStyle,
                              keyboardType: TextInputType.number,
                              focusNode: _twoFocus,
                              controller: _two,
                              textAlign: TextAlign.center,
                              obscureText: _obscurePin,
                              maxLength: 1,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
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
                          SizedBox(width: 10),
                          Container(
                            width: _pinWidth,
                            height: _pinHeight,
                            child: TextFormField(
                              style: kPinTextStyle,
                              keyboardType: TextInputType.number,
                              focusNode: _threeFocus,
                              controller: _three,
                              textAlign: TextAlign.center,
                              obscureText: _obscurePin,
                              maxLength: 1,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
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
                          SizedBox(width: 10),
                          Container(
                            width: _pinWidth,
                            height: _pinHeight,
                            child: TextFormField(
                              style: kPinTextStyle,
                              keyboardType: TextInputType.number,
                              focusNode: _fourFocus,
                              controller: _four,
                              textAlign: TextAlign.center,
                              obscureText: _obscurePin,
                              maxLength: 1,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value){
                                if(!mounted) return;
                                setState(() {
                                  _pin[3] = value;
                                });
                                if (_four.text.length > 0) {
                                  _fiveFocus.requestFocus();
                                }
                              },
                              decoration: kTextPinDecoration,
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: _pinWidth,
                            height: _pinHeight,
                            child: TextFormField(
                              style: kPinTextStyle,
                              keyboardType: TextInputType.number,
                              focusNode: _fiveFocus,
                              controller: _five,
                              textAlign: TextAlign.center,
                              obscureText: _obscurePin,
                              maxLength: 1,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value){
                                if(!mounted) return;
                                setState(() {
                                  _pin[4] = value;
                                });
                                if (_five.text.length > 0) {
                                  _sixFocus.requestFocus();
                                }
                              },
                              decoration: kTextPinDecoration,
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: _pinWidth,
                            height: _pinHeight,
                            child: TextFormField(
                              style: kPinTextStyle,
                              keyboardType: TextInputType.number,
                              focusNode: _sixFocus,
                              controller: _six,
                              textAlign: TextAlign.center,
                              obscureText: _obscurePin,
                              maxLength: 1,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value){
                                if(!mounted) return;
                                setState(() {
                                  _pin[5] = value;
                                });
                                if (_five.text.length > 0) {
                                  FocusScope.of(context).unfocus();
                                }
                              },
                              decoration: kTextPinDecoration,
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                      SizedBox(height: 30),
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _timeOut
                                    ? _show ? TextButton(
                            onPressed: (){
                      _resendCodeToEmail();
                      },
                        child: Text(
                          'Try your Email',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 15,
                            fontFamily: "Regular",
                            color: Color(0xFF1FD47D),
                          ),
                        ),
                      ) : Container()
                                    : _show ? TextButton(
                                  onPressed: (){
                                    _resendCode();
                                  },
                                  child: Text(
                                    'Resend Code',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 15,
                                      fontFamily: "Regular",
                                      color: Color(0xFF1FD47D),
                                    ),
                                  ),
                                ) : Container(),

                                Text(
                                  _constructTime(_seconds!),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Regular',
                                    color: Color(0xFF1FD47D),
                                  ) ,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 70),
                      GestureDetector(
                        onTap: (){
                          if(!mounted)return;
                          setState(() {
                            _confirmPin = _pin[0]! + _pin[1]! + _pin[2]! + _pin[3]! + _pin[4]! + _pin[5]!;
                            _showSpinner = true;
                          });
                          _createUser();
                          //_verifyCode(_confirmPin);
                        },
                        child: Container(
                          width: SizeConfig.screenWidth,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            color: Color(0xFF1FD47D),
                          ),
                          child: Center(
                            child: _showSpinner
                                ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF)),
                            )
                                : Text(
                              'Activate My Account',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Extra",
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Function to start the 60 seconds timer
  void _startTimer() {
    // Set 1 second callback
    const period = Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      // Update interface
      if(!mounted)return;
      setState(() {
        // minus one second because it calls back once a second
        _seconds= _seconds!-1;
      });
      if (_seconds == 0) {
        // Countdown seconds 0, cancel timer
        if(!mounted)return;
        setState(() {
          _show = true;
        });
        _cancelTimer();
      }
    });
  }

  /// Function to cancel timer
  void _cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _cancelTimer();
  }

  /// Function that re-sends 2 fa code by calling [twoFaResend] in
  /// the [RestDataSource] class
  Future<void> _resendCode() async {
    var api = RestDataSource();
    await api.twoFaResend(_phoneNumber!).then((value) async {
      setState(() {
        _show = false;
        if(_codeTrial >= 1){
          _timeOut = true;
        }
        else {
          _codeTrial += 1;
        }
      });
      _cancelTimer();
      _resetControllers();
      _setTimer();
      Constants.showInfo(context, "Code has been sent to your number again");
    }).catchError((error) {
      print(error);
      Constants.showError(context, error);
    });
  }

  /// Function that re-sends 2fa code by calling [twoFaResendEmail] in
  /// the [RestDataSource] class
  Future<void> _resendCodeToEmail() async {
    var api = RestDataSource();
    await api.twoFaResendEmail(_phoneNumber!, widget.createUser.email!).then((value) async {
      _cancelTimer();
      _resetControllers();
      _setTimer();
      if(!mounted)return;
      setState(() {
        _show = false;
        _sentToEmail = true;
      });
      Constants.showInfo(context, "Code has been sent to your email");
    }).catchError((e) {
      print(e);
      Constants.showError(context, e);
    });
  }

  /// Function to reset all the pin input controllers
  void _resetControllers(){
    _six.clear();
    _five.clear();
    _four.clear();
    _three.clear();
    _two.clear();
    _one.clear();
  }

  /// Function that verifies the 2 factor authentication if the code inputted
  /// is correct by calling [twoFaVerify] in the [RestDataSource] class
  Future<void> _verifyCode(String token) async {
    var api = RestDataSource();
    await api.twoFaVerify(_phoneNumber!, token).then((value) async {
      _cancelTimer();
      _createUser();
    }).catchError((error) {
      if(!mounted)return;
      setState(() { _showSpinner = false; });
      print(error);
      Constants.showError(context, error);
    });
  }

  /// Function that creates a new user by calling
  /// [signUp] in the [RestDataSource] class
  void _createUser() async {
    var api = RestDataSource();
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? token = await firebaseMessaging.getToken();
    await api.signUp(widget.createUser, token!).then((User user) async {
      if(!mounted)return;
      setState(() { _showSpinner = false; });
      var db = DatabaseHelper();
      await db.initDb();
      await db.saveUser(user);
      _addBoolToSF(true);
    }).catchError((error) {
      if(!mounted)return;
      setState(() { _showSpinner = false; });
      Constants.showError(context, error);
    });
  }

  /// This function adds a [state] boolean value to the device
  /// [SharedPreferences] logged in
  _addBoolToSF(bool state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', state);
    await _deleteFiles();
    if (state == true && widget.payload == 1){
      PushNotificationsManager().init();
      Navigator.of(context).pushNamedAndRemoveUntil(SignUpPin.id, (Route<dynamic> route) => false);
    }
    else if (state == true && widget.payload == 2){
      PushNotificationsManager().init();
      Navigator.of(context).pushNamedAndRemoveUntil(Welcome.id, (Route<dynamic> route) => false);
    }
  }

  /// Function to delete all cached files
  Future<void> _deleteFiles() async {
    var dir = await getTemporaryDirectory();
    File giveawayFile = File(dir.path + "/giveaways.json");
    if(giveawayFile.existsSync()) { giveawayFile.deleteSync(); }

    File winnersFile = File(dir.path + "/winners.json");
    if(winnersFile.existsSync()) { winnersFile.deleteSync(); }

    File topGiversFile = File(dir.path + "/givers.json ");
    if(topGiversFile.existsSync()) { topGiversFile.deleteSync(); }

    File allGiversFile = File(dir.path + "/allGivers.json");
    if(allGiversFile.existsSync()) { allGiversFile.deleteSync(); }

  }

}
