import 'dart:math';
import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/model/giveaways.dart';
import 'package:awoof_app/model/participants.dart';
import 'package:awoof_app/model/top-givers.dart';
import 'package:awoof_app/ui/blessing/blessing.dart';
import 'package:awoof_app/ui/bottom-navs/home/giveaway/giveaway-details.dart';
import 'package:awoof_app/ui/bottom-navs/home/givers-list.dart';
import 'package:awoof_app/ui/bottom-navs/home/search.dart';
import 'package:awoof_app/ui/bottom-navs/profile/refer.dart';
import 'package:awoof_app/ui/timeline.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'recent-winners-list.dart';
import 'top-winners-list.dart';
import '../notifications.dart';
import 'dart:async';

class Home extends StatefulWidget {

  final dynamic payload;

  const Home({
    Key? key,
    this.payload
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Timer? _timer;

  final _random = Random();

  /// This variable holds the random color to use for empty user profile
  List<Color> _colors = [];

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// GlobalKey of a my RefreshIndicatorState to refresh my list items in the page
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  /// A String variable to hold the user's name
  String _name = '';

  /// A String variable to hold the user's image url
  String _imageUrl = '';

  /// A String variable to hold the user's ratings
  String _ratings = '0';

  /// A String variable to hold the total winners
  String _totalWinners = "0";

  /// A String variable to hold the total give aways processed
  String _giveawaysProcessed = "0";

  /// A double variable to hold the total money
  double _totalMoney = 0;

  final _nf = NumberFormat("#,##0", "en_US");

  /// Setting the current user's name logged in to [_name]
  void _getCurrentUser() async {
    await futureValue.updateUser();
    await futureValue.getCurrentUser().then((user) {
      if(!mounted)return;
      setState(() {
        _name = user!.firstName!;
        _imageUrl = user.image!;
        _ratings = user.stars!;
      });
      if(widget.payload != null){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GiveawayDetails(
              giveaway: AllGiveaways.fromJson(widget.payload),
            ),
          ),
        );
      }
    }).catchError((Object error) {
      print(error);
    });
  }

  int currentIndex = 0;

  Widget view(context, index) {
    List views = [Container()];
    return views[index];
  }

  /// A List to hold the all the top givers
  List<TopGiversWithAmount> _topGivers = [];

  /// An Integer variable to hold the length of [_topGivers]
  int? _topGiversLength;

  /// A List to hold the widgets of the top givers
  List<Widget> _topGiverContainer = [];

  /// A List to hold the all the top winners
  List<Participants> _topWinners = [];

  /// An Integer variable to hold the length of [_topWinners]
  int? _topWinnersLength;

  /// A List to hold the widgets of the top winners
  List<Widget> _topWinnerContainer = [];

  /// A List to hold the all the recent winners
  List<Participants> _recentWinners = [];

  /// An Integer variable to hold the length of [_recentWinners]
  int? _recentWinnersLength;

  /// A List to hold the widgets of the recent winners
  List<Widget> _recentWinnerContainer = [];

  /// A List to hold the all the giveaways
  List<AllGiveaways> _giveaways = [];

  /// An Integer variable to hold the length of [_giveaways]
  int? _giveawayLength;

  /// A List to hold the widgets of the giveaways
  List<Widget> _giveawayContainer = [];

  /// A List to hold the all the star giveaways
  List<AllGiveaways> _starGiveaways = [];

  /// An Integer variable to hold the length of [_starGiveaways]
  int? _starGiveawayLength;

  /// A List to hold the widgets of the star giveaways
  List<Widget> _starGiveawayContainer = [];

  /// Function to fetch all the total giveaway details into [_totalWinners],
  /// [_giveawaysProcessed] and [_totalMoney]
  void _totalGiveaways() async {
    Future<dynamic> giveaways = futureValue.getGiveawayDetails();
    await giveaways.then((value) {
      if(!mounted)return;
      setState(() {
        _totalWinners = _nf.format(double.parse(value['winners']));
        _giveawaysProcessed = _nf.format(double.parse(value['giveaways']));
        _totalMoney = double.parse(value['totalAmount']);
      });
    }).catchError((error){
      print(error);
      Constants.showError(context, error);
    });
  }

