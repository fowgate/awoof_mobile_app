import 'dart:ui';
import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/model/create-giveaway.dart';
import 'package:awoof_app/ui/blessing/givethree.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GiveTwoReview extends StatefulWidget {

  static const String id = 'give_two_review_page';

  final CreateGiveaway giveaway;

  final dynamic image;

  const GiveTwoReview({
    Key? key,
    required this.giveaway,
    required this.image
  }) : super(key: key);

  @override
  _GiveTwoReviewState createState() => _GiveTwoReviewState();
}

class _GiveTwoReviewState extends State<GiveTwoReview> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A List of String variable to hold the giveaway conditions
  List<String> _conditions = [];

  /// A List of Widget to hold the giveaway conditions
  List<Widget> _myConditions = [];

  /// A String variable to hold the user's full name
  String _fullName = '';

  /// A String variable to hold the user's image url
  String _imageUrl = '';

  /// Setting the current user's full name to [_fullName]
  void _getCurrentUser() async {
    await futureValue.updateUser();
    await futureValue.getCurrentUser().then((user) {
      if(!mounted)return;
      setState(() {
        _imageUrl = user!.image!;
        _fullName = '${user.firstName} ${user.lastName}';
      });
    }).catchError((Object error) {
      print(error);
    });
  }

  @override
  void initState() {
    super.initState();
    _getConditions();
    _getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Stack(
        children: <Widget>[
          Container(
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
                                  image: widget.image != null
                                      ? FileImage(widget.image!)
                                      : AssetImage('assets/images/default-image.jpeg') as ImageProvider,
                                ),
                              ),
                              height: SizeConfig.screenHeight! * 0.55 + 56,
                            ),
                            Container(
                              height:  SizeConfig.screenHeight! * 0.5502 + 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: FractionalOffset.topCenter,
                                  end: FractionalOffset.bottomCenter,
                                  colors: [
                                    Color(0XFF060D25).withOpacity(0.8),
                                    Color(0XFF060D25),
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
                                    SizedBox(height: 60),
                                    Container(
                                      width: SizeConfig.screenWidth! * 0.5,
                                      child: Text(
                                        'Confirm Your Giveaway!',
                                        style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 28,
                                          fontFamily: "Regular",
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 60),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: _imageUrl != null && _imageUrl != ''
                                          ? CachedNetworkImage(
                                        imageUrl: _imageUrl,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.contain,
                                        errorWidget: (context, url, error) => Container(color: Color(0xFFE8E8E8)),
                                      )
                                          : Icon(
                                            Icons.person,
                                            size: 25,
                                            color: Color(0xFFBDBDBD),
                                          ),
                                    ),
                                    SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              widget.giveaway.isAnonymous! ? 'Anonymous Giver' : _fullName,
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
                                        SizedBox(height: 23),
                                        Container(
                                          width: SizeConfig.screenWidth! * 0.5,
                                          child: Text(
                                            widget.giveaway.message!,
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
                            color: Color(0XFF09AB5D),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
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
                                        color: Color(0XFF75CFA4),
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
                                        color: Color(0XFF75CFA4),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      widget.giveaway.expiry!.toUpperCase(),
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
                                      'NO OF WINNERS',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontFamily: 'Regular',
                                        color: Color(0XFF75CFA4),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      widget.giveaway.numberOfWinners! > 1
                                          ? '${widget.giveaway.numberOfWinners} WINNERS'
                                          : '${widget.giveaway.numberOfWinners} WINNER',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Bold',
                                        color: Color(0xFFFFFFFF),
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
                  Container(
                    width: SizeConfig.screenWidth! * 0.85,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _myConditions,
                    ),
                  ),
                  SizedBox(height: 35),
                  Container(
                    width: SizeConfig.screenWidth! * 0.85,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GiveThree(
                              giveaway: widget.giveaway,
                              image: widget.image,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Proceed',
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: "Regular",
                          fontWeight: FontWeight.w600,
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
          Container(
            height: 80,
            child: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: Center(
                    child: Text(
                      '02 of 03',
                      style: TextStyle(
                        color: Color(0XFF989DA0),
                        fontSize: 13,
                        fontFamily: 'Regular',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  /// A function to get the conditions of the giveaway
  void _getConditions(){
    if(widget.giveaway.likePostOnFacebook!){
      _conditions.add('Like sponsor post on Facebook');
    }
    if(widget.giveaway.likeFacebook!){
      _conditions.add('Like sponsor page on Facebook');
    }
    if(widget.giveaway.likeTweet!){
      _conditions.add('Like and retweet sponsor post');
    }
    if(widget.giveaway.followTwitter!){
      _conditions.add('Follow sponsor on Twitter');
    }
    if(widget.giveaway.likeInstagram!){
      _conditions.add('Like sponsor post on Instagram');
    }
    if(widget.giveaway.followInstagram!){
      _conditions.add('Follow sponsor on Instagram');
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
              'Giveaway Tasks',
              style: TextStyle(
                fontSize: 18.5,
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
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      );
    }

  }

}
