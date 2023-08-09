import 'package:awoof_app/networking/rest-data.dart';
import 'package:awoof_app/ui/register/signinpassword.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:awoof_app/ui/register/signupone.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInEmail extends StatefulWidget {

  static const String id = 'sign_in_email';

  @override
  _SignInEmailState createState() => _SignInEmailState();
}

class _SignInEmailState extends State<SignInEmail> {

  /// A [GlobalKey] to hold the form state of my form widget for form validation
  final _formKey = GlobalKey<FormState>();

  /// A [TextEditingController] to control the input text for the user's email
  TextEditingController _emailController = TextEditingController();

  /// A boolean variable to hold the [inAsyncCall] value in my
  /// [ModalProgressHUD] widget
  bool _showSpinner = false;

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
        resizeToAvoidBottomInset: false,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 30, 12, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 56,
                          height: 48,
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => SignUpOne(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1FD47D),
                            fontFamily: "Regular",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 51),
                Text(
                  'Welcome back',
                  style: TextStyle(
                    color: Color(0xFF052328),
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Regular",
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  width: SizeConfig.screenWidth! * 0.8,
                  child: Text(
                    'Sign in with your account details to continue the experience',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF262626).withOpacity(0.8),
                      fontSize: 16,
                      fontFamily: "Regular",
                    ),
                  ),
                ),
                SizedBox(height: 35),
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
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter your email';
                        }
                        if (value.length < 3 || !value.contains("@")){
                          return 'Invalid Email Address';
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
                                    Radius.circular(6),
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
                ),
                SizedBox(height: 58),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF1FD47D),
                    onPrimary: Color(0xFFFFFFFF),
                  ),
                  onPressed: () {
                    if(_formKey.currentState!.validate()){
                      _checkEmail();
                    }
                  },
                  child: Container(
                    width: SizeConfig.screenWidth! * 0.85,
                    height: 56,
                    child: _showSpinner
                        ? Center(
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
                SizedBox(height: 49),
                /*Expanded(
                  child: Container(
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          SizeConfig.screenWidth * 0.15,
                        ),
                        topRight: Radius.circular(
                          SizeConfig.screenWidth * 0.15,
                        ),
                      ),
                      color: Color.fromRGBO(229, 229, 229, 0.2),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Our Socials',
                              style: TextStyle(
                                color: Color(0xff4C5A79),
                                fontSize: 16,
                                fontFamily: "Regular",
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                SocialContainer(
                                  text: 'Instagram',
                                  url: 'assets/images/instagram.png',
                                  onPressed: (){
                                    _launchURL('https://www.instagram.com/awoofapp');
                                  },
                                ),
                                SocialContainer(
                                  text: 'Twitter',
                                  url: 'assets/images/twitter.png',
                                  onPressed: (){
                                    _launchURL('https://www.twitter.com/awoofapp');
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Center(
                              child: SocialContainer(
                                text: 'Facebook',
                                url: 'assets/images/f.png',
                                onPressed: (){
                                  _launchURL('https://www.facebook.com/PhilantroTech');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )*/
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Function to launch [url] on a browser or app
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Constants.showError(context, 'Could not launch $url');
    }
  }

  /// Function to validate email if it doesn't exist in the database
  /// If it's valid, it moves to [SignUpTwo] screen
  void _checkEmail() async {
    if(!mounted)return;
    setState(() { _showSpinner = true; });
    var rest = RestDataSource();
    await rest.emailCheck(_emailController.text.toLowerCase().trim()).then((value) async {
      if(!mounted)return;
      setState(() { _showSpinner = false; });
      Constants.showError(context, 'Email does not exist');
    }).catchError((e){
      print(e);
      if(!mounted)return;
      setState(() { _showSpinner = false; });
      if(e.toString().toLowerCase().contains('email already exists')){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SignInPassword(email: _emailController.text.toLowerCase().trim()),
          ),
        );
      }
      else {
        Constants.showError(context, e);
      }
    });
  }

}
