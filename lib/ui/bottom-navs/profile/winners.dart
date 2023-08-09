import 'dart:math';
import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/model/participants.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:awoof_app/ui/timeline.dart';
import 'package:awoof_app/ui/welcome.dart';

import 'package:awoof_app/utils/screenshot-1.3.0/lib/screenshot.dart';

class Winners extends StatefulWidget {

  /// Object id of the giveaway
  final String giveawayId;

  /// This value holds number for which the page is navigating from
  /// 1 for [Contests]
  /// 2 for [MyGiveaways]
  final int payload;

  static const String id = 'winners_page';

  const Winners({
    Key? key,
    required this.giveawayId,
    required this.payload
  }) : super(key: key);

  @override
  _WinnersState createState() => _WinnersState();
}

class _WinnersState extends State<Winners> {

  final _random = Random();

  /// This variable holds the random color to use for empty user profile
  List<Color> _colors = [];

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  String _platformVersion = 'Unknown';

  String _androidUrl = 'https://play.google.com/store/apps/details?id=com.awoof.mobile_app';

  String _iosUrl = 'https://apps.apple.com/ng/app/philantro-the-giveaway-app/id1548208975';

  String _downloadUrl = 'https://www.awoofapp.com/download';

  /// A List to hold all the winners
  List<Participants> _winners = [];

  /// An Integer variable to hold the length of [_winners]
  int? _winnersLength;

  /// A List to hold the widgets of the giveaways
  List<Widget> _winnerContainer = [];

  /// Function to fetch all the winners of a giveaway from the database to
  /// [_winners]
  void _allWinners() async {
    Future<List<Participants>> winners = futureValue.getGiveawayWinners(widget.giveawayId);
    await winners.then((value) {
      _winners.clear();
      _winnersLength = null;
      if(value.isEmpty || value.length == 0 || value == null ){
        if(!mounted)return;
        Constants.showInfo(
            context,
            'No Winners yet',
            where: (){
              Navigator.pop(context);
            });
      }
      else if (value.length > 0){
        if(!mounted)return;
        setState(() {
          _winnersLength = value.length;
          _winners.addAll(value.reversed);
        });
        _setRandomColors();
      }
    }).catchError((error){
      print(error);
      Constants.showError(context, error);
    });
  }

  /// A function to build the list of all winners of this giveaway
  Widget _buildWinnerList() {
    _winnerContainer.clear();
    if(_winners.length > 0 && _winners.isNotEmpty && _winners != null){
      _winnerContainer.add(SizedBox(height: 29));
      for (int i = 0; i < _winners.length; i++){
        var winner = _winners[i];
        _winnerContainer.add(
            GestureDetector(
              onTap: (){
                if(winner.user!.userName == _username){
                  Navigator.popUntil(context, ModalRoute.withName(Welcome.id));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Timeline(
                        currentIndex: 3,
                      ),
                    ),
                  );
                }
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
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: winner.user!.image != null
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
                          Text(
                            '${winner.user?.userName}',
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Regular',
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '${winner.user?.location}',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Regular',
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFFFFFF).withOpacity(0.8),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
        );
      }
      /*if(widget.payload == 2){
        _winnerContainer.add(
            Column(
              children: [
                SizedBox(height: 176),
                Container(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 35),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Share on Social Media',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Regular",
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF021642),
                        ),
                      ),
                      SizedBox(height: 17),
                      Container(
                        height: 1,
                        width: 270,
                        color: Color(0xFFBCBCBC).withOpacity(0.32),
                      ),
                      SizedBox(height: 19),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: (){
                              _shareWhatsapp();
                            },
                            child: Image.asset(
                              'assets/images/whatsapp.png',
                              width: 36,
                              height: 36,
                              fit: BoxFit.contain,
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              _shareTwitter();
                            },
                            child: Image.asset(
                              'assets/images/twitter.png',
                              width: 36,
                              height: 36,
                              fit: BoxFit.contain,
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              _shareInstagramStory();
                            },
                            child: Image.asset(
                              'assets/images/instagram.png',
                              width: 36,
                              height: 36,
                              fit: BoxFit.contain,
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              _shareFacebookStory();
                            },
                            child: Image.asset(
                              'assets/images/facebook.png',
                              width: 75.27,
                              height: 14.66,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
        );
      }*/
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: _winnerContainer,
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

  Future<void> _initPlatformState() async {
    String? platformVersion;
    if (!mounted) return;
    setState(() {
      _platformVersion = platformVersion!;
    });
  }

  /// Create an instance of ScreenshotController
  ScreenshotController _screenshotController = ScreenshotController();

  /// A double variable to hold the username
  String _username = '';

  /// Setting the current user's stars to [_username]
  void _getCurrentUser() async {
    await futureValue.updateUser();
    await futureValue.getCurrentUser().then((user) {
      if(!mounted)return;
      setState(() {
        _username = user!.userName!;
      });
    }).catchError((Object error) {
      print(error);
    });
  }

  void _setRandomColors(){
    if(!mounted)return;
    setState(() {
      for(int i = 0; i < _winnersLength!; i++){
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
    _getCurrentUser();
    _allWinners();
    _initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Screenshot(
      controller: _screenshotController,
      child: Scaffold(
        backgroundColor: Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
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
              Container(
                width: SizeConfig.screenWidth,
                child: Text(
                  'Winners List',
                  style: TextStyle(
                    fontSize: 19,
                    fontFamily: 'Regular',
                    letterSpacing: 0.01,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 43),
                      _buildWinnerList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
