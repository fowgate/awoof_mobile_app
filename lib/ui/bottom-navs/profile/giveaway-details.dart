import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/model/giveaways.dart';
import 'package:awoof_app/ui/bottom-navs/profile/winners.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:awoof_app/model/participants.dart';

class MyGiveawayDetails extends StatefulWidget {

  final AllGiveaways giveaway;

  const MyGiveawayDetails({
    Key? key,
    required this.giveaway
  }) : super(key: key);

  @override
  _MyGiveawayDetailsState createState() => _MyGiveawayDetailsState();
}

class _MyGiveawayDetailsState extends State<MyGiveawayDetails> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  String tabSelected = 'discovery';

  /// Converting [dateTime] in string format to return a formatted time
  /// of hrs, minutes and am/pm
  String _getFormattedTime(DateTime dateTime) {
    if(dateTime == null){
      return DateFormat('d, MMM').format(DateTime.now()).toString();
    }
    return DateFormat('d, MMM').format(dateTime).toString();
  }

  /// A Map to the gender details of all the users joined
  Map<String, double> _gender = {'Male': 0, 'Female': 0};

  /// A List to hold all the winners
  List<Participants> _contests = [];

  /// An Integer variable to hold the length of [_contests]
  int? _contestsLength;

  /// A function to build the discovery of the giveaway
  Widget _buildDiscovery() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(15, 24, 15, 24),
          width: SizeConfig.screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reach',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Regular',
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Text(
                    '${_getFormattedTime(widget.giveaway.createdAt!)} - ${_getFormattedTime(widget.giveaway.endAt!)}',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Regular',
                        fontWeight: FontWeight.normal,
                        color: Colors.white.withOpacity(0.8)),
                  ),
                ],
              ),
              Text(
                  _contestsLength != null
                      ? _contestsLength.toString()
                      : ''
                ,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 19,
                    fontFamily: 'Regular',
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
          width: SizeConfig.screenWidth,
          height: 1,
          color: Color(0XAA43495A),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(15, 24, 15, 24),
          width: SizeConfig.screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Interactions',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Regular',
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Text(
                    '${_getFormattedTime(widget.giveaway.createdAt!)} - ${_getFormattedTime(widget.giveaway.endAt!)}',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Regular',
                        fontWeight: FontWeight.normal,
                        color: Colors.white.withOpacity(0.8)),
                  ),
                ],
              ),
              Text(
                _contestsLength != null
                    ? _contestsLength.toString()
                    : ''
                ,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 19,
                    fontFamily: 'Regular',
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// A function to build the activity of the giveaway
  Widget _buildActivity() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(15, 24, 15, 24),
          width: SizeConfig.screenWidth,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gender',
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Regular',
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: _buildChart(),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
          width: SizeConfig.screenWidth,
          height: 1,
          color: Color(0XAA43495A),
        ),
        SizedBox(height: 19),
        //_barChart(),
      ],
    );
  }

  /// Function to fetch all the contests of a giveaway from the database to
  /// [_contests]
  void _allContests() async {
    Future<List<Participants>> contests = futureValue.getMyGiveawayParticipants(widget.giveaway.id!);
    await contests.then((value) {
      _contests.clear();
      _contestsLength = null;
      if (value.isEmpty || value.length == 0 || value == null) {
        _contestsLength = 0;
        _contests = [];
      } else if (value.length > 0) {
        if (!mounted) return;
        setState(() {
          _contestsLength = value.length;
          _contests.addAll(value.reversed);
        });
      }
      _getStats();
    }).catchError((error) {
      print(error);
      Constants.showError(context, error);
    });
  }

  void _getStats() {
    for (int i = 0; i < _contests.length; i++) {
      if(_contests[i].user!.gender != null){
        if (_contests[i].user!.gender!.toLowerCase() == 'male') {
          _gender['Male'] = _gender['Male']! + 1;
        } else {
          _gender['Female'] = _gender['Female']! + 1;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _allContests();
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
        width: MediaQuery.of(context).size.width,
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
                              image: widget.giveaway.image! != null
                                  ? NetworkImage(widget.giveaway.image!)
                                  : Image.asset('assets/images/default-image.jpeg') as ImageProvider,
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
                                SizeConfig.screenWidth! * 0.075, 0, 0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 40,
                                  height: 40,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: widget.giveaway.user.image != null
                                        ? CachedNetworkImage(
                                        imageUrl: widget.giveaway.user.image,
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
                                              ? 'Anonymous Bird'
                                              : '${widget.giveaway.user.firstName} ${widget.giveaway.user.lastName}',

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
                                  (widget.giveaway.endAt != null && !widget.giveaway.completed!)
                                      ?  Constants.getTimeLeft(widget.giveaway.endAt!) ?? '3 DAYS'
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
              SizedBox(height: 36),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        tabSelected = 'discovery';
                      });
                    },
                    child: Container(
                      width: 107,
                      height: 45,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 3,
                            color: (tabSelected == 'discovery')
                                ? Color(0XFF09AB5D)
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Discovery',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Regular',
                            color: (tabSelected == 'discovery')
                                ? Color(0xFFFFFFFF)
                                : Color(0XFF43495A),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        tabSelected = 'activity';
                      });
                    },
                    child: Container(
                      width: 107,
                      height: 45,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 3,
                            color: (tabSelected == 'activity')
                                ? Color(0XFF09AB5D)
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Activity',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Regular',
                            color: (tabSelected == 'activity')
                                ? Color(0xFFFFFFFF)
                                : Color(0XFF43495A),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                width: SizeConfig.screenWidth,
                height: 1,
                color: Color(0XAA43495A),
              ),
              tabSelected == 'discovery' ? _buildDiscovery() : _buildActivity(), */
              SizedBox(height: 60),
              Container(
                width: SizeConfig.screenWidth! * 0.85,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Winners(
                          payload: 2,
                          giveawayId: widget.giveaway.id!,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'See Winners',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: "Bold",
                      color: Color(0xFF1FD47D),
                    ),
                  ),
                  //color: Colors.white,
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  /// Function to build my pie chart if dataMap is not empty and it's length is
  /// > 0 using pie_chart package
  Widget _buildChart() {
    if(_contestsLength == null){
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF)),
          ),
        ),
      );
    }
    if (_contestsLength! > 0 && _gender.isNotEmpty) {
      return PieChart(
        dataMap: _gender,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 32.0,
        chartRadius: MediaQuery.of(context).size.width / 2.7,
        colorList: [Color(0xFF054EA4), Color(0xFF69A3E8)],
        //showChartValueLabel: true,
        chartValuesOptions: ChartValuesOptions(
          showChartValuesInPercentage: true,
          showChartValues: true,
          showChartValuesOutside: false,
          chartValueBackgroundColor: Colors.transparent,
          decimalPlaces: 0,
          chartValueStyle: defaultChartValueStyle.copyWith(
            color: Colors.white,
          ),
        ),
        legendOptions: LegendOptions(
          showLegends: true,
          legendPosition: LegendPosition.right,
          legendTextStyle: TextStyle(
            fontSize: 12,
            fontFamily: 'Regular',
            fontWeight: FontWeight.normal,
            color: Colors.white.withOpacity(0.8)
          ),
        ),
        degreeOptions: DegreeOptions(
          initialAngle: 0,
        ),
        chartType: ChartType.disc,
      );
    }
    else if (_contestsLength == 0) {
      return Container(
        alignment: AlignmentDirectional.center,
        child: Center(child: Text("No interactions yet")),
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

}
