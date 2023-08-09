import 'package:awoof_app/utils/photo-permissions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/database/user-db-helper.dart';
import 'package:awoof_app/networking/rest-data.dart';
import 'package:awoof_app/ui/sliders.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:awoof_app/utils/rflutter_alert-2.0.4/lib/rflutter_alert.dart';
//import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:io';

class Settings extends StatefulWidget {

  static const String id = 'settings_page';

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  /// A [GlobalKey] to hold the form state of my form widget for form validation
  final _formKey = GlobalKey<FormState>();

  /// A TextEditing controller to control the input for first name
  TextEditingController _firstNameController = TextEditingController();

  /// A TextEditing controller to control the input for last name
  TextEditingController _lastNameController = TextEditingController();

  /// A TextEditing controller to control the input for username
  TextEditingController _userNameController = TextEditingController();

  bool _loading = false;

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A String variable to hold the user's id
  String _userId = '';

  /// A String variable to hold the user's first name
  String _firstName = '';

  /// A String variable to hold the user's last name
  String _lastName = '';

  /// A String variable to hold the user's username
  String _username = '';

  /// A String variable to hold the user's email
  String _email = '';

  /// A String variable to hold the user's phone number
  String _phoneNumber = '';

  /// A String variable to hold the user's image url
  String _imageUrl = '';

  /// A list of Asset to store all images
  List<Asset> images = [];

  /// A list of Asset to store all selected
  List<Asset> resultList = [];