  /// Function to fetch all the giveaways from the database to
  /// [_giveAways]
  void _allGiveaways() async {
    Future<List<AllGiveaways>> giveaways = futureValue.getAllGiveaways(refresh: false);
    await giveaways.then((value) {
      _topAndRecentWinners();
      _allTopGivers();
      _giveaways.clear();
      _giveawayLength = null;
      _starGiveaways.clear();
      _starGiveawayLength = null;
      if(value.isEmpty || value.length == 0){
        if(!mounted)return;
        setState(() {
          _giveawayLength = 0;
          _giveaways = [];
        });
      }
      else if (value.length > 0){
        List<AllGiveaways> val = [];
        for(int i = 0; i < value.length; i++){
          if(value[i].type == 'normal' && !value[i].completed! && value[i].endAt != null){
            val.add(value[i]);
          }
          else if(value[i].type == 'star' && !value[i].completed! && value[i].endAt != null){
            _starGiveaways.add(value[i]);
          }
        }
        if(!mounted)return;
        setState(() {
          _giveawayLength = val.length;
          if((val.length) > 5){
            List<AllGiveaways> rev = val;
            _giveaways.add(rev[0]);
            _giveaways.add(rev[1]);
            _giveaways.add(rev[2]);
            _giveaways.add(rev[3]);
            _giveaways.add(rev[4]);
          }
          else {
            _giveaways.addAll(val);
          }
          _starGiveawayLength = _starGiveaways.length;
        });
      }
    }).catchError((error){
      print(error);
      Constants.showError(context, error);
    });
  }

  /// Function to refresh and fetch all the giveaways from the database to
  /// [_giveaways]
  Future<Null> _refreshGiveaways() {
    Future<List<AllGiveaways>> giveaways = futureValue.getAllGiveaways(refresh: true);
    return giveaways.then((value) async {
      _giveaways.clear();
      _giveawayLength = null;
      _starGiveaways.clear();
      _starGiveawayLength = null;
      if(value.isEmpty || value.length == 0){
        if(!mounted)return;
        setState(() {
          _giveawayLength = 0;
          _giveaways = [];
        });
      }
      else if (value.length > 0){
        List<AllGiveaways> val = [];
        for(int i = 0; i < value.length; i++){
          if(value[i].type == 'normal' && !value[i].completed! && value[i].endAt != null){
            val.add(value[i]);
          }
          else if(value[i].type == 'star' && !value[i].completed! && value[i].endAt != null){
            _starGiveaways.add(value[i]);
          }
        }
        if(!mounted)return;
        setState(() {
          _giveawayLength = val.length;
          if((val.length) > 5){
            List<AllGiveaways> rev = val;
            _giveaways.add(rev[0]);
            _giveaways.add(rev[1]);
            _giveaways.add(rev[2]);
            _giveaways.add(rev[3]);
            _giveaways.add(rev[4]);
          }
          else {
            _giveaways.addAll(val);
          }
          _starGiveawayLength = _starGiveaways.length;
        });
      }
      _refreshWinners();
      _refreshGivers();
    }).catchError((e){
      print(e);
      if(!mounted)return;
      Constants.showError(context, e);
    });
  }

