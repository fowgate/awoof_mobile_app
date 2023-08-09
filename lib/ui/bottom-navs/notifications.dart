import 'dart:convert';

import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/model/notifications.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:awoof_app/ui/timeline.dart';
import 'package:awoof_app/ui/bottom-navs/home/giveaway/giveaway-details.dart';

class Notifications extends StatefulWidget {

  static const String id = 'notifications_page';

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// GlobalKey of a my RefreshIndicatorState to refresh my list items in the page
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  /// A List to hold the all the notifications user has
  List<MyNotifications> _notifications = [];

  /// An Integer variable to hold the length of [_notifications]
  int? _notificationLength;

  /// A List to hold the widgets of th notification messages
  List<Widget> _notificationMessage = [];

  /// Function to fetch all the user notifications from the database to
  /// [_notifications]
  void _allNotifications() async {
    Future<List<MyNotifications>> notifications = futureValue.getAllUserNotifications();
    await notifications.then((value) {
      if(value.isEmpty || value.length == 0){
        if(!mounted)return;
        setState(() {
          _notificationLength = 0;
          _notifications = [];
        });
      } else if (value.length > 0){
        if(!mounted)return;
        setState(() {
          _notifications.addAll(value);
          _notificationLength = value.length;
          _notifications.reversed;
        });
      }
    }).catchError((e){
      print(e);
      Constants.showError(context, e);
    });
  }

