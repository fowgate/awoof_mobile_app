import 'package:awoof_app/ui/blessing/giveone.dart';
import 'package:awoof_app/utils/my-widgets.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:flutter/material.dart';

class Blessing extends StatefulWidget {

  static const String id = 'blessing_page';

  /// 1 for What do you want to do today
  /// 2 for post on bottom tab
  final int payload;

  const Blessing({
    Key? key,
    required this.payload
  }) : super(key: key);

  @override
  _BlessingState createState() => _BlessingState();
}

class _BlessingState extends State<Blessing> {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xFF006437),
      appBar: AppBar(
        backgroundColor: Color(0xFF006437),
        title: Container(
          width: 91,
          child: Opacity(
            opacity: 0.5,
            child: Image.asset(
              'assets/images/awoof-trans.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: widget.payload == 1 ? true : false,
        leading: widget.payload == 1 ? IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ) : Container(),
        elevation: 0,
      ),
      body: Container(
        width: SizeConfig.screenWidth,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            SizeConfig.screenWidth! * 0.075,
            0,
            SizeConfig.screenWidth! * 0.075,
            0
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 55),
                Text(
                  '',//'New Giveaway',
                  style: TextStyle(
                    color: Color(0xff80B49B),
                    fontSize: 15,
                    fontFamily: "Regular",
                  ),
                ),
                SizedBox(height: 0),
                Container(
                  width: SizeConfig.screenWidth! * 0.5,
                  child: Text(
                    '', //'Select Your Blessing',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 28,
                      fontFamily: "Regular",
                    ),
                  ),
                ),
                //SizedBox(height: 37),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, GiveOne.id);
                  },
                  child: Container(
                    width: SizeConfig.screenWidth,
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: 24,
                                height: 24,
                                child: Image.asset(
                                  'assets/images/cash.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                'Cash Giveaway',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Regular",
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 18,
                            height: 18,
                            child: Image.asset(
                              'assets/images/proceed.png',
                              fit: BoxFit.contain,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 22),
                Text(
                  'Coming Soon',
                  style: TextStyle(
                    color: Color(0xfff3f3f3),
                    fontSize: 15,
                    fontFamily: "Regular",
                  ),
                ),
                SizedBox(height: 18),
                ComingSoonContainer(
                    text: 'Airtime Giveaway',
                    url: 'assets/images/merch.png'
                ),
                SizedBox(height: 18),
                ComingSoonContainer(
                    text: 'Merchandise Giveaway',
                    url: 'assets/images/support.png'
                ),
                SizedBox(height: 18),
                ComingSoonContainer(
                    text: 'Fund a Cause',
                    url: 'assets/images/donate.png'
                ),
                SizedBox(height: 18),
                ComingSoonContainer(
                    text: 'Give to Charity',
                    url: 'assets/images/charity.png'
                ),
                SizedBox(height: 18),
                /*ComingSoonContainer(
                  text: 'Donate to Foundation',
                  url: 'assets/images/donate.png'
                ),*/
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
