import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/database/user-db-helper.dart';
import 'package:awoof_app/model/user.dart';
import 'package:awoof_app/ui/register/forgot.dart';
import 'package:awoof_app/ui/register/login-screen-presenter.dart';
import 'package:awoof_app/ui/welcome.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awoof_app/push-notification-manager.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SignInPassword extends StatefulWidget {

  static const String id = 'sign_in_email';

  final String email;

  const SignInPassword({
    Key? key,
    required this.email
  }) : super(key: key);

  @override
  _SignInPasswordState createState() => _SignInPasswordState();
}

class _SignInPasswordState extends State<SignInPassword> implements LoginScreenContract {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A [GlobalKey] to hold the form state of my form widget for form validation
  final _formKey = GlobalKey<FormState>();

  /// A [TextEditingController] to control the input text for the user's password
  TextEditingController _passwordController = TextEditingController();

  /// An variable to hold an instance of [LoginScreenPresenter]
  LoginScreenPresenter? _presenter;

  /// Instantiating the [LoginScreenPresenter] class to handle the login requests
  _SignInPasswordState() {
    _presenter = LoginScreenPresenter(this);
  }

  /// A boolean variable to hold the [inAsyncCall] value in my
  /// [ModalProgressHUD] widget
  bool _showSpinner = false;

  /// A boolean variable to hold whether the password should be shown or hidden
  bool _obscurePassTextLogin = true;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AbsorbPointer(
      absorbing: _showSpinner,
      child: GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: Container(
          color: Colors.white,
          child: Stack(
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
              Scaffold(
                backgroundColor: Colors.transparent,
                resizeToAvoidBottomInset: true,
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
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 56),
                      Text(
                        'Please enter your password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff052328),
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Regular",
                        ),
                      ),
                      SizedBox(height: 17),
                      Container(
                        height: 36,
                        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(18),
                          ),
                          color: Color(0xFFDBF5E2),
                        ),
                        child: Text(
                          '${widget.email}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF2F7E57),
                            fontSize: 15,
                            fontFamily: "Regular",
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Form(
                        key: _formKey,
                        child: Container(
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
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp('[ ]')),
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter your password';
                              }
                              if (value.length < 6){
                                return 'Password should be at least 6 characters';
                              }
                              return null;
                            },
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Password',
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
                      ),
                      SizedBox(height: 26),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPassword(
                                email: widget.email,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'I forgot my password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff086237),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Regular",
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF1FD47D),
                          onPrimary: Color(0xFFFFFFFF),
                        ),
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            _submit();
                          }
                        },
                        child: Container(
                          width: SizeConfig.screenWidth! * 0.85,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          child: Center(
                            child: _showSpinner
                                ? CircularProgressIndicator(
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF)),
                            )
                                : Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Bold",
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 19),
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
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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

  /// A function to do the login process by calling the [doLogin] function in
  /// the [LoginScreenPresenter] class with the [_email] and [_password]
  void _submit() {
    setState(() => _showSpinner = true);
    _presenter!.doLogin(widget.email, _passwordController.text);
  }

  /// This function calls [_showInSnackBar()] to show a snackbar
  /// with details [errorTxt], then sets [_showSpinner] to false to stop syncing
  /// [ModalProgressHUD] and clears the [loginPasswordController] controller
  @override
  void onLoginError(String errorTxt) {
    if(!mounted)return;
    setState(() => _showSpinner = false);
    _passwordController.clear();
    Constants.showError(context, errorTxt);
  }

  /// This function sets [_showSpinner] to false to stop syncing
  /// [ModalProgressHUD] and clears both [_passwordController] controller
  /// It also saves the user's details in the database with the help of [DatabaseHelper]
  @override
  void onLoginSuccess(User user) async {
    if(!mounted)return;
    setState(() {
      _showSpinner = false;
    });
    _passwordController.clear();
    var db = DatabaseHelper();
    await db.initDb();
    await db.saveUser(user);
    addBoolToSF(true);
    /*if(user.email == 'testing2@yahoo.com'){
      var db = DatabaseHelper();
      await db.initDb();
      await db.saveUser(user);
      addBoolToSF(true);
    }
    else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PhoneVerification(
                user: user,
                payload: 2,
              ),
        ),
      );
    }*/
  }

  /// This function adds a true boolean value to the device [SharedPreferences]
  /// and clears both [_loginEmailController] and [_loginPasswordController] controllers
  addBoolToSF(bool state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', state);
    if (state == true){
      await _deleteFiles();
      Navigator.of(context).pushNamedAndRemoveUntil(Welcome.id, (Route<dynamic> route) => false);
      PushNotificationsManager().init();
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
