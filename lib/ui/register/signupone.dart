import 'package:awoof_app/model/create-user.dart';
import 'package:awoof_app/ui/register/signuptwo.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/my-widgets.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/networking/rest-data.dart';
import 'package:flutter/services.dart';

class SignUpOne extends StatefulWidget {

  static const String id = 'sign_up_one';

  @override
  _SignUpOneState createState() => _SignUpOneState();
}

class _SignUpOneState extends State<SignUpOne> {

  /// Instantiating a class of [FutureValues]
  var futureValue = FutureValues();

  /// A [GlobalKey] to hold the form state of my form widget for form validation
  final _formKey = GlobalKey<FormState>();

  /// A [TextEditingController] to control the input text for the user's first name
  TextEditingController _firstNameController = TextEditingController();

  /// A [TextEditingController] to control the input text for the user's last name
  TextEditingController _lastNameController = TextEditingController();

  /// A [TextEditingController] to control the input text for the user's email
  TextEditingController _emailController = TextEditingController();

  /// A [TextEditingController] to control the input text for the user's username
  TextEditingController _usernameController = TextEditingController();

  /// A [TextEditingController] to control the input text for the user's password
  TextEditingController _passwordController = TextEditingController();

  /// A [TextEditingController] to control the input text for the user's referral
  TextEditingController _referralController = TextEditingController();

  /// A boolean variable to hold whether the password should be shown or hidden
  bool _obscurePassTextLogin = true;

  /// A string variable to store the current address
  String? _currentAddress;

  _getCurrentLocation() async {
    await futureValue.getUserLocation().then((value) {
      if(value != null){
        if(!mounted)return;
        setState(() {
          _currentAddress = value;
        });
      }
    }).catchError((e){
      print(e);
    });
  }

