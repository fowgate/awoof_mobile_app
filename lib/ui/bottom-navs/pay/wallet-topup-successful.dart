import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/ui/timeline.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:flutter/material.dart';

/// A stateful widget class to display a withdraw success page
class TopUpSuccess extends StatefulWidget {

  static const String id = 'topup_success_page';

  /*final Banks bank;

  final double transactionValue;

  const TopUpSuccess({
    Key key,
    @required this.bank,
    @required this.transactionValue,
  }) : super(key: key);*/

  @override
  _TopUpSuccessState createState() => _TopUpSuccessState();
}

class _TopUpSuccessState extends State<TopUpSuccess> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      body: Container(
        width: SizeConfig.screenWidth,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 24.67),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0XFF02CF6D),
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(height: 21),
                Container(
                  width: SizeConfig.screenWidth! - 80,
                  child: Text(
                    'Transaction Successful!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Bold',
                      fontSize: 22,
                    ),
                  ),
                ),
                SizedBox(height: 60),
                Container(
                  width: SizeConfig.screenWidth,
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Color(0XFF565656).withOpacity(0.1),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        width: (SizeConfig.screenWidth! - 60) / 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Bank',
                              style: TextStyle(
                                color: Color(0XFF001431).withOpacity(0.5),
                                fontSize: 14,
                                fontFamily: 'Regular',
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Access Bank',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color(0XFF001431),
                                  fontSize: 17,
                                  fontFamily: 'Regular',
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: (SizeConfig.screenWidth! - 60) / 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'Account Number',
                              style: TextStyle(
                                color: Color(0XFF001431).withOpacity(0.5),
                                fontSize: 14,
                                fontFamily: 'Regular',
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '0235554593',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color(0XFF001431),
                                  fontSize: 17,
                                  fontFamily: 'Regular',
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  width: SizeConfig.screenWidth,
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Color(0XFF565656).withOpacity(0.1),
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Account Name',
                        style: TextStyle(
                          color: Color(0XFF001431).withOpacity(0.5),
                          fontSize: 14,
                          fontFamily: 'Regular',
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Farawe Taiwo Hassan',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color(0XFF001431),
                            fontSize: 17,
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  width: SizeConfig.screenWidth,
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Color(0XFF565656).withOpacity(0.1),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        width: (SizeConfig.screenWidth! - 60) / 2,
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Amount',
                              style: TextStyle(
                                color: Color(0XFF001431).withOpacity(0.5),
                                fontSize: 14,
                                fontFamily: 'Regular',
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'N4,500.00',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color(0XFF001431),
                                  fontSize: 17,
                                  fontFamily: 'Regular',
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: (SizeConfig.screenWidth! - 60) / 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'Fees (5%)',
                              style: TextStyle(
                                color: Color(0XFF001431).withOpacity(0.5),
                                fontSize: 14,
                                fontFamily: 'Regular',
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'N100.00',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color(0XFF001431),
                                  fontSize: 17,
                                  fontFamily: 'Regular',
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  width: SizeConfig.screenWidth,
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Color(0XFF565656).withOpacity(0.1),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        width: (SizeConfig.screenWidth! - 60) / 2,
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Transaction Reference',
                              style: TextStyle(
                                color: Color(0XFF001431).withOpacity(0.5),
                                fontSize: 14,
                                fontFamily: 'Regular',
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '5u3784839',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color(0XFF001431),
                                  fontSize: 17,
                                  fontFamily: 'Regular',
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: (SizeConfig.screenWidth! - 60) / 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'Total',
                              style: TextStyle(
                                color: Color(0XFF001431).withOpacity(0.5),
                                fontSize: 14,
                                fontFamily: 'Regular',
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'N4,600.00',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color(0XFF001431),
                                  fontSize: 21,
                                  fontFamily: 'Bold',
                                  fontWeight: FontWeight.normal
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 35),
                GestureDetector(
                  onTap: (){
                    Navigator.pushReplacementNamed(context, Timeline.id);
                  },
                  child: Container(
                    width: SizeConfig.screenWidth! - 30,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFF02CF6D),
                      borderRadius: BorderRadius.all(
                          Radius.circular(4)
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Go Home',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Bold",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
