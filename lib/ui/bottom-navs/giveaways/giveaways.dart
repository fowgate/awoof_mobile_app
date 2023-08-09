import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/model/giveaways.dart';
import 'package:awoof_app/ui/blessing/blessing.dart';
import 'package:awoof_app/ui/bottom-navs/home/giveaway/giveaway-details.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/my-widgets.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class Giveaways extends StatefulWidget {

  static const String id = 'giveaway_feed';

  @override
  _GiveawaysState createState() => _GiveawaysState();
}

class _GiveawaysState extends State<Giveaways> {

  /// GlobalKey of a my RefreshIndicatorState to refresh my list items in the page
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A List to hold all the giveaways
  List<AllGiveaways> _giveaways = [];

  /// An Integer variable to hold the length of [_giveaways]
  int? _giveawayLength;

  /// A List to hold the widgets of the giveaways
  List<Widget> _giveawayContainer = [];

  /// Function to fetch all the giveaways from the database to
  /// [_giveaways]
  void _allGiveaways() async {
    Future<List<AllGiveaways>> giveaways = futureValue.getAllGiveaways(refresh: false);
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
        List<AllGiveaways> val = [];
        for(int i = 0; i < value.length; i++){
          if(value[i].type == 'star' && value[i].endAt != null){
            val.add(value[i]);
          }
        }
        for(int i = 0; i < value.length; i++){
          if(value[i].type == 'normal' && value[i].endAt != null){
            val.add(value[i]);
          }
        }
        if(!mounted)return;
        setState(() {
          _giveawayLength = val.length;
          _giveaways.addAll(val);
        });
      }
    }).catchError((error){
      print(error);
      if(!mounted)return;
      Constants.showError(context, error);
    });
  }

  /// A function to build the list of all the giveaways
  Widget _buildGiveawayList() {
    _giveawayContainer.clear();
    _giveawayContainer.add(Container(width: SizeConfig.screenWidth, height: 5));
    if(_giveaways.length > 0 && _giveaways.isNotEmpty){
      _giveawayContainer.add(SizedBox(height: 18));
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
                margin: EdgeInsets.only(bottom: 15),
                alignment: Alignment.center,
                width: SizeConfig.screenWidth,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 17, 15, 12),
                      child: Row(
                        children: <Widget>[
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
                          SizedBox(width: 15),
                          Text(
                            giveaway.isAnonymous!
                                ? "Anonymous Giver"
                                : '${giveaway.user.userName}',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Regular',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth,
                      height: 400,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFE8E8E8), width: 1),
                      ),
                      child: giveaway.image != null
                          ? CachedNetworkImage(
                        imageUrl: giveaway.image!,
                        width: SizeConfig.screenWidth,
                        height: 400,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(color: Color(0xFFE8E8E8)),
                      )
                          : Image.asset(
                        'assets/images/default-image.jpeg',
                        width: SizeConfig.screenWidth,
                        height: 400,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/cash.png',
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Posted ${Constants.getTimeDifference(giveaway.createdAt!)} - ',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontFamily: 'Regular',
                                      color: Color(0xFF000000),
                                    ),
                                  ),
                                  Text(
                                    giveaway.completed! ? 'Expired' : 'Open',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontFamily: 'Regular',
                                      color: giveaway.completed!
                                          ? Colors.red
                                          : Color(0xFF09AB5D),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          giveaway.isAnonymous!
                              ? Text(
                           "From Anonymous Giver with love ❤",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Regular',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF000000),
                            ),
                          )
                              : Container(
                            width: SizeConfig.screenWidth,
                            alignment: Alignment.centerLeft,
                            child: ExpandableText(
                              ' ${giveaway.message}',
                              trimLines: 3,
                              username: giveaway.user.userName,
                            ),
                          ),
                        ],
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
        child: Wrap(
          children: _giveawayContainer,
        ),
      );
    }
    else if(_giveawayLength == 0){
      return Center(
        child: Container(
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
        ),
      );
    }
    return SingleChildScrollView(
      child: SkeletonLoader(
        builder: Container(
          margin: EdgeInsets.only(bottom: 15),
          alignment: Alignment.center,
          width: SizeConfig.screenWidth,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(15, 17, 15, 12),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 15),
                    Text(
                      '',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Regular',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: SizeConfig.screenWidth,
                height: 400,
                color: Colors.white,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 10,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 12,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        items: 10,
        period: Duration(seconds: 2),
        highlightColor: Color(0xFF0C0C0C),
        direction: SkeletonDirection.ltr,
      ),
    );
  }

  Future<Null> _refreshTL() {
    Future<List<AllGiveaways>> giveaways = futureValue.getAllGiveaways(refresh: true);
    return giveaways.then((value) {
      _giveaways.clear();
      _giveawayLength = null;
      if(value.isEmpty || value.length == 0){
        if(!mounted)return;
        setState(() {
          _giveawayLength = 0;
          _giveaways = [];
        });
      } else if (value.length > 0){
        List<AllGiveaways> val = [];
        for(int i = 0; i < value.length; i++){
          if(value[i].type == 'star'){
            val.add(value[i]);
          }
        }
        for(int i = 0; i < value.length; i++){
          if(value[i].type == 'normal'){
            val.add(value[i]);
          }
        }
        if(!mounted)return;
        setState(() {
          _giveawayLength = val.length;
          _giveaways.addAll(val);
        });
      }
    }).catchError((error){
      print(error);
      if(!mounted)return;
      Constants.showError(context, error);
    });
  }

  @override
  void initState() {
    _allGiveaways();
    super.initState();
    _refreshTL();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: (){
            _refreshTL();
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
        /*actions: <Widget>[
          GestureDetector(
            onTap: () async {
             Navigator.pop(context);
             Navigator.pushNamed(context, Blessing.id);
            },
            child: Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.only(right: 8.0),
              child: Image.asset(
                'assets/images/gift.png',
                fit: BoxFit.contain,
                color: Color(0xFF09AB5D),
              ),
            ),
          )
        ],*/
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTL,
        key: _refreshIndicatorKey,
        color: Color(0XFF060D25),
        child: _buildGiveawayList(),
      ),
    );
  }

}