  /// A boolean variable to hold the [inAsyncCall] value in my
  /// [ModalProgressHUD] widget
  bool _showSpinner = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

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
                backgroundColor: Colors.transparent,
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  backgroundColor: Colors.white,
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
                  title: Container(
                    width: 90,
                    child: Image.asset(
                      'assets/images/awoof-blue.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  centerTitle: true,
                  elevation: 0,
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFF1FD47D),
                          fontFamily: "Regular",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ]
                ),
                body: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 12),
                        Text(
                          '01 of 02',
                          style: TextStyle(
                            color: Color(0xFFC4C4C3),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Regular",
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Create Account',
                          style: TextStyle(
                            color: Color(0xff052328),
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Regular",
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: SizeConfig.screenWidth! - 40,
                          child: Text(
                            'Sign up with your account details to continue the experience',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF262626).withOpacity(0.8),
                              fontSize: 16,
                              fontFamily: "Regular",
                            ),
                          ),
                        ),
                        SizedBox(height: 49),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildForm(),
                            Container(
                              width: SizeConfig.screenWidth! * 0.85,
                              child: Button(
                                onTap: (){
                                  if(_formKey.currentState!.validate()){
                                    var user = CreateUser();
                                    user.location = _currentAddress == null
                                        ? 'not stated'
                                        : _currentAddress!.trim();
                                    //Constants.showInfo(context, 'Awoof would like to access your location to show giveaways in your area');
                                    user.referralCode = _referralController.text.isEmpty
                                        ? ''
                                        : _referralController.text;
                                    user.firstName = _firstNameController.text.trim();
                                    user.lastName = _lastNameController.text.trim();
                                    user.userName = _usernameController.text.trim().toLowerCase();
                                    user.email = _emailController.text.trim().toLowerCase();
                                    user.password = _passwordController.text;
                                    _checkUsernameAndEmail(user);
                                  }
                                },
                                width: SizeConfig.screenWidth! * 0.50,
                                radius: 5,
                                buttonColor: Color(0xFF1FD47D),
                                foregroundColor: Color(0xFF1FD47D),
                                child: _showSpinner
                                    ?  Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF)),
                                  ),
                                )
                                    : Center(
                                  child: Text(
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
                            SizedBox(height: 80),
                          ],
                        ),
                      ],
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

  /// Function to build form widget on our page that contains where user enter
  /// their details
  Widget _buildForm(){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            width: SizeConfig.screenWidth! * 0.85,
            child: TextFormField(
              style: TextStyle(
                color: Color(0xff525252),
                fontSize: 16,
                fontFamily: "Regular",
              ),
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
              ],
              controller: _firstNameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your first name';
                }
                if (value.length < 3){
                  return 'First name should be at least 3 characters';
                }
                return null;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'First Name',
                hintStyle: TextStyle(
                  color: Color(0xFF808998),
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
                          Icons.person_outline,
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
          SizedBox(height: 15),
          Container(
            width: SizeConfig.screenWidth! * 0.85,
            child: TextFormField(
              style: TextStyle(
                color: Color(0xff525252),
                fontSize: 16,
                fontFamily: "Regular",
              ),
              keyboardType: TextInputType.name,
              controller: _lastNameController,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
              ],
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your last name';
                }
                if (value.length < 3){
                  return 'Last name should be at least 3 characters';
                }
                return null;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Last Name',
                hintStyle: TextStyle(
                  color: Color(0xFF808998),
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
                          Icons.person_outline,
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
          SizedBox(height: 15),
          Container(
            width: SizeConfig.screenWidth! * 0.85,
            child: TextFormField(
              style: TextStyle(
                color: Color(0xff525252),
                fontSize: 16,
                fontFamily: "Regular",
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z_.]')),
              ],
              controller: _usernameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your username';
                }
                if (value.length < 2){
                  return 'User name should be at least 2 characters';
                }
                return null;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Username',
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
                            Radius.circular(5),
                          ),
                          color: Color(0xFF009B19).withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.alternate_email,
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
          SizedBox(height: 15),
          Container(
            width: SizeConfig.screenWidth! * 0.85,
            child: TextFormField(
              style: TextStyle(
                color: Color(0xff525252),
                fontSize: 16,
                fontFamily: "Regular",
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              controller: _emailController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your email';
                }
                if (value.length < 3 || !value.contains("@")){
                  return 'Invalid email address';
                }
                return null;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Email Address',
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
                            Radius.circular(5),
                          ),
                          color: Color(0xFF009B19).withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.mail_outline,
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
              textInputAction: TextInputAction.done,
              obscureText: _obscurePassTextLogin,
              controller: _passwordController,
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
          SizedBox(height: 15),
          Container(
            width: SizeConfig.screenWidth! * 0.85,
            child: TextFormField(
              style: TextStyle(
                color: Color(0xff525252),
                fontSize: 16,
                fontFamily: "Regular",
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              controller: _referralController,
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Referral Code (optional)',
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
                            Radius.circular(5),
                          ),
                          color: Color(0xFF009B19).withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.star_border,
                          color: Color(0xFF1FD47D),
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                suffixText: '+ 1(⭐)',
                suffixStyle: TextStyle(
                  color: Color(0xFFFFC430),
                  fontSize: 16,
                  fontFamily: "Regular",
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
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

  /// Function to validate username and email if it doesn't exist in the database
  /// If it's valid, it moves to [SignUpTwo] screen
  void _checkUsernameAndEmail(CreateUser user) async {
    if(!mounted)return;
    setState(() { _showSpinner = true; });
    var rest = RestDataSource();
    await rest.emailCheck(user.email!).then((value) async {
      await rest.usernameCheck(user.userName!).then((value) {
        if(!mounted)return;
        setState(() { _showSpinner = false; });
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => SignUpTwo(
              user: user,
              payload: 1,
              createUser: user
            ),
          ),
        );
      }).catchError((e){
        print(e);
        if(!mounted)return;
        setState(() { _showSpinner = false; });
        Constants.showError(context, e);
      });
    }).catchError((e){
      print(e);
      if(!mounted)return;
      setState(() { _showSpinner = false; });
      Constants.showError(context, e);
    });
  }

}
