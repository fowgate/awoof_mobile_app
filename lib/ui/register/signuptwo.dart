import 'dart:async';
import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/model/create-user.dart';
import 'package:awoof_app/model/user.dart';
import 'package:awoof_app/networking/rest-data.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/dob-input-formatter.dart';
import 'package:awoof_app/utils/dob-utils.dart';
import 'package:awoof_app/utils/my-widgets.dart';
import 'package:awoof_app/utils/photo-permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:awoof_app/database/user-db-helper.dart';
import 'package:awoof_app/push-notification-manager.dart';
import 'package:awoof_app/ui/register/signuppin.dart';
import 'package:awoof_app/ui/welcome.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'dart:io';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'package:awoof_app/ui/bottom-navs/home/giveaway/giveaway-links.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'pin-verification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SignUpTwo extends StatefulWidget {

  static const String id = 'sign_up_two';

  final CreateUser user;
  final int payload;
  final CreateUser createUser;

  const SignUpTwo({
    Key? key,
    required this.payload,
    required this.user,
    required this.createUser,
  // @required this.use
  }) : super(key: key);


  @override
  _SignUpTwoState createState() => _SignUpTwoState();
}


class _SignUpTwoState extends State<SignUpTwo> {

  /// Instantiating a class of [FutureValues]
  var futureValue = FutureValues();

  /// A [GlobalKey] to hold the form state of my form widget for form validation
  final _formKey = GlobalKey<FormState>();


  File? _image;

  /// Boolean variable holding the auto validate
  var _autoValidate = false;

  /// A list of string holding the available gender for the drop down
  List<String> _gender = [
    'Male',
    'Female',
    'Other',
  ];

  /// A string variable holding the selected gender
  String? _selectedGender;

  /// A [TextEditingController] to control the input text for the user's phone
  TextEditingController _phoneController = TextEditingController();

  /// A string variable to hold the initial country code which is Nigeria
  String _initialCountry = 'NG';

  /// A PhoneNumber variable from InternationalPhoneNumberInput package to hold
  /// the phone number details
  PhoneNumber _number = PhoneNumber(isoCode: 'NG');

  /// A [TextEditingController] to control the input text for the user's date of birth
  TextEditingController _dobController = TextEditingController();

  /// A string variable holding the date of birth
  String? _dateOfBirth;

  /// A boolean variable to hold the [inAsyncCall] value in my
  /// [ModalProgressHUD] widget
  bool _showSpinner = false;

  /// A boolean variable showing if terms ans conditions is accepted or not
  bool _terms = false;

  /// A list of Asset to store all images
  List<Asset> images = [];

  /// A list of Asset to store all selected
  List<Asset> resultList = [];

