import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/model/giveaways.dart';
import 'package:awoof_app/ui/blessing/blessing.dart';
import 'package:awoof_app/ui/bottom-navs/profile/giveaway-details.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awoof_app/ui/bottom-navs/home/giveaway/giveaway-details.dart';

class MyGiveaways extends StatefulWidget {

  static const String id = 'my_giveaways_page';

  @override
  _MyGiveawaysState createState() => _MyGiveawaysState();
}

class _MyGiveawaysState extends State<MyGiveaways> with SingleTickerProviderStateMixin{

  String tabSelected = 'giveaways';

  TabController? _tabController;

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A List to hold the all the giveaways
  List<AllGiveaways> _giveaways = [];

  /// An Integer variable to hold the length of [_giveaways]
  int? _giveawayLength;

  /// A List to hold the widgets of the giveaways
  List<Widget> _giveawayContainer = [];

  /// Function to fetch all the giveaways from the database to
  /// [_giveAways]
  void _myGiveaways() async {
    Future<List<AllGiveaways>> giveaways = futureValue.getMyGiveaways();
    await giveaways.then((value) {
      _giveaways.clear();
      _giveawayLength = null;
      if(value.isEmpty || value.length == 0){
        if(!mounted)return;
        setState(() {
          _giveawayLength = 0;
          _giveaways = [];
        });
      } else if (value.length > 0){
        if(!mounted)return;
        setState(() {
          _giveawayLength = value.length;
          _giveaways.addAll(value);
        });
      }
    }).catchError((error){
      print(error);
      Constants.showError(context, error);
    });
  }

