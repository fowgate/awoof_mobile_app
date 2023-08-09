import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:awoof_app/model/participants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:awoof_app/utils/constants.dart';

class TopWinnersList extends StatefulWidget {

  static const String id = 'top_winners_list';

  final List<Participants> topWinners;

  const TopWinnersList({
    Key? key,
    required this.topWinners
  }) : super(key: key);

  @override
  _TopWinnersListState createState() => _TopWinnersListState();
}

class _TopWinnersListState extends State<TopWinnersList> {

  final _random = Random();

  /// This variable holds the random color to use for empty user profile
  List<Color> _colors = [];

  /// A List to hold the all the top winners sorted in number of wins order
  List<Participants> _topWinners = [];

  /// A List to hold the all the top winners sorted in amount order
  List<Participants> _topWinnersAmount = [];

  List<String> _allWinner = [
    "Number of Wins",
    "Amount Won",
  ];

  String _selectedWinners = "Number of Wins";

  /// An Integer variable to hold the length of [_topWinners]
  int? _topWinnersLength;

  /// A List to hold the widgets of the top winners
  List<Widget> _numberOfWinsContainer = [];

  /// A function to build the list of all the winners sorted in number of wins order
  Widget _buildAllWinners(){
    _numberOfWinsContainer.clear();
    if(_topWinners.length > 0 && _topWinners.isNotEmpty){
      _numberOfWinsContainer.add(SizedBox(width: 15));
      for (int i = 0; i < _topWinners.length; i++){
        var winner = _topWinners[i];
        _numberOfWinsContainer.add(
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
                  // crossAxisAlignment: CrossAxisAlignment.baseline,
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
                      '${winner.count} ${winner.count! > 1 ? 'Wins' : 'Win'}',
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
        children: _numberOfWinsContainer,
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

  /// A List to hold the widgets of the top winners sorted in amount order
  List<Widget> _amountWonContainer = [];

  /// A function to build the list of all the winners sorted in amount order
  Widget _buildAllWinnersAmount(){
    _amountWonContainer.clear();
    if(_topWinnersAmount.length > 0 && _topWinnersAmount.isNotEmpty){
      _amountWonContainer.add(SizedBox(width: 15));
      for (int i = 0; i < _topWinnersAmount.length; i++){
        var winner = _topWinnersAmount[i];
        _amountWonContainer.add(
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
                  // crossAxisAlignment: CrossAxisAlignment.baseline,
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
                      winner.user?.giveawaysAmountWon != null
                          ? Constants.money(double.parse(winner.user!.giveawaysAmountWon!), 'N')
                          : 'N0.00',
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
        children: _amountWonContainer,
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

  void _setRandomColors(){
    if(!mounted)return;
    setState(() {
      for(int i = 0; i < widget.topWinners.length; i++){
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
      _topWinners = widget.topWinners;
      _topWinnersAmount.addAll(widget.topWinners);
      _topWinnersAmount.sort((a, b) => b.user!.giveawaysAmountWon!.compareTo(a.user!.giveawaysAmountWon!));
      _topWinners.sort((a, b) => b.count!.compareTo(a.count!));
      _topWinnersLength = _topWinners.length;
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
                    'Top Winners',
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
                    width: 180,
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
                  '', //'Here are the top winners',
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
                      SizedBox(height: 34),
                      _buildAllWinners(),
                      SizedBox(height: 40),
                    ],
                  )
                )
              ),
              /*_selectedWinners == 'Number of Wins'
                  ? _buildAllWinners()
                  : _buildAllWinnersAmount(),*/

            ],
          ),
        )
    );
  }

}