  /// Function that creates a new user by calling
  /// [signUp] in the [RestDataSource] class
  void _createUser() async {
    print('bad');
    List<http.MultipartFile> uploads = [];
    widget.user.phone = _number.phoneNumber!.trim();
    widget.user.dateOfBirth = _dateOfBirth!.trim();
    widget.user.gender = _selectedGender!.trim();
    if (widget.user.referralCode== null) {
      widget.user.referralCode= 'nil';
    } 
    if (_image != null) {
      uploads.add(
        await http.MultipartFile.fromPath("image", _image!.path, filename: "image${DateTime.now()}.${_image!.path.split('.').last}"),
      );
      widget.user.image = uploads;
    } 

    var api = RestDataSource();
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? token = await firebaseMessaging.getToken();
    await api.signUp(widget.user, token!).then((User user) async {
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

  

  Future<void> _loadAssets() async {
    if(!mounted)return;
    setState(() {
      images = [];
    });
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        materialOptions: MaterialOptions(
          statusBarColor: '#006437',
          actionBarColor: '#006437',
          selectCircleStrokeColor: '#006437',
          allViewTitle: "All Photos",
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
      if(e.toString() == "The user has denied the gallery access."){
        PhotoPermissions.buildImageRequest(context);
      }
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      images = resultList;
      if(images != null){
        if(images.length > 0){
          _setImageDetails(images[0]);
        }
      }
    });
  }

  void _setImageDetails(Asset asset) async {
    ByteData thumbData = await asset.getByteData();
    final directory = await getTemporaryDirectory();
    _image = await File('${directory.path}/${asset.name}').create();
    await _image!.writeAsBytes(thumbData.buffer.asUint8List());
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
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
            AbsorbPointer(
              absorbing: _showSpinner,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: Container(
                    width: 56,
                    height: 48,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.fill,
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
                  elevation: 0,
                ),
                body:  Container(
                  width: SizeConfig.screenWidth,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 34),
                        Text(
                          '02 of 02',
                          style: TextStyle(
                            color: Color(0xFFC4C4C3),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Regular",
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Addition Information',
                          style: TextStyle(
                            color: Color(0xff052328),
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Regular",
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: SizeConfig.screenWidth! * 0.8,
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
                        SizedBox(height: 17),
                        Container(
                          width: 78,
                          height: 78,
                          decoration: BoxDecoration(
                            color: Color(0XFFE7E7E7),
                            borderRadius: BorderRadius.circular(39),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(39),
                            child: (_image != null)
                                ? Image.file(
                              _image!,
                              width: 78,
                              height: 78,
                              fit: BoxFit.cover,
                            )
                                : Center(
                              child: Icon(
                                Icons.person,
                                size: 25,
                                color: Color(0xFFBDBDBD),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _loadAssets();
                          },
                          child: Text(
                            'Upload Profile Image',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF1FD47D),
                              decoration: TextDecoration.underline,
                              fontSize: 15,
                              fontFamily: "Regular",
                            ),
                          ),
                        ),
                        SizedBox(height: 35),
                        _buildForm(),
                        Container(
                          width: SizeConfig.screenWidth! - 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: SizeConfig.screenWidth! - 120,
                                child: RichText(
                                  text: TextSpan(
                                    text: 'You hereby agree to the ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: "Regular",
                                      color: Color(0XFFB3B9C6),
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Terms & Conditions',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "Regular",
                                          color: Color(0XFFB3B9C6),
                                          decoration: TextDecoration.underline,
                                          locale: Locale('fr', 'FR'),
                                        ),
                                        recognizer: TapGestureRecognizer()..onTap = (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => GiveawayLinks(
                                                giveawayUrl: 'https://www.awoofapp.com/terms-and-condition',
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      TextSpan(
                                        text: ' guiding this service.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "Regular",
                                          color: Color(0XFFB3B9C6),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              CupertinoSwitch(
                                  value: _terms,
                                  activeColor: Color(0xFF1FD47D),
                                  onChanged: (bool value) {
                                    setState(() {
                                      _terms = value;
                                    });
                                  }),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          width: SizeConfig.screenWidth! * 0.85,
                          child: Button(
                            onTap: (){
                              if(_formKey.currentState!.validate()){
                                if(_terms){
                                  _validateInputs();
                                } else {
                                  Constants.showInfo(context, 'Accept our terms and conditions');
                                }
                              }
                            },
                            width: SizeConfig.screenWidth! * 0.50,
                            radius: 5,
                            buttonColor: Color(0xFF1FD47D),
                            foregroundColor: Color(0xFF1FD47D),
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
                        SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Function to build form widget on our page that contains where user enter
  /// their details
  Widget _buildForm(){
    return Form(
      key: _formKey,
      child: Container(
        width: SizeConfig.screenWidth! * 0.85,
        child: Column(
          children: [
            /*InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                print(number.phoneNumber);
              },
              onInputValidated: (bool value) {
                print(value);
              },
              ignoreBlank: true,
              autoValidateMode: AutovalidateMode.disabled,
              initialValue: PhoneNumber(isoCode: 'NG'),
              textFieldController: _phoneController,
              inputBorder: OutlineInputBorder(),
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.DROPDOWN,
              ),
            ),*/
            SizedBox(height: 19),
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                _number = number;
              },
              selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  showFlags: true,
                  useEmoji: true
              ),
              ignoreBlank: true,
              autoValidateMode: AutovalidateMode.disabled,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your phone number';
                }
                return null;
              },
              selectorTextStyle: TextStyle(
                color: Color(0xFF525252),
                fontSize: 16,
                fontFamily: "Regular",
              ),
              inputDecoration: kTextFieldDecoration.copyWith(
                hintText: 'Phone Number',
                hintStyle: TextStyle(
                  color: Color(0xff808998),
                  fontSize: 16,
                  fontFamily: "Regular",
                ),
              ),
              textStyle: TextStyle(
                color: Color(0xFF525252),
                fontSize: 16,
                fontFamily: "Regular",
              ),
              initialValue: _number,
              spaceBetweenSelectorAndTextField: 0,
              textFieldController: _phoneController,
              formatInput: true,
              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
              inputBorder: OutlineInputBorder(),
            ),
            SizedBox(height: 19),
            TextFormField(
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
                DOBDayInputFormatter()
              ],
              style: TextStyle(
                color: Color(0xff525252),
                fontSize: 16,
                fontFamily: "Regular",
              ),
              textInputAction: TextInputAction.done,
              controller: _dobController,
              validator: DOBUtils.validateDate,
              keyboardType: TextInputType.number,
              onSaved: (value) {
                List<int> date = DOBUtils.getDateOfBirth(_dobController.text);
                _dateOfBirth = DateTime(date[2], date[1], date[0]).toString();
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'DD/MM/YYYY',
                hintStyle: TextStyle(
                  color: Color(0xff808998),
                  fontSize: 16,
                  fontFamily: "Regular",
                ),
                labelText: 'Date of Birth',
                labelStyle: TextStyle(
                  color: Color(0xFF808998),
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
                          color: Color(0xFF009B19).withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.calendar_today,
                          color: Color(0xFF1FD47D),
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 19),
            DropdownButtonFormField(
              value: _selectedGender,
              onChanged: (newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              },
              validator: (value) {
                if (_selectedGender == null ||  _selectedGender!.isEmpty) {
                  return 'Select a gender';
                }
                return null;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Gender',
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
                          Icons.people_outline,
                          color: Color(0xFF1FD47D),
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              items: _gender.map((genderDropdown) {
                return DropdownMenuItem(
                  child: Text(
                    genderDropdown,
                    style: TextStyle(
                      color: Color(0xFF525252),
                      fontSize: 16,
                      fontFamily: "Regular",
                    ),
                  ),
                  value: genderDropdown,
                );
              }).toList(),
            ),
            SizedBox(height: 41),
          ],
        ),
      ),
    );
  }

  /// Function to validate the inputs from our form with the [_formKey]
  void _validateInputs() async{
    final FormState form = _formKey.currentState!;
    if (!_formKey.currentState!.validate()) {
      if(!mounted)return;
      setState(() {
        _autoValidate = true; // Start validating on every change.
      });
      return null;
    } else {
      setState(() { _showSpinner = true; });
      form.save();
      print('yh: yh');
      _createUser();
    }
  }

  /// Function to get the phone number formatted and assigned to [_number]
  void _getPhoneNumber(String phoneNumber, String code) async {
    PhoneNumber number =
    await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, code);

    if(!mounted)return;
    setState(() {
      this._number = number;
    });
  }

  /// Function to validate phone number if it doesn't exist in the database
  /// If it's valid, it calls [_createUser] function to sign up the user
  void _checkPhoneNumber() async {
    if(!mounted)return;
    setState(() { _showSpinner = true; });
    var rest = RestDataSource();
    await rest.phoneCheck(_number.phoneNumber!.trim()).then((value) async {
      _resendCode();
    }).catchError((e){
      if(!mounted)return;
      setState(() { _showSpinner = false; });
      Constants.showError(context, e);
    });
  }

  /// Function that re-sends 2 fa code by calling [twoFaResend] in
  /// the [RestDataSource] class
  Future<void> _resendCode() async {
    List<http.MultipartFile> uploads = [];
    widget.user.phone = _number.phoneNumber!.trim();
    widget.user.dateOfBirth = _dateOfBirth!.trim();
    widget.user.gender = _selectedGender!.trim();
    if (_image != null) {
      uploads.add(
        await http.MultipartFile.fromPath("image", _image!.path, filename: "image${DateTime.now()}.${_image!.path.split('.').last}"),
      );
      widget.user.image = uploads;
    }
    var api = RestDataSource();
    await api.twoFaResend(widget.user.phone!).then((value) async {
      if(!mounted)return;
      setState(() { _showSpinner = false; });
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) =>
              PhoneVerification(
                createUser: widget.user,
                payload: 1,
              ),
        ),
      );
    }).catchError((e) {
      if(!mounted)return;
      setState(() {
        _showSpinner = false;
        _image = null;
        uploads.clear();
        images.clear();
        resultList.clear();
      });
      print(e);
      if(e.toString().contains('Bad state')){
        Constants.showError(context, 'An error occurred, please try again');
      } else {
        Constants.showError(context, e);
      }
    });
  }

}
