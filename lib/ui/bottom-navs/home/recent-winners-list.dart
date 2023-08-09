import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:awoof_app/model/participants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:awoof_app/ui/bottom-navs/profile/winners.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/ui/bottom-navs/home/giveaway/giveaway-details.dart';

class RecentWinnersList extends StatefulWidget {

  static const String id = 'recent_winners_page';

  final List<Participants> recentWinners;

  const RecentWinnersList({
    Key? key,
    required this.recentWinners
  }) : super(key: key);

  @override
  _RecentWinnersListState createState() => _RecentWinnersListState();
}

class _RecentWinnersListState extends State<RecentWinnersList> {

  final _random = Random();

  /// This variable holds the random color to use for empty user profile
  List<Color> _colors = [];

  /// A List to hold the all the recent winners
  List<Participants> _recentWinners = [];

  /// A List to hold the all the recent winners sorted in amount order
  List<Participants> _recentWinnersAmount = [];

  List<String> _allWinner = [
    "Time Won",
    "Amount Won",
  ];

  String _selectedWinners = "Time Won";

  /// An Integer variable to hold the length of [_recentWinners]
  int? _recentWinnersLength;

  /// A List to hold the widgets of the recent winners
  List<Widget> _recentWinnerContainer = [];

  /// A function to build the list of all the winners
  Widget _buildAllWinners(){
    _recentWinnerContainer.clear();
    if(_recentWinners.length > 0 && _recentWinners.isNotEmpty){
      _recentWinnerContainer.add(SizedBox(width: 15));
      for (int i = 0; i < _recentWinners.length; i++){
        var winner = _recentWinners[i];
        _recentWinnerContainer.add(
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GiveawayDetails(
                      giveaway: winner.giveawayId!,
                    ),
                  ),
                );
              },
              child: Container(
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
                    //crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: winner.user?.image != null
                                  ? CachedNetworkImage(
                                  imageUrl: winner.user!.image!,
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
                                    winner.user!.userName!.split('').first.toUpperCase(),
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
                                  '@${winner.user?.userName}',
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Regular',
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                              SizedBox(height: 6),
                              Container(
                                width: (SizeConfig.screenWidth! / 2 )- 30,
                                child: Text(
                                  '${winner.user?.location}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Regular',
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFFFFFFF).withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                          winner.giveawayId?.endAt != null
                              ? Constants.getTimeDifference(winner.giveawayId!.endAt!)
                              : '1 mins ago',
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
              ),
            )
        );
      }
      return Column(
        children: _recentWinnerContainer,
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

  /// A List to hold the widgets of the recent winners sorted in amount order
  List<Widget> _amountWinnerContainer = [];

  /// A function to build the list of all the winners sorted in amount order
  Widget _buildAllWinnersAmount(){
    _amountWinnerContainer.clear();
    if(_recentWinnersAmount.length > 0 && _recentWinnersAmount.isNotEmpty){
      _amountWinnerContainer.add(SizedBox(width: 15));
      for (int i = 0; i < _recentWinnersAmount.length; i++){
        var winner = _recentWinnersAmount[i];
        _amountWinnerContainer.add(
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GiveawayDetails(
                      giveaway: winner.giveawayId!,
                    ),
                  ),
                );
              },
              child: Container(
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
                    //crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: winner.user?.image != null
                                  ? CachedNetworkImage(
                                  imageUrl: winner.user!.image!,
                                  fit: BoxFit.contain,
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
                                    winner.user!.userName!.split('').first.toUpperCase(),
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
                                  '@${winner.user?.userName}',
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Regular',
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                              SizedBox(height: 6),
                              Container(
                                width: (SizeConfig.screenWidth! / 2 )- 30,
                                child: Text(
                                  '${winner.user?.location}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Regular',
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFFFFFFF).withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        Constants.money(double.parse(winner.giveawayId!.amountPerWinner!), 'N'),
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
              ),
            )
        );
      }
      return Column(
        children: _amountWinnerContainer,
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

  void _setRandomColors(){
    if(!mounted)return;
    setState(() {
      for(int i = 0; i < widget.recentWinners.length; i++){
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
    _setRandomColors();
    setState(() {
      _recentWinners = widget.recentWinners;
      _recentWinnersAmount.addAll(widget.recentWinners);
      _recentWinnersAmount.sort((a, b) => double.parse(b.giveawayId!.amountPerWinner!).compareTo(double.parse(a.giveawayId!.amountPerWinner!)));
      _recentWinnersLength = _recentWinners.length;
    });
    super.initState();
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
        body: Padding(
          padding: EdgeInsets.fromLTRB(30, 35, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Latest Winners',
                    style: TextStyle(
                      fontSize: 19,
                      fontFamily: 'Regular',
                      letterSpacing: 0.01,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  Container(),
                  /*Container(
                    width: 170,
                    height: 35,
                    child: DropdownButtonFormField(
                      value: _selectedWinners,
                      onChanged: (value) {
                        setState(() {
                          _selectedWinners = value;
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
                      items: _allWinner.map((winner) {
                        return DropdownMenuItem(
                          child: Text(
                            winner,
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 16,
                              fontFamily: "Regular",
                            ),
                          ),
                          value: winner,
                        );
                      }).toList(),
                    ),
                  ),*/
                ],
              ),
              SizedBox(height: 7),
              Container(
                width: SizeConfig.screenWidth,
                child: Text(
                  '', //'Here are the recent winners',
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
                      _buildAllWinners(),
                      SizedBox(height: 40),
                    ],
                  ),
                )
              ),
              /*_selectedWinners == 'Time Won'
                  ? _buildAllWinners()
                  : _buildAllWinnersAmount(),*/
            ],
          ),
        )
    );
  }

}
