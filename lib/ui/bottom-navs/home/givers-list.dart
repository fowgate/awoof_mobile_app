import 'dart:math';

import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/model/all-givers.dart';
import 'package:awoof_app/model/top-givers.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GiversList extends StatefulWidget {

  static const String id = 'givers_list';

  @override
  _GiversListState createState() => _GiversListState();
}

class _GiversListState extends State<GiversList> {

  final _random = Random();

  /// This variable holds the random color to use for empty user profile
  List<Color> _colors = [];

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// GlobalKey of a my RefreshIndicatorState to refresh my list items in the page
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  List<String> _allGivers = [
    "Amount Given",
    "Number of Giveaways"
  ];

  String _selectedGiver = "Amount Given";

  /// A List to hold the all the top givers sorted in amount order
  List<TopGiversWithAmount> _topGiversAmount = [];

  /// A List to hold the all the top givers sorted in count order
  List<TopGiversWithCount> _topGiversCount = [];

  /// An Integer variable to hold the length of [_topGiversCount]
  int? _topGiversLength;

  /// A List to hold the widgets of the top givers in manner of count order
  List<Widget> _topGiverContainer = [];

  /// A List to hold the widgets of the top givers in manner of amount order
  List<Widget> _topGiverAmountContainer = [];

  /// Function to fetch all the top givers from the database to [_topGiversCount]
  void _allTopGivers({bool? refresh}) async {
    Future<List<dynamic>> giveaways = futureValue.getAllGivers(refresh: refresh!);
    await giveaways.then((value) {
      _topGiversCount.clear();
      _topGiversLength = null;
      if(value.length == 0){
        if(!mounted)return;
        setState(() {
          _topGiversLength = 0;
          _topGiversCount = [];
          _topGiversAmount = [];
        });
      }
      else if (value[1].length > 0){
        if(!mounted)return;
        setState(() {
          _topGiversLength = value[1].length;
          _topGiversAmount.addAll(value[0]);
          _topGiversCount.addAll(value[1]);
        });
      }
      _setRandomColors();
    }).catchError((error){
      print(error);
      if(!mounted)return;
      Constants.showError(context, error);
    });
  }

