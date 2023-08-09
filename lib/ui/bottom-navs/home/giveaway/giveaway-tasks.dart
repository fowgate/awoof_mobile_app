import 'dart:async';
import 'package:awoof_app/model/giveaways.dart';
import 'package:awoof_app/networking/rest-data.dart';
import 'giveaway-links.dart';
import 'package:awoof_app/ui/bottom-navs/home/giveaway/response-successful.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/ui/timeline.dart';
import 'package:awoof_app/ui/bottom-navs/profile/refer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:awoof_app/model/socials.dart';
import 'package:url_launcher/url_launcher.dart';

class GiveawayTasks extends StatefulWidget {

  final AllGiveaways giveaway;

  const GiveawayTasks({
    Key? key,
    required this.giveaway
  }) : super(key: key);

  @override
  _GiveawayTasksState createState() => _GiveawayTasksState();
}

class _GiveawayTasksState extends State<GiveawayTasks> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A [GlobalKey] to hold the form state of my form widget for form validation
  final _formKey = GlobalKey<FormState>();

  /// A TextEditing controller to control the input for twitter
  TextEditingController? _twitterController = TextEditingController();

  /// A TextEditing controller to control the input for facebook
  TextEditingController _facebookController = TextEditingController();

  /// A TextEditing controller to control the input for instagram
  TextEditingController _instagramController = TextEditingController();

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
        _twitterController?.text = _twitter!;
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


  /// A List of String variable to hold the giveaway conditions
  List<String?> _conditions = [];

  /// A List of String variable to hold the giveaway conditions url
  List<String?> _conditionUrl = [];

  /// A List of String variable to hold the giveaway conditions image url
  List<String?> _conditionAssets = [];

  /// A List of boolean values to hold the giveaway tasks status
  List<bool> _taskStatus = [];

  /// A boolean variable to hold the [inAsyncCall] value in my
  /// [ModalProgressHUD] widget
  bool _showSpinner = false;

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
      return permission;
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

  /// A double variable to hold the user's number of stars
  String _numberOfStars = '';

  /// This variable holds the user's number of giveaways he has participated in
  String _giveawaysParticipated= '';

  /// Setting the current user's stars to [_numberOfStars]
  void _getCurrentUser() async {
    await futureValue.updateUser();
    await futureValue.getCurrentUser().then((user) {
      if(!mounted)return;
      setState(() {
        _numberOfStars = user!.stars!;
        _giveawaysParticipated = user.giveawaysParticipated!;
        /// print(user.giveawaysParticipated);
      });
    }).catchError((Object error) {
      print(error);
    });
  }

  int _count = 1;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _getConditions();
    _allSocials();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AbsorbPointer(
      absorbing: _showSpinner,
      child: Scaffold(
        backgroundColor: Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Color(0XFF060D25),
            ),
            onPressed: () {
              if(_count > 1){
                Navigator.pop(context);
              }
              else {
                Constants.showInfo(context, 'Press back again to leave');
                if(!mounted)return;
                setState(() {
                  _count += 1;
                });
              }
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
          automaticallyImplyLeading: false,
        ),
        body: Container(
          width: SizeConfig.screenWidth,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: SizeConfig.screenWidth,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                                image: widget.giveaway.image != null
                                    ? NetworkImage(widget.giveaway.image!)
                                    : Image.asset('assets/images/default-image.jpeg') as ImageProvider,
                              ),
                            ),
                            height: 100,
                          ),
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
                                colors: [
                                  Color(0xFF121212).withOpacity(0.8),
                                  Color(0xFF121212),
                                ],
                                stops: [0.0, 1.0],
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  SizeConfig.screenWidth! * 0.075, 0,
                                  SizeConfig.screenWidth! * 0.075, 0
                              ),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          widget.giveaway.isAnonymous!
                                              ? 'Anonymous Giver'
                                              : widget.giveaway.user.firstName,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Regular',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          width: 14,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(7),
                                            ),
                                            color: Color(0XFF09AB5D),
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            size: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 40,
                                      height: 40,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                          child: widget.giveaway.isAnonymous!
                                              ? Image.asset(
                                            "assets/images/tl6.png",
                                            fit: BoxFit.cover,
                                          )
                                              : widget.giveaway.user.image != null
                                              ? CachedNetworkImage(
                                              imageUrl: widget.giveaway.user.image,
                                              fit: BoxFit.cover,
                                              errorWidget: (context, url, error) => Container(color: Color(0xFF1F1F1F))
                                          )
                                              : Container(
                                            width: 25,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF09AB5D),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                widget.giveaway.user.userName.split('').first.toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Regular',
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFFFFFFFF),
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: SizeConfig.screenWidth! * 0.85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          color: widget.giveaway.type == 'star'
                              ? Color(0xFFD99E1D)
                              : Color(0xFF09AB5D),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/cash-white.png',
                                    width: 18,
                                    height: 18,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'AMOUNT',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontFamily: 'Regular',
                                      color:  widget.giveaway.type == 'star' ? Color(0xFFFFFFFF).withOpacity(0.5) : Color(0XFF75CFA4),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    width: (SizeConfig.screenWidth! * 0.85) / 3,
                                    child: Text(
                                      '${Constants.money(double.parse(widget.giveaway.amount!), 'N')}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Bold',
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.schedule,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'EXPIRES IN',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontFamily: 'Regular',
                                      color: widget.giveaway.type == 'star' ? Color(0xFFFFFFFF).withOpacity(0.5) : Color(0XFF75CFA4),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    (widget.giveaway.endAt != null && !widget.giveaway.completed!)
                                        ?  Constants.getTimeLeft(widget.giveaway.endAt!) ?? ''
                                        : 'Expired',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Bold',
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/slots.png',
                                    width: 18,
                                    height: 18,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'NO OF SLOTS',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontFamily: 'Regular',
                                      color: widget.giveaway.type == 'star' ? Color(0xFFFFFFFF).withOpacity(0.5) : Color(0XFF75CFA4),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: (SizeConfig.screenWidth! * 0.85) / 3.2,
                                    child: Text(
                                      widget.giveaway.numberOfWinners! > 1
                                          ? '${widget.giveaway.numberOfWinners} WINNERS'
                                          : '${widget.giveaway.numberOfWinners} WINNER',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Bold',
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                _getConditionWidget(),
                SizedBox(height: 55),
                InkWell(
                  onTap: () {
                    if (_taskStatus.every((element) => element)) {
                      if(_conditions!.length > 0){
                        _showUpdateSocialSheet();
                      }
                      else {
                        if(!mounted)return;
                        setState(() {
                          _showSpinner = true;
                        });
                        _submitResponse();
                      }
                    }
                  },
                  child: Container(
                    width: SizeConfig.screenWidth! * 0.85,
                    height: 56,
                    color: (_taskStatus.every((element) => element))
                        ? widget.giveaway.type == 'star' ? Color(0xFFD99E1D) : Color(0xFF1FD47D)
                        : Color(0xFF2C3245),
                    child: Center(
                      child: _showSpinner
                          ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF)),
                      )
                          : Text(
                        'Submit Response',
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: "Bold",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GiveawayLinks(
                          giveawayUrl: 'https://www.awoofapp.com/terms-and-condition',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: SizeConfig.screenWidth! * 0.82,
                    child: Text(
                      'Please read our guidelines on entering a competition and how winners are chosen.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Regular',
                        color: Color(0XFF535662),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// A function to get the conditions of the giveaway
  void _getConditions(){
    if(widget.giveaway.likePostOnFacebook == true){
      _conditions?.add('Like sponsor post on Facebook');
      _conditionUrl?.add('${widget.giveaway.likeFacebookLink}');
      _conditionAssets?.add("assets/images/f-white.png");
      _taskStatus.add(false);
    }
    if(widget.giveaway.likeFacebook == true){
      _conditions!.add('Like sponsor page on Facebook');
      /*${widget.giveaway.followPageOnFacebook}*/
      //_conditionUrl.add('https://web.facebook.com/${widget.giveaway.likeFacebookLink}');
      _conditionUrl?.add(widget.giveaway.likeFacebookLink);
      _conditionAssets?.add("assets/images/f-white.png");
      _taskStatus.add(false);
    }
    if(widget.giveaway.likeTweet == true){
      _conditions?.add('Like and retweet sponsor post');
      _conditionUrl?.add('${widget.giveaway.likeTweetLink}');
      _conditionAssets?.add("assets/images/t.png");
      _taskStatus.add(false);
    }
    if(widget.giveaway.followTwitter == true){
      _conditions?.add('Follow sponsor on Twitter');
      /*${widget.giveaway.followTwitterLink}*/
      _conditionUrl?.add('https://www.twitter.com/${widget.giveaway.followTwitterLink?.trim()}');
      _conditionAssets?.add("assets/images/t.png");
      _taskStatus.add(false);
    }
    if(widget.giveaway.likeInstagram == true){
      _conditions!.add('Like sponsor post on Instagram');
      _conditionUrl?.add('${widget.giveaway.likeInstagramLink}');
      _conditionAssets?.add("assets/images/i.png");
      _taskStatus.add(false);
    }
    if(widget.giveaway.followInstagram == true){
      _conditions!.add('Follow sponsor on Instagram');
      /*${widget.giveaway.followInstagramLink}*/
      _conditionUrl?.add('https://www.instagram.com/${widget.giveaway.followInstagramLink?.trim()}');
      _conditionAssets?.add("assets/images/i.png");
      _taskStatus.add(false);
    }
    if(widget.giveaway.type == "star"){
      _conditions?.add('Submit ${widget.giveaway.star}   ⭐️');
      _conditionUrl?.add(null);
      _conditionAssets?.add(null);
      _taskStatus.add(false);
    }
  }

  /// A function that builds the widget of the giveaway conditions
  Widget _getConditionWidget(){
    List<Widget> _myConditions = [];
    _myConditions.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Giveaway Tasks',
              style: TextStyle(
                fontSize: 17,
                fontFamily: 'Regular',
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        )
    );
    if(_conditions.length != 0){
      _myConditions.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 17),
            Container(
              width: 230,
              child: Text(
                'To win this give away, please complete the tasks below:',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Regular',
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      );
      for(int i = 0; i < _conditions.length; i++) {
        _myConditions.add(
          Container(
            width: SizeConfig.screenWidth! * 0.85,
            height: 100,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: Color(0XFF1F253B),
                ),
              ),
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '           Task ${i + 1}',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Regular',
                      color: Color(0XFF2B3146),
                    ),
                  ),
                  SizedBox(height: 7),
                  InkWell(
                    onTap: () async {
                      bool launched = false;
                      print(_conditionUrl[i]);
                      if(_conditionUrl[i] != null){
                        if (await canLaunch(_conditionUrl[i]!)) {
                          if(!mounted)return;
                          setState(() { _count = 1; });
                          await launch(_conditionUrl[i]!);
                          if(!mounted)return;
                          setState(() {
                            _taskStatus[i] = true;
                          });
                        }
                        else {
                          throw 'Could not launch the url';
                        }
                        if(launched){
                          _buildConfirmConditions(_conditionUrl[i]!);
                          if(!mounted)return;
                          setState(() {
                            _taskStatus[i] = true;
                          });
                        }
                        /*await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GiveawayLinks(
                              giveawayUrl: _conditionUrl[i],
                            ),
                          ),
                        ).then((value) {
                          _buildConfirmConditions(_conditionUrl[i]);
                        });
                        if(!mounted)return;
                        setState(() {
                          _taskStatus[i] = true;
                        });*/
                      }
                      else {
                        if(int.parse(_numberOfStars) >= int.parse(widget.giveaway.star!)){
                          if(!mounted)return;
                          setState(() {
                            _taskStatus[i] = true;
                          });
                        }
                        else{
                          if(!mounted)return;
                          Navigator.pop(context);
                          Navigator.pop(context);
                          PermissionStatus permissionStatus = await _getContactPermission();
                          if (permissionStatus == PermissionStatus.granted) {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Timeline(
                                  currentIndex: 4,
                                ),
                              ),
                            );
                            Navigator.pushNamed(context, Refer.id);
                          }
                          else {
                            _askPermissions();
                          }
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 222,
                          height: 46,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(23),
                            ),
                            border: Border.all(
                              width: 1,
                              color: _taskStatus[i]
                                  ? Color(0xFF09AB5D)
                                  : Color(0xFF2C3245),
                            ),
                            color: _taskStatus[i]
                                ? Color(0xFF061C2A)
                                : Color(0xFF2C3245),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: 160,
                                  child: Text(
                                    _conditions[i]!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Regular',
                                      color: _taskStatus[i]
                                          ? Color(0XFF09AB5D)
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                                _conditionAssets[i] != null
                                    ? Image.asset(
                                  _conditionAssets[i]!,
                                  width: 13,
                                  height: 13,
                                  fit: BoxFit.contain,
                                )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(7),
                                ),
                                color: _taskStatus[i] ? Color(0XFF09AB5D) : Colors.transparent,
                                border: Border.all(
                                  width: _taskStatus[i] ? 0 : 1,
                                  color: _taskStatus[i] ? Colors.transparent : Color(0xFF2C3245),
                                ),
                              ),
                              child: _taskStatus[i]
                                  ? Icon(
                                Icons.check,
                                size: 10,
                                color: Colors.white,
                              )
                                  : Container(),
                            ),
                            SizedBox(width: 15),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    else {
      _myConditions.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 17),
            Container(
              width: 230,
              child: Text(
                'Entry is free, no giveaway tasks to complete',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Regular',
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      );
    }
    return Container(
      width: SizeConfig.screenWidth! * 0.85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _myConditions,
      ),
    );
  }

  /// Function that shows a confirm dialog when the user is about submit response
  Future<void> _buildConfirmDialog(){
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        elevation: 0.0,
        child: Container(
          width: 260,
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
                width: 220,
                padding: EdgeInsets.only(top: 12, bottom: 11),
                child: Text(
                  "Kindly confirm you have completed all the giveaway tasks, non completion would result in disqualification",
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
              Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        // Navigator.pop(context);
                        Navigator.pop(context);
                        _showUpdateSocialSheet();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 12.0, bottom: 11),
                        child: Text(
                          'Go Back',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Raleway',
                              color: Color(0xFF1FD47D)
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        if(!mounted)return;
                        setState(() {
                          _showSpinner = true;
                        });
                        Navigator.pop(context);
                        _submitResponse();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 12.0, bottom: 11),
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Raleway',
                              color: Color(0xFF1FD47D)
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Function that shows a confirm dialog when the user is about leave a task
  Future<void> _buildConfirmConditions(String index){

    return showDialog(
      context: context,
      builder: (_) => Dialog(
        elevation: 0.0,
        child: Container(
          width: 260,
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
                width: 220,
                padding: EdgeInsets.only(top: 12, bottom: 11),
                child: Text(
                  "Kindly confirm you have completed the giveaway task",
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
              Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        bool launched = false;
                        if(index != null){
                          if (await canLaunch(index)) {
                            if(!mounted)return;
                            setState(() { _count = 1; });
                            await launch(index);
                          }
                          else {
                            throw 'Could not launch the url';
                          }
                          if(launched){
                            _buildConfirmConditions(index);
                          }
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 12.0, bottom: 11),
                        child: Text(
                          'Go Back',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Raleway',
                              color: Color(0xFF1FD47D)
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 12.0, bottom: 11),
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Raleway',
                              color: Color(0xFF1FD47D)
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// A function that submits user's response of joining giveaway
  void _submitResponse() async {
    var api = RestDataSource();
    await api.joinGiveaway(widget.giveaway.id!).then((value) async {
      if(!mounted)return;
      setState(() {
        _showSpinner = false;
      });
      /*if(_giveawaysParticipated != null){
        if((int.parse(_giveawaysParticipated) + 1) % 5 == 0){
          await _showUpdateSocialSheet().then((value) {
            return Navigator.pushNamed(context, ResponseSuccessful.id);
          });
        }
        else {
          Navigator.pushNamed(context, ResponseSuccessful.id);
        }
      }
      else {
        Navigator.pushNamed(context, ResponseSuccessful.id);
      }*/
      Navigator.pushReplacementNamed(context, ResponseSuccessful.id);
    }).catchError((err){
      print(err);
      setState(() {
        _showSpinner = false;
      });
      Constants.showError(context, err.toString());
    });
  }

  /// This function builds a modal sheet to update user social account
  Future<void> _showUpdateSocialSheet() async {
    bool showDialog = true;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                padding: EdgeInsets.all(12),
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Color(0xFF121212),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SingleChildScrollView(
                      child: Form(
                        key: _formKey,         
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 22, bottom: 23, right: 12),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        if(!mounted)return;
                                        setModalState(() {
                                          showDialog = false;
                                        });
                                        /*setState(() {
                                          for(int i = 0; i < _taskStatus.length; i++){
                                            _taskStatus[i] = false;
                                          }
                                        });*/
                                        Navigator.pop(context);
                                      },
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        size: 24,
                                        color: Color(0xFF1FD47D),
                                      ),
                                    ),
                                    Container(
                                      width: SizeConfig.screenWidth! - 130,
                                      child: Text(
                                          "Enter your social media profiles to receive your winnings quicker",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 16,
                                            fontFamily: 'Circular Std Book',
                                            color: Color(0xFFFFFFFF),
                                          ),
                                        )
                                    ),
                                    Container()
                                  ],
                                ),
                              ),
                              Container(
                                width: SizeConfig.screenWidth,
                                height: 1,
                                color: Color(0xFFE0E0E0),
                              ),
                              SizedBox(height: 20),
                              Column(
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
                                              _twitterController?.text = _twitter!;
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
                              Container(
                                width: SizeConfig.screenWidth,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if(_formKey.currentState!.validate()){
                                      setModalState(() {
                                        _loading = true;
                                      });
                                      _saveSocialAccounts(setModalState);
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
                                  //color: widget.giveaway.type == 'star'
                                   //   ? Color(0xFFD99E1D)
                                    //  : Color(0xFF1FD47D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  ],
                ),
              );
            });
      },
    ).whenComplete(() {
      if(showDialog){
        _buildConfirmDialog();
      }
    });
  }

  /// Function that saves user's socials accounts details by calling [updateMySocials] in the
  /// [RestDataSource] class
  void _saveSocialAccounts(StateSetter setModalState) async {
    var api = RestDataSource();

    String? twitter = _twitterController?.text.trim();
    String facebook = _facebookController.text.trim();
    String instagram = _instagramController.text.trim();
    await api.updateMySocials(twitter!, facebook, instagram).then((value) async {
      if(!mounted)return;
      setModalState(() {
        _loading = false;
      });
      Constants.showSuccess(
          context,
          'Successfully Saved Details',
          where: (){
            Navigator.pop(context);
            _buildConfirmDialog();
          }
      );
    }).catchError((e) {
      if(!mounted)return;
      setModalState(() {
        _loading = false;
      });
      // Constants.showError(context, error);
      print(e);
      Navigator.pop(context);
      if(!mounted)return;
      _buildConfirmDialog();
    });
  }

}