  /// A function to build the list of all the notifications user has
  Widget _buildList() {
    if(_notifications.length > 0 && _notifications.isNotEmpty){
      _notificationMessage.clear();
      for (int index = 0; index < _notifications.length; index++){
        _notificationMessage.add(
            InkWell(
              onTap: (){
                if(_notifications[index].type != null){
                  if(_notifications[index].type!.contains('giveaway') && _notifications[index].giveaway?.user != null
                      && _notifications[index].giveaway!.user.runtimeType != String){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GiveawayDetails(
                          giveaway: _notifications[index].giveaway!,
                        ),
                      ),
                    );
                  }
                  else if(_notifications[index].type!.contains('star')){
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Timeline(
                            currentIndex: 4,
                            referral: true
                        ),
                      ),
                    );
                  }
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: SizeConfig.screenWidth,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            (_notifications[index].type != null && _notifications[index].type!.contains('giveaway')
                                && _notifications[index].giveaway?.user != null && _notifications[index].giveaway?.user.runtimeType != String)
                              ? Container(
                              width: 40,
                              height: 40,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: _notifications[index].giveaway?.user.image != null
                                    ? CachedNetworkImage(
                                  imageUrl: _notifications[index].giveaway?.user.image,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) => Container(color: Color(0xFFE8E8E8)),
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
                                      _notifications[index].giveaway!.user.userName.split('').first.toUpperCase(),
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
                            )
                              : Container(
                              width: 40,
                              height: 40,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: _notifications[index].user!.image != null
                                    ? CachedNetworkImage(
                                  imageUrl: _notifications[index].user!.image!,
                                  fit: BoxFit.contain,
                                  errorWidget: (context, url, error) => Container(color: Color(0xFFE8E8E8)),
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
                                      _notifications[index].user!.userName!.split('').first.toUpperCase(),
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
                            Container(
                              width: 40,
                              height: 40,
                              child: Transform.translate(
                                offset: Offset(-1.5, -1.5),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          4,
                                        ),
                                      ),
                                      color: Color(0XFF09AB5D),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 87,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _notifications[index].message!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Regular',
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                                SizedBox(height: 17),
                                Text(
                                  Constants.getTimeDifference(_notifications[index].createdAt!),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Regular',
                                    color: Color(0XFFB2B4BC),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            )
        );
      }
      return Column(
        children: _notificationMessage,
      );
    }
    else if(_notificationLength == 0){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 30),
          Icon(
            Icons.assignment_late,
            size: 65,
            color: Colors.white,
          ),
          SizedBox(height: 17),
          Container(
            width: SizeConfig.screenWidth,
            child: Text(
              'No Notification Messages Yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontFamily: "Medium",
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }
    return SkeletonLoader(
      builder: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.5),
              radius: 20,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 10,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      items: 20,
      period: Duration(seconds: 2),
      highlightColor: Color(0xFF1F1F1F),
      direction: SkeletonDirection.btt,
    );
  }

  /// Function to refresh details of the list of all the notifications the user has
  /// similar to [_allNotifications()]
  Future<Null> _refresh() {
    Future<List<MyNotifications>> notifications = futureValue.getAllUserNotifications();
    return notifications.then((value) {
      if(!mounted)return;
      setState(() {
        _notifications.clear();
        _notificationLength = null;
      });
      if(value.isEmpty || value.length == 0){
        if(!mounted)return;
        setState(() {
          _notificationLength = 0;
          _notifications = [];
        });
      } else if (value.length > 0){
        if(!mounted)return;
        setState(() {
          _notifications.addAll(value);
          _notificationLength = value.length;
          _notifications.reversed;
        });
      }
    }).catchError((error){
      print(error);
      Constants.showError(context, error);
    });
  }

  @override
  void initState() {
    super.initState();
    _allNotifications();
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
      body: RefreshIndicator(
        onRefresh: _refresh,
        key: _refreshIndicatorKey,
        color: Color(0xFF060D25),
        child: Container(
          width: SizeConfig.screenWidth,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 15),
                Transform.translate(
                  offset: Offset(15, 0),
                  child: Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Regular',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                _buildList(),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sampleData(){
    return Column(
      children: [
        Container(
          color: Color(0XFF1F253B),
          width: SizeConfig.screenWidth,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
            child: Column(
              children: <Widget>[
                Container(
                  width: SizeConfig.screenWidth,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            width: 40,
                            height: 40,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'assets/images/user1.png',
                                width: 40,
                                height: 40,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            child: Transform.translate(
                              offset: Offset(-1.5, -1.5),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        4,
                                      ),
                                    ),
                                    color: Color(0XFF09AB5D),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 87,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Awoof don ready. Click to collect',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Regular',
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              SizedBox(height: 17),
                              Text(
                                '10 mins ago.',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Regular',
                                  color: Color(0XFFB2B4BC),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: Color(0XFF353A4C),
                ),
                SizedBox(height: 15),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  20,
                                ),
                              ),
                            ),
                            child: Image.asset(
                              'assets/images/user8.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            child: Transform.translate(
                              offset: Offset(-1.5, -1.5),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        4,
                                      ),
                                    ),
                                    color: Color(0XFF09AB5D),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 87,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Kanye Tobiloba just posted a new giveaway challenge.',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Regular',
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              SizedBox(height: 17),
                              Text(
                                '13 mins ago.',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Regular',
                                  color: Color(0XFFB2B4BC),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: Color(0XFF353A4C),
                ),
                SizedBox(height: 15),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  20,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/images/redeem.png',
                                width: 25,
                                height: 25,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 87,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Winners don ready. CLick to view winners list',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Regular',
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              SizedBox(height: 17),
                              Text(
                                '17 mins ago.',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Regular',
                                  color: Color(0XFFB2B4BC),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        Transform.translate(
          offset: Offset(15, 0),
          child: Text(
            'Older',
            style: TextStyle(
              fontSize: 17,
              fontFamily: 'Regular',
              fontWeight: FontWeight.bold,
              color: Color(0XFFBBBBBB),
            ),
          ),
        ),
        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                20,
                              ),
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/user7.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                        ),

                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 87,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'You just won N10,000 form the Wizkid giveaway. Click this baloon to accept reward.',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Regular',
                                color: Color(0XFFB2B4BC),
                              ),
                            ),
                            SizedBox(height: 17),
                            Text(
                              'Yesterday',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Regular',
                                color: Color(0XFFB2B4BC),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: Color(0XFF353A4C),
              ),
              SizedBox(height: 15),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                20,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/user6.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 87,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Davido just posted a new giveaway challenge.',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Regular',
                                color:Color(0XFFB2B4BC),
                              ),
                            ),
                            SizedBox(height: 17),
                            Text(
                              '24 December, 2020',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Regular',
                                color: Color(0XFFB2B4BC),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }

}
