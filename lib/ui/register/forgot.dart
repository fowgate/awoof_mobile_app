import 'package:awoof_app/ui/register/verify.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:awoof_app/networking/rest-data.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/size-config.dart';

class ForgotPassword extends StatefulWidget {

  static const String id = 'forgot_password';

  final String email;

  const ForgotPassword({
    Key? key,
    required this.email
  }) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  /// A [GlobalKey] to hold the form state of my form widget for form validation
  final _formKey = GlobalKey<FormState>();

  /// A [TextEditingController] to control the input text for the user's email
  TextEditingController _emailController = TextEditingController();

  /// A boolean variable to hold the [inAsyncCall] value in my
  /// [ModalProgressHUD] widget
  bool _showSpinner = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _emailController.text = widget.email;
    });
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
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: SizeConfig.screenHeight! * 0.284,
                        child: Image.asset(
                          'assets/images/onboard4.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Forgot Password?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff052328),
                          fontSize: 22,
                          fontFamily: "Regular",
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: SizeConfig.screenWidth! * 0.8,
                        child: Text(
                          'Enter the email address associated with your account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff525252),
                            fontSize: 16,
                            fontFamily: "Regular",
                          ),
                        ),
                      ),
                      SizedBox(height: 35),
                      _buildForm(),
                      SizedBox(height: 25),
                      Container(
                        width: SizeConfig.screenWidth! * 0.85,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            if(_formKey.currentState!.validate()){
                              setState(() {
                                _showSpinner = true;
                              });
                              _forgetPassword();
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
                              'Reset Password',
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(){
    return Form(
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
          textInputAction: TextInputAction.done,
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
    );
  }

  /// Function to forget user's password by calling [forgetPassword] in the
  /// RestDataSource class
  void _forgetPassword(){
    var api = RestDataSource();
    api.forgetPassword(_emailController.text.toLowerCase(), 'password').then((value) async {
      if(!mounted)return;
      setState(() {
        _showSpinner = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Verify(
            email: _emailController.text,
            payload: 1,
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

}