  /// A function to build the list of all the accounts the user has
  Widget _buildGiveawayList() {
    _giveawayContainer.clear();
    if(_giveaways.length > 0 && _giveaways.isNotEmpty){
      _giveawayContainer.add(SizedBox(height: 18));
      for (int i = 0; i < _giveaways.length; i++){
        var giveaway = _giveaways[i];
        _giveawayContainer.add(
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyGiveawayDetails(
                      giveaway: giveaway,
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 18),
                width: SizeConfig.screenWidth! * 0.85,
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
                                        : '${giveaway.user.firstName} ${giveaway.user.lastName}',
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
                                width: SizeConfig.screenWidth! * 0.5,
                                child: Text(
                                  giveaway.message!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
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
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  20,
                                ),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: giveaway.user.image != null
                                  ? CachedNetworkImage(
                                  imageUrl: giveaway.user.image,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) => Container(color: Color(0xFFE8E8E8))
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        color: Color(0XFF09AB5D),
                      ),
                      child: Padding(
                        padding:
                        const EdgeInsets.fromLTRB(15, 10, 15, 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
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
                                    fontSize: 15,
                                    fontFamily: 'Bold',
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
                                      ?  Constants.getTimeLeft(giveaway.endAt!) ?? '3 DAYS'
                                      : 'Expired',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Bold',
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
                                    fontSize: 15,
                                    fontFamily: 'Bold',
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
        physics: BouncingScrollPhysics(),
        child: Column(
          children: _giveawayContainer,
        ),
      );
    }
    else if(_giveawayLength == 0){
      return Container(
        width: 300,
        height: SizeConfig.screenHeight! - 183,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/empty.png',
              width: SizeConfig.screenWidth! * 0.712,
              fit: BoxFit.contain,
            ),
            Container(
              width: SizeConfig.screenWidth! * 0.85,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Blessing.id);
                },
                child: Text(
                  'Bless Others',
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: "Bold",
                    color: Color(0xFF1FD47D),
                  ),
                ),
                //color: Colors.white,
              ),
            ),
          ],
        ),
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


  /// A List to hold the all the giveaway contests
  List<AllGiveaways> _giveawayContests = [];

  /// An Integer variable to hold the length of [_giveawayContests]
  int? _giveawayContestLength;

  /// A List to hold the widgets of the giveaway contests
  List<Widget> _giveawayContestsContainer = [];

  /// Function to fetch all the giveaway contests from the database to
  /// [_giveawayContests]
  void _allGiveawayContests() async {
    Future<List<AllGiveaways>> giveaways = futureValue.getAllGiveawayContests();
    await giveaways.then((value) {
      _giveawayContests.clear();
      _giveawayContestLength = null;
      if(value.isEmpty || value.length == 0){
        if(!mounted)return;
        setState(() {
          _giveawayContestLength = 0;
          _giveawayContests = [];
        });
      } else if (value.length > 0){
        if(!mounted)return;
        setState(() {
          _giveawayContestLength = value.length;
          _giveawayContests.addAll(value.reversed);
        });
      }
    }).catchError((error){
      print(error);
      Constants.showError(context, error);
    });
  }

  /// A function to build the list of all the giveaway contests
  Widget _buildContestList() {
    _giveawayContestsContainer.clear();
    if(_giveawayContests.length > 0 && _giveawayContests.isNotEmpty){
      _giveawayContestsContainer.add(SizedBox(height: 25));
      for (int i = 0; i < _giveawayContests.length; i++){
        var giveaway = _giveawayContests[i];
        _giveawayContestsContainer.add(
            GestureDetector(
              onTap: (){
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
                margin: EdgeInsets.only(bottom: 15),
                width: SizeConfig.screenWidth! - 60,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 17, 15, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: 40,
                                height: 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child:  giveaway.isAnonymous!
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
                              SizedBox(width: 15),
                              Row(
                                children: <Widget>[
                                  Text(
                                    giveaway.isAnonymous!
                                        ? "Anonymous Giver"
                                        : '${giveaway.user.firstName} ${giveaway.user.lastName}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Regular',
                                      fontWeight:
                                      FontWeight.w600,
                                      color: Color(0XFF001431),
                                    ),
                                  ),
                                  SizedBox(width: 5),
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
                          SizedBox(height: 15),
                          Container(
                            width: SizeConfig.screenWidth! - 90,
                            child: Text(
                              giveaway.message!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Regular',
                                color: Color(0XFF676767),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: Color(0XFFF2F2F2),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        color: Color(0xFFFFFFFF),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Opacity(
                                  opacity: 0.3,
                                  child: Image.asset(
                                    'assets/images/cash-grey.png',
                                    width: 18,
                                    height: 18,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'AMOUNT',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontFamily: 'Regular',
                                    color: Color(0XFF808998),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  Constants.money(double.parse(giveaway.amount!), 'N'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Bold',
                                    color: Color(0XFF09AB5D),
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
                                  color: Color(0XFFD0D0D0),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'EXPIRES IN',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontFamily: 'Regular',
                                    color: Color(0XFF808998),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  (giveaway.endAt != null && !giveaway.completed!)
                                      ?  Constants.getTimeLeft(giveaway.endAt!) ?? '3 DAYS'
                                      : 'Expired',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Regular',
                                    color: Color(0XFF031C19),
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
                                  color: Color(0XFFD0D0D0),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'POST DATE',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontFamily: 'Regular',
                                    color: Color(0XFF808998),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  Constants.getTimeDifference(giveaway.createdAt!),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Regular',
                                    color: Color(0XFF031C19),
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
        physics: BouncingScrollPhysics(),
        child: Column(
          children: _giveawayContestsContainer,
        ),
      );
    }
    else if(_giveawayContestLength == 0){
      return Container(
        width: 300,
        height: SizeConfig.screenHeight!- 183,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/empty.png',
              width: SizeConfig.screenWidth! * 0.712,
              fit: BoxFit.contain,
            ),
            Container(
              width: SizeConfig.screenWidth! * 0.85,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Blessing.id);
                },
                child: Text(
                  'Bless Others',
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: "Bold",
                    color: Color(0xFF1FD47D),
                  ),
                ),
                //color: Colors.white,
              ),
            ),
          ],
        ),
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _myGiveaways();
    _allGiveawayContests();
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
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TabBar(
                  physics: BouncingScrollPhysics(),
                  controller: _tabController,
                  indicatorColor: Color(0xFF09AB5D),
                  isScrollable: false,
                  labelColor: Color(0xFFFFFFFF),
                  labelStyle: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Regular',
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Regular',
                  ),
                  unselectedLabelColor: Color(0xFF43495A),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 2,
                  tabs:[
                    Tab(text: 'Giveaways Sponsored'),
                    Tab(text: 'Giveaways Entered'),
                  ]
              ),
              Container(
                width: SizeConfig.screenWidth,
                height: 1,
                color: Color(0xAA43495A),
              ),
              SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  controller: _tabController,
                  children: [
                    _buildGiveawayList(),
                    _buildContestList()
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