  /// A function to build the list of all the givers in manner of count order
  Widget _buildAllGivers(){
    _topGiverContainer.clear();
    if(_topGiversCount.length > 0 && _topGiversCount.isNotEmpty){
      _topGiverContainer.add(SizedBox(width: 15));
      for (int i = 0; i < _topGiversCount.length; i++){
        var giver = _topGiversCount[i];
        _topGiverContainer.add(
            Container(
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                      width: 1,
                      color: Color(0xFFFFFFFF).withOpacity(0.2),
                    )
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 19.0, bottom: 19.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: giver.user.image != null
                                  ? CachedNetworkImage(
                                  imageUrl: giver.user.image!,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) => Container(color: Color(0xFF1F1F1F))
                              )
                                  : Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                color: _colors[i],
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  giver.user.userName!.split('').first.toUpperCase(),
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
                        SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: (SizeConfig.screenWidth! / 2 )- 30,
                              child: Text(
                                '@${giver.user.userName}', //'${giver.user.firstName} ${giver.user.lastName}',
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Regular',
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            ),
                            /*SizedBox(height: 6),
                            Text(
                              '@${giver.user.userName}',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFFFFFFF).withOpacity(0.8),
                              ),
                            ),*/
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '${giver.user.giveawaysDone} giveaway(s)',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Regular',
                        fontWeight: FontWeight.normal,
                        color: Color(0xFFFFC430),
                      ),
                    )
                  ],
                ),
              ),
            )
        );
      }
      return Column(
        children: _topGiverContainer,
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

  /// A function to build the list of all the givers in manner of amount order
  Widget _buildAllGiversAmount(){
    _topGiverAmountContainer.clear();
    if(_topGiversAmount.length > 0 && _topGiversAmount.isNotEmpty){
      _topGiverAmountContainer.add(SizedBox(width: 15));
      for (int i = 0; i < _topGiversAmount.length; i++){
        var giver = _topGiversAmount[i];
        _topGiverAmountContainer.add(
            Container(
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                      width: 1,
                      color: Color(0xFFFFFFFF).withOpacity(0.2),
                    )
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 19.0, bottom: 19.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: giver.user?.image != null
                                ? CachedNetworkImage(
                                imageUrl: giver.user!.image!,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Container(color: Color(0xFF1F1F1F))
                            )
                                : Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                color: _colors[i],
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  giver.user!.userName!.split('').first.toUpperCase(),
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
                        SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: (SizeConfig.screenWidth! / 2 )- 30,
                              child: Text(
                                '@${giver.user?.userName}', // '${giver.user.firstName} ${giver.user.lastName}',
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Regular',
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            ),
                            /*SizedBox(height: 6),
                            Text(
                              '@${giver.user.userName}',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFFFFFFF).withOpacity(0.8),
                              ),
                            ),*/
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '${giver.user?.giveawaysDone} giveaway(s)',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Regular',
                        fontWeight: FontWeight.normal,
                        color: Color(0xFFFFC430),
                      ),
                    )
                  ],
                ),
              ),
            )
        );
      }
      return Column(
        children: _topGiverAmountContainer,
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

  Future<Null> _refreshTL() {
    Future<List<dynamic>> giveaways = futureValue.getAllGivers(refresh: true);
    return giveaways.then((value) {
      _topGiversCount.clear();
      _topGiversLength = null;
      if(value.length == 0){
        if(!mounted)return;
        setState(() {
          _topGiversLength = 0;
          _topGiversCount = [];
          _topGiversAmount = [];
        });
      }
      else if (value[1].length > 0){
        if(!mounted)return;
        setState(() {
          _topGiversLength = value[1].length;
          _topGiversAmount.addAll(value[0]);
          _topGiversCount.addAll(value[1]);
        });
      }
      _setRandomColors();
    }).catchError((error){
      print(error);
      Constants.showError(context, error);
    });
  }

  void _setRandomColors(){
    _colors.clear();
    if(!mounted)return;
    setState(() {
      for(int i = 0; i < _topGiversLength!; i++){
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
    _allTopGivers(refresh: false);
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
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTL,
        key: _refreshIndicatorKey,
        color: Color(0XFF060D25),
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 35, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: SizeConfig.screenWidth! - 285,
                    child: Text(
                      'Top Givers',
                      style: TextStyle(
                        fontSize: 19,
                        fontFamily: 'Regular',
                        letterSpacing: 0.01,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                  Container(
                    width: 225,
                    height: 35,
                    child: DropdownButtonFormField(
                      value: _selectedGiver,
                      onChanged: (value) {
                        setState(() {
                          _selectedGiver = _selectedGiver;
                        });
                      },
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 16,
                        fontFamily: "Regular",
                      ),
                      iconEnabledColor: Color(0xFFE8E8E8),
                      dropdownColor: Color(0xFF1F1F1F),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xFF5FC894),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xffB9B9B9),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xFF0C0C0C),
                          ),
                        ),
                      ),
                      items: _allGivers.map((giver) {
                        return DropdownMenuItem(
                          child: Text(
                            giver,
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 16,
                              fontFamily: "Regular",
                            ),
                          ),
                          value: giver,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 7),
              Container(
                width: SizeConfig.screenWidth,
                child: Text(
                  '', //'Here are the top givers',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Regular',
                    letterSpacing: 0.01,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 26),
                      _selectedGiver == 'Amount Given'
                        ? _buildAllGiversAmount()
                        : _buildAllGivers(),
                      SizedBox(height: 40),
                    ],
                  )
                )
              ),
            ],
          ),
        ),
      )
    );
  }

}
