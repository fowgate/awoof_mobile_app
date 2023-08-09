import 'dart:io';
import 'package:awoof_app/utils/photo-permissions.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/database/user-db-helper.dart';
import 'package:awoof_app/networking/rest-data.dart';
import 'package:awoof_app/ui/bottom-navs/profile/my-giveaways.dart';
import 'package:awoof_app/ui/bottom-navs/profile/refer.dart';
import 'package:awoof_app/ui/bottom-navs/profile/security.dart';
import 'package:awoof_app/ui/bottom-navs/profile/settings.dart';
import 'package:awoof_app/ui/bottom-navs/profile/social.dart';
import 'package:awoof_app/ui/bottom-navs/profile/support.dart';
import 'package:awoof_app/ui/sliders.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class Profile extends StatefulWidget {

  static const String id = 'profile_page';

  final dynamic payload;

  const Profile({
    Key? key,
    this.payload
  }) : super(key: key);


  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A String variable to hold the user's full name
  String _fullName = '';

  /// A String variable to hold the user's username
  String _username = '';

  /// A String variable to hold the user's rating
  String _userRatings = '';

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
          _changePicture();
        }
      }
    });
  }

  /// Setting the current user's details to [_fullName], [_username], [_userRatings]
  void _getCurrentUser() async {
    futureValue.updateUser();
    await futureValue.getCurrentUser().then((user) async {
      if(!mounted)return;
      setState(() {
        _imageUrl = user!.image!;
        _fullName = '${user.firstName} ${user.lastName}';
        _username = user.userName!.trim();
        _userRatings = '${user.stars}/30';
      });
      if(widget.payload != null){
        PermissionStatus permissionStatus = await _getContactPermission();
        if (permissionStatus == PermissionStatus.granted) {
          Navigator.pushNamed(context, Refer.id);
        } else {
          _askPermissions();
        }
      }
    }).catchError((Object error) {
      print(error);
    });
  }

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus != PermissionStatus.granted) {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted) {
      Map<Permission, PermissionStatus> permissionStatus = await [
        Permission.contacts,
      ].request();
      return permissionStatus[Permission.contacts]!;
    } else {
      Map<Permission, PermissionStatus> permissionStatus = await [
        Permission.contacts,
      ].request();
      return permissionStatus[Permission.contacts]!;
      //return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      print('Access to contacts denied');
      _buildContactsRequest();
    }
    else if (permissionStatus == PermissionStatus.restricted) {
      print('Contacts data is not available on device');
    }
    else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      print('Contacts data is permanently denied');
      _buildContactsRequest();
    }
  }

  /// This function builds and return a dialog to the user telling them to enable
  /// permission in settings
  Future<void> _buildContactsRequest(){
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        elevation: 0.0,
        child: Container(
          width: 300,
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF).withOpacity(0.91),
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Note',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Raleway',
                        color: Color(0xFF1D1D1D)
                    ),
                  )
              ),
              Container(
                width: 260,
                padding: EdgeInsets.only(top: 12, bottom: 11),
                child: Text(
                  "You disabled permission to access your contacts. Please enable access to contacts in settings to earn stars",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Raleway',
                  ),
                ),
              ),
              Container(
                width: 252,
                height: 1,
                color: Color(0xFF9C9C9C).withOpacity(0.44),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 12.0, bottom: 11),
                  child: Text(
                    'Ok',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Raleway',
                        color: Color(0xFF1FD47D)
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// This function builds and return a dialog to the user explaining info of
  /// what their ratings is for
  Future<void> _buildStarGiveawayInfo(){
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        elevation: 0.0,
        child: Container(
          width: 300,
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF).withOpacity(0.91),
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Note',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Raleway',
                        color: Color(0xFF1D1D1D)
                    ),
                  )
              ),
              Container(
                width: 260,
                padding: EdgeInsets.only(top: 12, bottom: 11),
                child: Text(
                  "Awoof stars are required for entering star giveaways which are usually higher value prizes than regular giveaways",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Raleway',
                  ),
                ),
              ),
              Container(
                width: 252,
                height: 1,
                color: Color(0xFF9C9C9C).withOpacity(0.44),
              ),
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 12.0, bottom: 11),
                  child: Text(
                    'Ok',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Raleway',
                        color: Color(0xFF1FD47D)
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 55),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _loadAssets();
                },
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(72),
                    child: (_imageUrl != null && _imageUrl != '')
                        ? CachedNetworkImage(
                      imageUrl: _imageUrl,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Color(0xFF1FD47D),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          (_username == '' || _username == null)
                              ? '' : _username.split('').first.toUpperCase(),
                          style: TextStyle(
                            fontSize: 34,
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    )
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: SizeConfig.screenWidth! - 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _fullName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 19,
                        fontFamily: 'Regular',
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF000000),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '@$_username',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Regular',
                            color: Color(0XFF9B9D9C),
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(2),
                            ),
                            color: Color(0XFFC4C4C4),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '⭐️  $_userRatings',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Regular',
                            color: Color(0XFF9B9D9C),
                          ),
                        ),
                        IconButton(
                          onPressed: (){
                            _buildStarGiveawayInfo();
                          },
                          icon: Icon(
                            Icons.info_outlined,
                            color: Color(0xFF1FD47D),
                            size: 20
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF1FD47D),
                  onPrimary: Color(0xFFFFFFFF),
                ),
                onPressed: () async {
                  HapticFeedback.lightImpact();
                  PermissionStatus permissionStatus = await _getContactPermission();
                  if (permissionStatus == PermissionStatus.granted) {
                    Navigator.pushNamed(context, Refer.id);
                  }
                  else {
                    _askPermissions();
                  }
                },
                child: Container(
                  width: SizeConfig.screenWidth! - 80 > 275
                      ? 275 
                      : SizeConfig.screenWidth! - 80,
                  height: 56,
                  child: Center(
                    child: Text(
                      'Invite a Friend - Get ⭐️ ⭐️ ⭐️',
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: "Regular",
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.pushNamed(context, MyGiveaways.id);
                },
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/trophy.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 15),
                    Container(
                      width: SizeConfig.screenWidth! - 80,
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'My Giveaways',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Regular',
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF001431),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: Color(0XFF979797),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, MyGiveaways.id);
                            },
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Color(0XFFECECEC),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.pushNamed(context, Social.id);
                },
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/social.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 15),
                    Container(
                      width: SizeConfig.screenWidth! - 80,
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Social Accounts',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Regular',
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF001431),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: Color(0XFF979797),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, Social.id);
                            },
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Color(0XFFECECEC),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.pushNamed(context, Settings.id).then((value) {
                    _getCurrentUser();
                  });
                },
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/settings.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 15),
                    Container(
                      width: SizeConfig.screenWidth! - 80,
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Settings',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Regular',
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF001431),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: Color(0XFF979797),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, Settings.id);
                            },
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Color(0XFFECECEC),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              /*GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Bank.id);
                },
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/wallet.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 15),
                    Container(
                      width: SizeConfig.screenWidth - 80,
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Bank Accounts',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Regular',
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF001431),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: Color(0XFF979797),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, Bank.id);
                            },
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Color(0XFFECECEC),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),*/
              InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.pushNamed(context, Security.id);
                },
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/security.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 15),
                    Container(
                      width: SizeConfig.screenWidth! - 80,
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Security',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Regular',
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF001431),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: Color(0XFF979797),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, Security.id);
                            },
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Color(0XFFECECEC),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              /*InkWell(
                onTap: () async {
                  PermissionStatus permissionStatus = await _getContactPermission();
                  if (permissionStatus == PermissionStatus.granted) {
                    Navigator.pushNamed(context, Refer.id);
                  } else {
                    _askPermissions();
                  }
                },
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/add-user.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 15),
                    Container(
                      width: SizeConfig.screenWidth - 80,
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Tell a friend',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Regular',
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF001431),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: Color(0XFF979797),
                            ),
                            onPressed: () async {
                              PermissionStatus permissionStatus = await _getContactPermission();
                              if (permissionStatus == PermissionStatus.granted) {
                                Navigator.pushNamed(context, Refer.id);
                              } else {
                                _askPermissions();
                              }
                            },
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Color(0XFFECECEC),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),*/
              InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.pushNamed(context, Support.id);
                },
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/help.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 15),
                    Container(
                      width: SizeConfig.screenWidth! - 80,
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Help & Support',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Regular',
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF001431),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: Color(0XFF979797),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, Support.id);
                            },
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Color(0XFFECECEC),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  _logout();
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 65,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/log-out.png',
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 15),
                        Text(
                          'Logout',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.bold,
                            color: Color(0XFFEF9087),
                          ),
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

  /// Function to logout your account
  void _logout() async {
    await _deleteFiles();
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
    Navigator.of(context).pushNamedAndRemoveUntil(Sliders.id, (Route<dynamic> route) => false);
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
        where: () {
          _getCurrentUser();
          setState(() { });
          //Navigator.pop(context);
        }
      );
    }).catchError((e) {
      if(!mounted)return;
      setState(() {
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
