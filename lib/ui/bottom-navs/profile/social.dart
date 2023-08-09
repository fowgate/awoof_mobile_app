import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/model/socials.dart';
import 'package:awoof_app/networking/rest-data.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:flutter/material.dart';

class Social extends StatefulWidget {

  static const String id = 'social_page';

  @override
  _SocialState createState() => _SocialState();
}

class _SocialState extends State<Social> {

  /// A [GlobalKey] to hold the form state of my form widget for form validation
  final _formKey = GlobalKey<FormState>();

  /// A TextEditing controller to control the input for twitter
  TextEditingController _twitterController = TextEditingController();

  /// A TextEditing controller to control the input for facebook
  TextEditingController _facebookController = TextEditingController();

  /// A TextEditing controller to control the input for instagram
  TextEditingController _instagramController = TextEditingController();

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  bool _loading = false;

  /// A String variable to hold the user's twitter
  String? _twitter = '';

  /// A String variable to hold the user's facebook
  String? _facebook = '';

  /// A String variable to hold the user's instagram
  String? _instagram = '';

  bool _notSet = true;

  /// Function to fetch all the user socials from the database to
  /// [_socials]
  void _allSocials() async {
    Future<SocialAccounts> socials = futureValue.getAllUserSocialsFromDB();
    await socials.then((value) {
      if(!mounted)return;
      setState(() {
        _twitter = value.twitter != null ? value.twitter : '';
        _twitterController.text = _twitter!;
        _facebook = value.facebook != null ? value.facebook : '';
        _facebookController.text = _facebook!;
        _instagram = value.instagram != null ? value.instagram : '';
        _instagramController.text = _instagram!;
        if(_twitter == '' && _facebook == '' && _instagram == ''){
          _notSet = true;
        } else {
          _notSet = false;
        }
      });
    }).catchError((error){
      if(error == 'The User with the given ID was not found.'){
        if(!mounted)return;
        setState(() {
          _twitter = '';
          _facebook = '';
          _instagram = '';
          _notSet = true;
        });
      } else {
        print(error);
        Constants.showError(context, error);
      }
    });
  }

  @override
  void initState() {
    _allSocials();
    super.initState();
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
                    'Your Social Accounts',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Regular',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: SizeConfig.screenWidth,
                    child: Text(
                      'Adding in Social accounts allows us to send your winnings quicker',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Regular',
                        fontWeight: FontWeight.normal,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  _buildForm(),
                  Container(
                    width: SizeConfig.screenWidth,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()){
                          setState(() {
                            _loading = true;
                          });
                          _updateAccounts();
                          //_notSet ? _saveSocialAccounts() : _updateAccounts();
                        }
                      },
                      child: (_loading)
                          ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
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

  /// A function that builds the form widget for social accounts details to be displayed or changed
  Widget _buildForm(){
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Twitter',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Regular',
                  color: Color(0XFFB1B3BB),
                ),
              ),
              Container(
                width: SizeConfig.screenWidth,
                margin: EdgeInsets.only(top: 10, bottom: 20),
                child: TextFormField(
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Regular",
                  ),
                  keyboardType: TextInputType.text,
                  controller: _twitterController,
                  validator: (value) {
                    if(value == null && !_notSet){
                      _twitterController.text = _twitter!;
                    }
                    /*if(value.length < 3 && _notSet){
                      return "Username should be at least 3 characters";
                    }*/
                    return null;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: _twitter,
                    hintStyle: TextStyle(
                      color: Color(0xFFB4B6BE),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Regular",
                    ),
                    prefixIcon: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 14,
                            height: 14,
                            child: Center(
                              child: Image.asset(
                                'assets/images/t.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    suffixIcon: Container(
                      width: 30,
                      height: 56,
                      child: Center(
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            color: _twitter != '' ? Color(0XFF09AB5D) : Color(0xFFFFFFFF),
                          ),
                          child: Icon(
                            Icons.check,
                            color: _twitter != '' ? Colors.white : Colors.grey,
                            size: 8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          /*Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Facebook',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Regular',
                  color: Color(0XFFB1B3BB),
                ),
              ),
              Container(
                width: SizeConfig.screenWidth,
                margin: EdgeInsets.only(top: 10, bottom: 20),
                child: TextFormField(
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Regular",
                  ),
                  keyboardType: TextInputType.text,
                  controller: _facebookController,
                  validator: (value) {
                    if(value == null && !_notSet){
                      _facebookController.text = _facebook;
                    }
                    return null;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: _facebook,
                    hintStyle: TextStyle(
                      color: Color(0xFFB4B6BE),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Regular",
                    ),
                    prefixIcon: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 14,
                            height: 14,
                            child: Center(
                              child: Image.asset(
                                'assets/images/f-white.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    suffixIcon: Container(
                      width: 30,
                      height: 56,
                      child: Center(
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            color: _facebook != '' ? Color(0XFF09AB5D) : Color(0xFFFFFFFF),
                          ),
                          child: Icon(
                            Icons.check,
                            color: _facebook != '' ? Colors.white : Colors.grey,
                            size: 8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),*/
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Instagram',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Regular',
                  color: Color(0XFFB1B3BB),
                ),
              ),
              Container(
                width: SizeConfig.screenWidth,
                margin: EdgeInsets.only(top: 10, bottom: 40),
                child: TextFormField(
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Regular",
                  ),
                  keyboardType: TextInputType.text,
                  controller: _instagramController,
                  validator: (value) {
                    if(value == null && !_notSet){
                      _instagramController.text = _instagram!;
                    }
                    /*if(value.length < 3 && _notSet){
                      return "Username should be at least 3 characters";
                    }*/
                    return null;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: _instagram,
                    hintStyle: TextStyle(
                      color: Color(0xFFB4B6BE),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Regular",
                    ),
                    prefixIcon: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 14,
                            height: 14,
                            child: Center(
                              child: Image.asset(
                                'assets/images/i.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    suffixIcon: Container(
                      width: 30,
                      height: 56,
                      child: Center(
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            color: _instagram != '' ? Color(0XFF09AB5D) : Color(0xFFFFFFFF),
                          ),
                          child: Icon(
                            Icons.check,
                            color: _instagram != '' ? Colors.white : Colors.grey,
                            size: 8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Function that saves user's socials accounts details by calling [addMySocials] in the
  /// [RestDataSource] class
  void _saveSocialAccounts() async {
    var api = RestDataSource();

    String twitter = _twitterController.text.trim();
    String facebook = _facebookController.text.trim();
    String instagram = _instagramController.text.trim();
    await api.addMySocials(twitter, facebook, instagram).then((value) async {
      if(!mounted)return;
      setState(() {
        _loading = false;
      });
      Constants.showSuccess(
        context,
        'Successfully Saved Details',
        where: (){
          Navigator.pop(context);
        }
      );
    }).catchError((error) {
      if(!mounted)return;
      setState(() {
        _loading = false;
      });
      Constants.showError(context, error);
    });
  }

  /// Function that updates user's social accounts details by calling [updateAccounts] in the
  /// [RestDataSource] class
  void _updateAccounts() async {
    var api = RestDataSource();

    String twitter = _twitterController.text;
    String facebook = _facebookController.text;
    String instagram = _instagramController.text;
    await api.updateMySocials(twitter, facebook, instagram).then((value) async {
      if(!mounted)return;
      setState(() {
        _loading = false;
      });
      Constants.showSuccess(
          context,
          'Successfully Updated Details',
          where: (){
            Navigator.pop(context);
          }
      );
    }).catchError((error) {
      if(!mounted)return;
      setState(() {
        _loading = false;
      });
      Constants.showError(context, error);
    });
  }

}
