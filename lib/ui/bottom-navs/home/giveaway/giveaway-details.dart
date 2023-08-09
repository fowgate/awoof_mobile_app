import 'package:awoof_app/model/giveaways.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:awoof_app/ui/bottom-navs/profile/winners.dart';
import 'giveaway-tasks.dart';
import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/networking/rest-data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:awoof_app/ui/timeline.dart';
import 'package:awoof_app/ui/bottom-navs/profile/refer.dart';

import 'giveaway-links.dart';

class GiveawayDetails extends StatefulWidget {

  final AllGiveaways giveaway;

  const GiveawayDetails({
    Key? key,
    required this.giveaway
  }) : super(key: key);

  @override
  _GiveawayDetailsState createState() => _GiveawayDetailsState();
}

class _GiveawayDetailsState extends State<GiveawayDetails> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  bool _showSpinner = false;

  /// A List of String variable to hold the giveaway conditions
  List<String> _conditions = [];

  /// A List of Widget to hold the giveaway conditions
  List<Widget> _myConditions = [];

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
      return permissionStatus[Permission.contacts] as PermissionStatus;
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

  bool _starSet = false;

  /// Setting the current user's stars to [_numberOfStars]
  void _getCurrentUser() async {
    //await futureValue.updateUser();
    await futureValue.getCurrentUser().then((user) {
      if(!mounted)return;
      setState(() {
        _numberOfStars = user!.stars!;
        _starSet = true;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _getConditions();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
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
                              // onError: (error, stackTracee){
                              //   return Container();
                              // }
                            ),
                          ),
                          height: SizeConfig.screenHeight! * 0.43,
                        ),
                        Container(
                          height: SizeConfig.screenHeight! * 0.431,
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
                               SizeConfig.screenWidth! * 0.075, 0, 0, 0
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
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
                                SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          widget.giveaway.isAnonymous!
                                              ?'Anonymous Giver'
                                              : '${widget.giveaway.user.userName}',
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
                                    SizedBox(height: 5),
                                    Container(
                                      width: SizeConfig.screenWidth! * 0.9,
                                      child: Text(
                                        widget.giveaway.isAnonymous!
                                            ? 'From Anonymous Giver with love ❤'
                                            : widget.giveaway.message as String,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Regular',
                                          color: Colors.white,
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
                    Container(
                      width: SizeConfig.screenWidth! * 0.85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        color: widget.giveaway.type == 'star' ? Color(0XFFD99E1D) : Color(0XFF09AB5D),
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
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'EXPIRES IN',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontFamily: 'Regular',
                                    color: widget.giveaway.type == 'star' ? Color(0xFFFFFFFF).withOpacity(0.5) : Color(0XFF75CFA4),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
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
              SizedBox(height: 47),
              Container(
                width: SizeConfig.screenWidth! * 0.85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _myConditions,
                ),
              ),
              SizedBox(height: 60),
              Container(
                width: SizeConfig.screenWidth! * 0.85,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if(widget.giveaway.completed! && _starSet){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Winners(
                            payload: 1,
                            giveawayId: widget.giveaway.id!,
                          ),
                        ),
                      );
                    }
                    else {
                      _checkIfParticipating();
                    }
                  },
                  child: !_showSpinner
                      ? Text(
                    widget.giveaway.completed!
                        ? 'View Winners'
                        : widget.giveaway.type == 'star' ? 'Enter Star Giveaway' : 'Enter Giveaway',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: "Bold",
                      color: Colors.white,
                    ),
                  )
                      : CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF)),
                  ),
                  //color: widget.giveaway.type == 'star' ? Color(0xFFD99E1D) : Color(0xFF1FD47D),
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
    );
  }

  /// A function to get the conditions of the giveaway
  void _getConditions(){
    if(widget.giveaway.likePostOnFacebook == true){
      _conditions.add('Like sponsor post on Facebook');
    }
    if(widget.giveaway.likeFacebook == true){
      _conditions.add('Like sponsor page on Facebook');
      /*${widget.giveaway.followPageOnFacebook}*/
    }
    if(widget.giveaway.likeTweet == true){
      _conditions.add('Like and retweet sponsor post');
    }
    if(widget.giveaway.followTwitter == true){
      _conditions.add('Follow sponsor on Twitter');
      /*${widget.giveaway.followTwitterLink}*/
    }
    if(widget.giveaway.likeInstagram == true){
      _conditions.add('Like sponsor post on Instagram');
    }
    if(widget.giveaway.followInstagram == true){
      _conditions.add('Follow sponsor on Instagram');
      /*${widget.giveaway.followInstagramLink}*/
    }
    if(widget.giveaway.type == "star"){
      _conditions.add('Submit ${widget.giveaway.star}   ⭐️');
    }
    _getConditionWidget();
  }

  /// A function that builds the widget of the giveaway conditions
  void _getConditionWidget(){
    _myConditions.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Giveaway Condition',
              style: TextStyle(
                fontSize: 19,
                fontFamily: 'Regular',
                fontWeight: FontWeight.w500,
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
            Text(
              'To win this give away;',
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Regular',
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      );
      for (int i = 0; i < _conditions.length; i++){
        _myConditions.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: '',
                    children: <TextSpan>[
                      TextSpan(
                        text: '${i+1}.',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Regular",
                          color: Color(0xFF3E4456),
                        ),
                      ),
                      TextSpan(
                        text:
                        '    ${_conditions[i]}',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Regular",
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
              ],
            )
        );
      }
    }
    else {
      _myConditions.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 17),
            Text(
              'Entry is free, no giveaway tasks to complete',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Regular',
                  color: Colors.white,
                  letterSpacing: 0.01
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      );
    }

  }

  /// This function checks if is a star giveaway and if [_numberOfStars] >=
  /// number of stars allocated for the giveaway [widget.giveaway.star]
  /// It returns true if it is greater than or false if it's not
  bool _checkStars(){
    if(widget.giveaway.type == 'star' && widget.giveaway.star != null){
      if(int.parse(_numberOfStars) >= int.parse(widget.giveaway.star!)){
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  /// A function that submits user's response of joining giveaway
  void _checkIfParticipating() async {
    if(!mounted)return;
    setState(() { _showSpinner = true; });
    if(_checkStars()){
      var api = RestDataSource();
      await api.checkIfParticipated(widget.giveaway.id!).then((value) async {
        if(value["data"]){
          Constants.showInfo(context, value["message"]);
        }
        else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GiveawayTasks(
                giveaway: widget.giveaway,
              ),
            ),
          );
        }
        if(!mounted)return;
        setState(() { _showSpinner = false; });
      }).catchError((e){
        print(e);
        setState(() {
          _showSpinner = false;
        });
        Constants.showError(context, e);
      });
    }
    else {
      if(!mounted)return;
      setState(() { _showSpinner = false; });
      _buildErrorDialog();
    }
  }

  /// Function that shows an error dialog when the user does not have enough stars
  /// for a star giveaway
  Future<void> _buildErrorDialog(){
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 20.0, left: 20, right: 20),
                child: Text(
                  'Giveaway Condition',
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
                //padding: EdgeInsets.only(top: 12, bottom: 11),
                child: Text(
                  "Oops! It looks like you don’t have enough stars",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Raleway',
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 252,
                    height: 1,
                    color: Color(0xFF9C9C9C).withOpacity(0.44),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        PermissionStatus permissionStatus = await _getContactPermission();
                        if (permissionStatus == PermissionStatus.granted) {
                          Navigator.pop(context);
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
                        } else {
                          _askPermissions();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 12.0, bottom: 11),
                        child: Text(
                          'Earn more',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Raleway',
                              color: Color(0xFF1FD47D)
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}