  Future<void> _loadAssets() async {
    if(!mounted)return;
    setState(() {
      images = [];
    });
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        materialOptions: MaterialOptions(
          statusBarColor: '#121212',
          actionBarColor: '#121212',
          selectCircleStrokeColor: '#121212',
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
          _changePicture();
        }
      }
    });
  }

  /// Setting the current user's details to [_userId], [_fullName],
  /// [_username] and [_phoneNumber]
  void _getCurrentUser() async {
    await futureValue.updateUser();
    await futureValue.getCurrentUser().then((user) {
      if(!mounted)return;
      setState(() {
        _imageUrl = user!.image!;
        _userId = user.id!;
        _firstName = user.firstName!;
        _lastName = user.lastName!;
        _firstNameController.text = _firstName;
        _lastNameController.text = _lastName;
        _username = user.userName!;
        _userNameController.text = _username;
        _email = user.email!;
        _phoneNumber = user.phone!;
      });
    }).catchError((Object error) {
      print(error);
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
          automaticallyImplyLeading: false,
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
        body: Container(
          width: SizeConfig.screenWidth,
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 15),
                  Text(
                    'Account Settings',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Regular',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    width: SizeConfig.screenWidth! - 30,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 72,
                          height: 72,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(36),
                            child: (_imageUrl != null && _imageUrl != '')
                                ? CachedNetworkImage(
                                imageUrl: _imageUrl,
                                fit: BoxFit.contain
                            )
                                : Center(
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: Color(0xFFBDBDBD),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            _loadAssets();
                          },
                          child: Container(
                            width: 151,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(23),
                              ),
                              color: Color(0XFF1F253B),
                            ),
                            child: Center(
                              child: Text(
                                'Change Picture',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Regular',
                                  letterSpacing: 0.6,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  _buildForm(),
                  SizedBox(height: 35),
                  Container(
                    width: SizeConfig.screenWidth,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()){
                          setState(() {
                            _loading = true;
                          });
                          HapticFeedback.lightImpact();
                          _updateUser();
                        }
                      },
                      child: (_loading)
                          ? CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                          Color(0xFFFFFFFF),
                        ),
                      )
                          : Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: "Bold",
                          color: Colors.white,
                        ),
                      ),
                      //color: Color(0xFF1FD47D),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// A function that builds the form widget for account details to be displayed or changed
  Widget _buildForm(){
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Username',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Regular',
              color: Color(0XFFB1B3BB),
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: SizeConfig.screenWidth,
            child: TextFormField(
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "Regular",
              ),
              keyboardType: TextInputType.text,
              controller: _userNameController,
              validator: (value) {
                if(value == null ){
                  _userNameController.text = _username;
                }
                if(value!.length < 3){
                  return "Username should be at least 3 characters";
                }
                return null;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: _username,
                hintStyle: TextStyle(
                  color: Color(0xFFB4B6BE),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Regular",
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'First Name',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Regular',
              color: Color(0XFFB1B3BB),
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: SizeConfig.screenWidth,
            child: TextFormField(
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "Regular",
              ),
              controller: _firstNameController,
              keyboardType: TextInputType.name,
              readOnly: true,
              enabled: false,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
              ],
              validator: (value) {
                if(value == null ){
                  _firstNameController.text = _firstName;
                }
                if(value!.length < 3){
                  return "Name should be at least 3 characters";
                }
                return null;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: _firstName,
                hintStyle: TextStyle(
                  color: Color(0xFFB4B6BE),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Regular",
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Last Name',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Regular',
              color: Color(0XFFB1B3BB),
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: SizeConfig.screenWidth,
            child: TextFormField(
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "Regular",
              ),
              keyboardType: TextInputType.name,
              controller: _lastNameController,
              readOnly: true,
              enabled: false,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
              ],
              validator: (value) {
                if(value == null ){
                  _lastNameController.text = _lastName;
                }
                if(value!.length < 3){
                  return "Name should be at least 3 characters";
                }
                return null;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: _lastName,
                hintStyle: TextStyle(
                  color: Color(0xFFB4B6BE),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Regular",
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Phone Number',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Regular',
              color: Color(0XFFB1B3BB),
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: SizeConfig.screenWidth,
            height: 56,
            child: TextFormField(
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "Regular",
              ),
              initialValue: _phoneNumber,
              enabled: false,
              keyboardType: TextInputType.phone,
              decoration: kTextFieldDecoration.copyWith(
                hintText: _phoneNumber,
                hintStyle: TextStyle(
                  color: Color(0xFFB4B6BE),
                  fontSize: 16,
                  fontFamily: "Regular",
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Text(
            'Email Address',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Regular',
              color: Color(0XFFB1B3BB),
            ),
          ),
          Container(
            width: SizeConfig.screenWidth,
            height: 56,
            child: TextFormField(
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "Regular",
              ),
              initialValue: _email,
              enabled: false,
              keyboardType: TextInputType.emailAddress,
              decoration: kTextFieldDecoration.copyWith(
                hintText: _email,
                hintStyle: TextStyle(
                  color: Color(0xFFB4B6BE),
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

  /// Function that updates user's details by calling [updateProfile] in the
  /// [RestDataSource] class
  void _updateUser() async {
    var api = RestDataSource();

    String firstName = Constants.capitalize(_firstNameController.text);
    String lastName = Constants.capitalize(_lastNameController.text);
    String userName = _userNameController.text;
    String phone = _phoneNumber;
    await api.updateProfile(lastName, firstName, userName, phone).then((value) async {
      await futureValue.updateUser();
      if(!mounted)return;
      setState(() {
        _loading = false;
      });
      _showAlert(true, 'Successfully Updated Profile');
    }).catchError((error) {
      if(!mounted)return;
      setState(() {
        _loading = false;
      });
      _showAlert(false, error);
    });
  }

  /// Function that changes user's picture by calling [changeProfilePicture] in the
  /// [RestDataSource] class
  Future<void> _changePicture() async {
    var api = RestDataSource();
    List<http.MultipartFile> uploads = [];
    Asset asset = images[0];

    ByteData thumbData = await asset.getByteData();
    final directory = await getTemporaryDirectory();
    final image = await File('${directory.path}/${asset.name}').create();
    await image.writeAsBytes(thumbData.buffer.asUint8List());

    uploads.add(
      await http.MultipartFile.fromPath("image", image.path, filename: "profile${DateTime.now()}.${image.path.split('.').last}"),
    );
    await api.changeProfilePicture(uploads).then((value) async {
      Constants.showSuccess(
          context,
          value,
          where: () async {
            await futureValue.updateUser();
            Navigator.pop(context);
          }
      );
    }).catchError((e) {
      if(!mounted)return;
      setState(() {
        _loading = false;
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

  /// Function to logout your account
  void _logout() async {
    var db = DatabaseHelper();
    await db.deleteUsers();
    _getBoolValuesSF();
  }

  /// Function to get the 'loggedIn' in your SharedPreferences
  _getBoolValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool boolValue = prefs.getBool('loggedIn') ?? true;
    if(boolValue == true){
      _addBoolToSF();
    }
  }

  /// Function to set the 'loggedIn' in your SharedPreferences to false
  _addBoolToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
    Navigator.of(context).pushReplacementNamed(Sliders.id);
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