  /// A function to build the list of all the all the giveaways
  Widget _buildAllGiveawaysList() {
    _giveawayContainer.clear();
    if(_giveaways.length > 0 && _giveaways.isNotEmpty){
      _giveawayContainer.add(
        SizedBox(width: 15),
      );
      for (int i = 0; i < _giveaways.length; i++){
        var giveaway = _giveaways[i];
        _giveawayContainer.add(
            GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GiveawayDetails(
                      giveaway: giveaway,
                    ),
                  ),
                );
              },
              child: Container(
                width: SizeConfig.screenWidth! < 360
                    ? SizeConfig.screenWidth! * 0.85
                    : 306,
                margin: EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 17, 15, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    giveaway.isAnonymous!
                                        ? "Anonymous Giver"
                                        : '${giveaway.user.userName}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Regular',
                                      fontWeight: FontWeight.w600,
                                      color: Color(0XFF001431),
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
                                width: SizeConfig.screenWidth! < 360
                                    ? SizeConfig.screenWidth! * 0.5
                                    : 180,
                                child: Text(
                                  giveaway.message!,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Regular',
                                    color: Color(0XFF676767),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: giveaway.isAnonymous!
                                    ? Image.asset(
                                  "assets/images/tl6.png",
                                  fit: BoxFit.cover,
                                )
                                    : (giveaway.user.image != null)
                                    ? CachedNetworkImage(
                                  imageUrl: giveaway.user.image,
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
                                      giveaway.user.userName.split('').first.toUpperCase(),
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
                    Container(
                      width: SizeConfig.screenWidth! * 0.85,
                      height: SizeConfig.screenWidth! * 0.5,
                      child: giveaway.image != null
                          ? CachedNetworkImage(
                        imageUrl: giveaway.image!,
                        width: SizeConfig.screenWidth! * 0.85,
                        height: SizeConfig.screenWidth! * 0.5,
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                        errorWidget: (context, url, error) => Container(color: Color(0xFFE8E8E8)),
                      )
                          : Image.asset(
                        'assets/images/default-image.jpeg',
                        width: SizeConfig.screenWidth! * 0.85,
                        height: SizeConfig.screenWidth! * 0.5,
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        color: Color(0xFF09AB5D),
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
                                    color: Color(0XFF75CFA4),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  Constants.money(double.parse(giveaway.amount!), 'N'),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Regular',
                                    color: Color(0xFFFFFFFF),
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
                                    color: Color(0XFF75CFA4),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  (giveaway.endAt != null && !giveaway.completed!)
                                      ?  Constants.getTimeLeft(giveaway.endAt!) ?? ''
                                      : 'Expired',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Regular',
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.history,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'POST DATE',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontFamily: 'Regular',
                                    color: Color(0XFF75CFA4),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  Constants.getTimeDifference(giveaway.createdAt!),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Regular',
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
        );
      }
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: _giveawayContainer),
      );
    }
    else if(_giveawayLength == 0){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/empty.png',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 17),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              'Bless Others',
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF)),
        ),
      ),
    );
  }

  /// A function to build the list of all the star giveaways
  Widget _buildStarGiveawaysList() {
    _starGiveawayContainer.clear();
    if(_starGiveaways.length > 0 && _starGiveaways.isNotEmpty){
      _starGiveawayContainer.add(
        SizedBox(width: 15),
      );
      for (int i = 0; i < _starGiveaways.length; i++){
        var giveaway = _starGiveaways[i];
        _starGiveawayContainer.add(
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GiveawayDetails(
                    giveaway: giveaway,
                  ),
                ),
              );
            },
            child: Container(
              width: SizeConfig.screenWidth! < 360
                  ? SizeConfig.screenWidth! * 0.85
                  : 306,
              margin: EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 17, 15, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  giveaway.isAnonymous!
                                      ? "Anonymous Giver"
                                      : '${giveaway.user.userName}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Regular',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF001431),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(
                                      Radius.circular(7),
                                    ),
                                    color: Color(0xFF09AB5D),
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
                              width: MediaQuery.of(context).size.width < 360
                                  ? MediaQuery.of(context).size.width * 0.5
                                  : 180,
                              child: Text(
                                giveaway.message!,
                                softWrap: false,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Regular',
                                  color: Color(0xFF676767),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: giveaway.isAnonymous!
                                  ? Image.asset(
                                "assets/images/tl6.png",
                                fit: BoxFit.cover,
                              )
                                  : (giveaway.user.image != null)
                                  ? CachedNetworkImage(
                                imageUrl: giveaway.user.image,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Container(color: Color(0xFFE8E8E8)),
                              )
                                  : Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: Color(0xFFD99E1D),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    giveaway.user.userName.split('').first.toUpperCase(),
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
                  Container(
                    width: SizeConfig.screenWidth! * 0.85,
                    height: SizeConfig.screenWidth! * 0.5,
                    child: giveaway.image != null
                        ? CachedNetworkImage(
                      imageUrl: giveaway.image!,
                      width: SizeConfig.screenWidth! * 0.85,
                      height: SizeConfig.screenWidth! * 0.5,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                      errorWidget: (context, url, error) => Container(color: Color(0xFFE8E8E8)),
                    )
                        : Image.asset(
                      'assets/images/default-image.jpeg',
                      width: SizeConfig.screenWidth! * 0.85,
                      height: SizeConfig.screenWidth! * 0.5,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  Container(
                    color: Color(0xFFD99E1D),
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.star_border,
                              size: 18,
                              color: Colors.white,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'STARS NEEDED',
                              style: TextStyle(
                                fontSize: 9,
                                fontFamily: 'Regular',
                                color: Color(0xFFFFFFFF).withOpacity(0.5),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${giveaway.star ?? 15} ⭐️', /// TODO
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Regular',
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
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
                                color: Color(0xFFFFFFFF).withOpacity(0.5),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              (giveaway.endAt != null && !giveaway.completed!)
                                  ? Constants.getTimeLeft(giveaway.endAt!) ?? '3 DAYS'
                                  : 'Expired',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Regular',
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.history,
                              size: 18,
                              color: Colors.white,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'POST DATE',
                              style: TextStyle(
                                fontSize: 9,
                                fontFamily: 'Regular',
                                color: Color(0xFFFFFFFF).withOpacity(0.5),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              Constants.getTimeDifference(giveaway.createdAt!),
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Regular',
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
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
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: _starGiveawayContainer),
      );
    }
    else if(_giveawayLength == 0 || _starGiveawayLength == 0){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/empty.png',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 17),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              'Bless Others',
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF)),
        ),
      ),
    );
  }


  /// Function to fetch all the top and recent winners from the database to
  /// [_topWinners] and [_recentWinners] respectively
  void _topAndRecentWinners() async {
    Future<Map<String, List<Participants>>> giveaways = futureValue.getTopAndRecentWinners(refresh: false);
    await giveaways.then((value) {
      _recentWinners.clear();
      _recentWinnersLength = null;
      _topWinners.clear();
      _topWinnersLength = null;
      List<Participants> recent = value['recent']!;
      if(recent.isEmpty || recent.length == 0){
        if(!mounted)return;
        setState(() {
          _recentWinnersLength = 0;
          _recentWinners = [];
        });
      } else if (recent.length > 0){
        if(!mounted)return;
        setState(() {
          _recentWinnersLength = value.length;
          _recentWinners.addAll(recent);
        });
      }
      List<Participants> top = value['top']!;
      if(top.isEmpty || top.length == 0){
        if(!mounted)return;
        setState(() {
          _topWinnersLength = 0;
          _topWinners = [];
        });
      } else if (recent.length > 0){
        if(!mounted)return;
        setState(() {
          _topWinnersLength = value.length;
          _topWinners.addAll(top);
          _topWinners.sort((a, b) => b.count!.compareTo(a.count!));
        });
      }
    }).catchError((error){
      print(error);
      Constants.showError(context, error);
    });
  }

  /// Function to refresh and fetch all the top and recent winners from the
  ///  database to [_topWinners] and [_recentWinners] respectively
  Future<Null> _refreshWinners() {
    Future<Map<String, List<Participants>>> giveaways = futureValue.getTopAndRecentWinners(refresh: true);
    return giveaways.then((value) {
      _recentWinners.clear();
      _recentWinnersLength = null;
      _topWinners.clear();
      _topWinnersLength = null;
      List<Participants> recent = value['recent']!;
      if(recent.isEmpty || recent.length == 0){
        if(!mounted)return;
        setState(() {
          _recentWinnersLength = 0;
          _recentWinners = [];
        });
      } else if (recent.length > 0){
        if(!mounted)return;
        setState(() {
          _recentWinnersLength = value.length;
          _recentWinners.addAll(recent);
        });
      }
      List<Participants> top = value['top']!;
      if(top.isEmpty || top.length == 0){
        if(!mounted)return;
        setState(() {
          _topWinnersLength = 0;
          _topWinners = [];
        });
      } else if (recent.length > 0){
        if(!mounted)return;
        setState(() {
          _topWinnersLength = value.length;
          _topWinners.addAll(top);
          _topWinners.sort((a, b) => b.count!.compareTo(a.count!));
        });
      }
    }).catchError((e){
      print(e);
      Constants.showError(context, e);
    });
  }

  /// A function to build the list of all the recent winners
  Widget _buildRecent(){
    _recentWinnerContainer.clear();
    if(_recentWinners.length > 0 && _recentWinners.isNotEmpty){
      _recentWinnerContainer.add(SizedBox(width: 15));
      if(_recentWinners.length > 10){
        for (int i = 0; i < 10; i++){
          var recentWinner = _recentWinners[i];
          _recentWinnerContainer.add(
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      HapticFeedback.selectionClick();
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GiveawayDetails(
                          giveaway: recentWinner.giveawayId!,
                        )
                      ),
                    );
                    },
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 30,
                              height: 30,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: recentWinner.user?.image != null
                                    ? CachedNetworkImage(
                                    imageUrl: recentWinner.user!.image!,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) => Container(color: Color(0xFFE8E8E8))
                                )
                                    : Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF09AB5D),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      recentWinner.user!.userName!.split('').first.toUpperCase(),
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
                            SizedBox(width: 5),
                            Flexible(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${recentWinner.user?.userName}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Regular',
                                        fontWeight: FontWeight.w600,
                                        color: Color(0XFF383D51),
                                      ),
                                    ),
                                    SizedBox(height: 1),
                                    Text(
                                      recentWinner.giveawayId?.endAt != null
                                          ? Constants.getTimeDifference(recentWinner.giveawayId!.endAt!)
                                          : '1 mins ago',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontFamily: 'Regular',
                                        fontWeight: FontWeight.w600,
                                        color: Color(0XFF9D9D9D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                ],
              )
          );
        }
      }
      else {
        for (int i = 0; i < _recentWinners.length; i++){
          var recentWinner = _recentWinners[i];
          _recentWinnerContainer.add(
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GiveawayDetails(
                              giveaway: recentWinner.giveawayId!,
                            )
                        ),
                      );
                    },
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 30,
                              height: 30,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: recentWinner.user?.image != null
                                    ? CachedNetworkImage(
                                    imageUrl: recentWinner.user!.image!,
                                    fit: BoxFit.cover
                                )
                                    : Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF09AB5D),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      recentWinner.user!.userName!.split('').first.toUpperCase(),
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
                            SizedBox(width: 5),
                            Flexible(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${recentWinner.user?.userName}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Regular',
                                        fontWeight: FontWeight.w600,
                                        color: Color(0XFF383D51),
                                      ),
                                    ),
                                    SizedBox(height: 1),
                                    Text(
                                      recentWinner.giveawayId?.endAt != null
                                          ? Constants.getTimeDifference(recentWinner.giveawayId!.endAt!)
                                          : '1 mins ago',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontFamily: 'Regular',
                                        fontWeight: FontWeight.w600,
                                        color: Color(0XFF9D9D9D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                ],
              )
          );
        }
      }
      return Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _recentWinnerContainer,
          ),
        ),
      );
    }
    else if(_recentWinnersLength == 0){
      return SizedBox(height: 50);
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF)),
       ),
      ),
    );
  }

  /// A function to build the list of all the top winners
  Widget _buildTop(){
    _topWinnerContainer.clear();
    if(_topWinners.length > 0 && _topWinners.isNotEmpty){
      _topWinnerContainer.add(SizedBox(width: 15));
      if(_topWinners.length > 10){
        for (int i = 0; i < 10; i++){
          var topWinner = _topWinners[i];
          _topWinnerContainer.add(
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      HapticFeedback.selectionClick();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TopWinnersList(
                            topWinners: _topWinners
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 30,
                              height: 30,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: topWinner.user?.image != null
                                    ? CachedNetworkImage(
                                    imageUrl: topWinner.user!.image!,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) => Container(color: Color(0xFFE8E8E8))
                                )
                                    : Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF09AB5D),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      topWinner.user!.userName!.split('').first.toUpperCase(),
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
                            SizedBox(width: 5),
                            Flexible(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${topWinner.user?.userName}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Regular',
                                        fontWeight: FontWeight.w600,
                                        color: Color(0XFF383D51),
                                      ),
                                    ),
                                    SizedBox(height: 1),
                                    Text(
                                      '${topWinner.count} Wins',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontFamily: 'Regular',
                                        fontWeight: FontWeight.w600,
                                        color: Color(0XFF9D9D9D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                ],
              )
          );
        }
      }
      else {
        for (int i = 0; i < _topWinners.length; i++){
          var topWinner = _topWinners[i];
          _topWinnerContainer.add(
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TopWinnersList(
                              topWinners: _topWinners
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 30,
                              height: 30,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: topWinner.user?.image != null
                                    ? CachedNetworkImage(
                                    imageUrl: topWinner.user!.image!,
                                    fit: BoxFit.contain
                                )
                                    : Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF09AB5D),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      topWinner.user!.userName!.split('').first.toUpperCase(),
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
                            SizedBox(width: 5),
                            Flexible(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${topWinner.user?.userName}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Regular',
                                        fontWeight: FontWeight.w600,
                                        color: Color(0XFF383D51),
                                      ),
                                    ),
                                    SizedBox(height: 1),
                                    Text(
                                      'Won ${topWinner.count}',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontFamily: 'Regular',
                                        fontWeight: FontWeight.w600,
                                        color: Color(0XFF9D9D9D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                ],
              )
          );
        }
      }
      return Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _topWinnerContainer,
          ),
        ),
      );
    }
    else if(_topWinnersLength == 0){
      return SizedBox(height: 50);
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF)),
        ),
      ),
    );
  }


  /// Function to fetch all the top givers from the database to [_topGivers]
  void _allTopGivers() async {
    Future<List<TopGiversWithAmount>> givers = futureValue.getTopGivers(refresh: false);
    await givers.then((value) {
      _topGivers.clear();
      _topGiversLength = null;
      if(value.length == 0){
        if(!mounted)return;
        setState(() {
          _topGiversLength = 0;
          _topGivers = [];
        });
      } else if (value.length > 0){
        if(!mounted)return;
        setState(() {
          _topGiversLength = value.length;
          _topGivers.addAll(value);
        });
      }
    }).catchError((error){
      print(error);
      Constants.showError(context, error);
    });
  }

  /// Function to refresh and fetch all the top givers from the database to
  /// [_topGivers]
  Future<Null> _refreshGivers() {
    Future<List<TopGiversWithAmount>> givers = futureValue.getTopGivers(refresh: true);
    return givers.then((value) {
      _topGivers.clear();
      _topGiversLength = null;
      if(value.length == 0){
        if(!mounted)return;
        setState(() {
          _topGiversLength = 0;
          _topGivers = [];
        });
      } else if (value.length > 0){
        if(!mounted)return;
        setState(() {
          _topGiversLength = value.length;
          _topGivers.addAll(value);
        });
      }
    }).catchError((e){
      print(e);
      Constants.showError(context, e);
    });
  }

  /// A function to build the list of all the top givers
  Widget _buildTopGivers(){
    _topGiverContainer.clear();
    if(_topGivers.length > 0 && _topGivers.isNotEmpty){
      _topGiverContainer.add(SizedBox(width: 15));
      if(_topGivers.length > 10){
        for (int i = 0; i < 10; i++){
          var topGiver = _topGivers[i];
          _topGiverContainer.add(
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      HapticFeedback.selectionClick();
                      Navigator.pushNamed(context, GiversList.id);
                    },
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: topGiver.user?.image != null
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(150),
                                  child: CachedNetworkImage(
                                    imageUrl: topGiver.user!.image!,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        CircularProgressIndicator(value: downloadProgress.progress),
                                    errorWidget: (context, url, error) => Container(color: Color(0xFF1F1F1F)),
                                  ),
                                )
                                : Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: _colors[i],
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  topGiver.user!.userName!.split('').first.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 44,
                                    fontFamily: 'Regular',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            )
                          ),
                          SizedBox(height: 11),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                constraints: BoxConstraints(
                                  minWidth: 50,
                                  maxWidth: 150.0,
                                ),
                                child: Text(
                                  topGiver.user!.userName!,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Regular',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFFFFFFF),
                                  ),
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
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                ],
              )
          );
        }
      }
      else {
        for (int i = 0; i < _topGivers.length; i++){
          var topGiver = _topGivers[i];
          _topGiverContainer.add(
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, GiversList.id);
                    },
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: topGiver.user?.image != null
                                ? ClipRRect(
                                borderRadius: BorderRadius.circular(150),
                                child: CachedNetworkImage(
                                    imageUrl: topGiver.user!.image!,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) => Container(color: Color(0xFF1F1F1F))
                                )
                            )
                                : Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: _colors[i],
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  topGiver.user!.userName!.split('').first.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 44,
                                    fontFamily: 'Regular',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            )
                          ),
                          SizedBox(height: 11),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                constraints: BoxConstraints(
                                  minWidth: 50,
                                  maxWidth: 150.0,
                                ),
                                child: Text(
                                  topGiver.user!.userName!,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Regular',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFFFFFFF),
                                  ),
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
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                ],
              )
          );
        }
      }
      return Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _topGiverContainer,
          ),
        ),
      );
    }
    else if(_topGiversLength == 0){
      return SizedBox(height: 50);
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF)),
        ),
      ),
    );
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

  void _setRandomColors(){
    if(!mounted)return;
    setState(() {
      for(int i = 0; i < 10; i++){
        _colors.add(
          Color.fromARGB(
            _random.nextInt(256),
            _random.nextInt(256),
            _random.nextInt(256),
            _random.nextInt(256),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _setRandomColors();
    _getCurrentUser();
    _totalGiveaways();
    _topAndRecentWinners();
    _allTopGivers();
    _allGiveaways();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) => _refreshGiveaways());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.white,
        /*leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Timeline(
                  currentIndex: 4,
                ),
              ),
            );
          },
          child: Center(
            child: Container(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _imageUrl != null && _imageUrl != ''
                    ? Image.network(
                  _imageUrl,
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
          ),
        ),*/
        leading: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Search(),
              ),
            );
          },
          child: Icon(
              Icons.search,
              size: 22,
              color: Color(0xFF09AB5D)
          ),
        ),
        title: GestureDetector(
          onTap: (){
            _refreshGiveaways();
          },
          child: Container(
            width: 90,
            child: Image.asset(
              'assets/images/awoof-blue.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            onTap: () async {
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
              } else {
                _askPermissions();
              }
            },
            child: Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.star,
                    size: 15,
                    color: Color(0XFFFFC430),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '$_ratings/30',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Bold',
                      color: Color(0XFF060D25),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 4, right: 8),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Notifications(),
                  ),
                );
              },
              child: Icon(
                Icons.notifications,
                size: 22,
                color: Color(0xFF09AB5D)
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshGiveaways,
        key: _refreshIndicatorKey,
        color: Color(0XFF060D25),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    /*Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Hello, $_name 👋🏾',
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Regular',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                size: 15,
                                color: Color(0XFFFFC430),
                              ),
                              SizedBox(width: 5),
                              Text(
                                '$_ratings/5',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Regular',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),*/
                    //SizedBox(height: 35),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecentWinnersList(
                              recentWinners: _recentWinners,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF1F1F1F),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: [
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: Color(0XFF798ED2),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(11),
                                      ),
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 14,
                                        height: 14,
                                        child: Image.asset(
                                          'assets/images/winners.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 13),
                                  Text(
                                    'Winners so far',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontFamily: 'Regular',
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 13),
                                ],
                              ),
                              Text(
                                _totalWinners,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Bold',
                                  color: Color(0XFF09AB5D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Top Givers',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, GiversList.id);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Text(
                              'View More',
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Regular',
                                color: Color(0XFF09AB5D),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
              _buildTopGivers(),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Star Giveaways ⭐️',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Regular',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              _buildStarGiveawaysList(),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        HapticFeedback.lightImpact();
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
                        } else {
                          _askPermissions();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(18),
                          ),
                          color: Color(0xFF515666),
                        ),
                        child: Text(
                          'Invite Others - Earn More ⭐️',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF09AB5D),
                            fontSize: 12,
                            fontFamily: "Regular",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'All Giveaways',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Timeline(
                                  currentIndex: 1,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Text(
                              'View More',
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Regular',
                                color: Color(0XFF09AB5D),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
              _buildAllGiveawaysList(),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Latest Winners',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecentWinnersList(
                                  recentWinners: _recentWinners,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Text(
                              'View More',
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Regular',
                                color: Color(0XFF09AB5D),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
              _buildRecent(),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Top Winners',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TopWinnersList(
                                  topWinners: _topWinners
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Text(
                              'View More',
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Regular',
                                color: Color(0XFF09AB5D),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
              _buildTop(),
              SizedBox(height: 80),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width - 30,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Blessing.id);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/gift.png',
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Bless Others',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: "Regular",
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    //color: Color(0xFF1FD47D),
                  ),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

}
