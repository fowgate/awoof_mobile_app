import 'package:awoof_app/ui/register/signinemail.dart';
import 'package:awoof_app/ui/register/signupone.dart';
import 'package:awoof_app/utils/my-widgets.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class Sliders extends StatefulWidget {

  static const String id = 'sliders';

  @override
  _SlidersState createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> {

  PageController pageController = PageController();

  int index = 0;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      Duration(milliseconds: 2000),
      (timer) => carousel(),
    );
  }

  onImageChange(int page) {
    index = page;
    setState(() {
      if (page == 0) {
        indicator = Container(
          width: 73,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 29,
                height: 8,
                decoration: BoxDecoration(
                  color: Color(0XFF00859B),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Color(0XFF99CED7),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Color(0XFF99CED7),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Color(0XFF99CED7),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        );
      } else if (page == 1) {
        indicator = Container(
          width: 73,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Color(0XFF99CED7),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 29,
                height: 8,
                decoration: BoxDecoration(
                  color: Color(0XFF00859B),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Color(0XFF99CED7),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Color(0XFF99CED7),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        );
      } else if (page == 2) {
        indicator = Container(
          width: 73,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Color(0XFF99CED7),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Color(0XFF99CED7),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 29,
                height: 8,
                decoration: BoxDecoration(
                  color: Color(0XFF00859B),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Color(0XFF99CED7),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        );
      } else if (page == 3) {
        indicator = Container(
          width: 73,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Color(0XFF99CED7),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Color(0XFF99CED7),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Color(0XFF99CED7),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 29,
                height: 8,
                decoration: BoxDecoration(
                  color: Color(0XFF00859B),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  carousel() {
    if (index == 3) {
      index = 0;
      pageController.animateToPage(
        0,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    } else {
      index += 1;
      pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }
  }

  Widget indicator = Container(
    width: 73,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 29,
          height: 8,
          decoration: BoxDecoration(
            color: Color(0XFF00859B),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Color(0XFF99CED7),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Color(0XFF99CED7),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Color(0XFF99CED7),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: indicator,
        centerTitle: false,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              timer!.cancel();
              Navigator.pushNamed(context, SignInEmail.id).then((value) {
                timer = Timer.periodic(
                  Duration(milliseconds: 2500),
                      (timer) => carousel(),
                );
              });
            },
            child: Text(
              'Sign In',
              style: TextStyle(
                fontSize: 17,
                color: Color(0xFF1FD47D),
                fontWeight: FontWeight.w600,
                fontFamily: "Regular",
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: SizeConfig.screenHeight! - 80,
        width: SizeConfig.screenWidth,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: PageView(
                    controller: pageController,
                    onPageChanged: onImageChange,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: SizeConfig.screenWidth! * 0.45,
                            height: 20,
                            child: Text(
                              '01 of 04',
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0XFFC6C6C5),
                              ),
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                            width: SizeConfig.screenWidth! - 30,
                            child: Text(
                              'No Audio \nMoney',
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontFamily: 'Bold',
                                fontWeight: FontWeight.bold,
                                fontSize: 33,
                                color: Color(0XFF02CF6D),
                              ),
                            ),
                          ),
                          SizedBox(height: 13),
                          Container(
                            width: SizeConfig.screenWidth! * 0.75,
                            height: 20,
                            child: Text(
                              'All giveaways are guaranteed to pay',
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color(0XFF626262),
                              ),
                            ),
                          ),
                          SizedBox(height: 52),
                          Image.asset(
                            'assets/images/onboard1.png',
                            width: SizeConfig.screenWidth,
                            height: SizeConfig.screenHeight! * 0.341,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: SizeConfig.screenWidth! * 0.45,
                            height: 20,
                            child: Text(
                              '02 of 04',
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0XFFC6C6C5),
                              ),
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                            width: SizeConfig.screenWidth! - 30,
                            child: Text(
                              'Sharp Sharp',
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontFamily: 'Bold',
                                fontWeight: FontWeight.bold,
                                fontSize: 33,
                                color: Color(0XFF02CF6D),
                              ),
                            ),
                          ),
                          SizedBox(height: 13),
                          Container(
                            width: SizeConfig.screenWidth! * 0.7,
                            height: 20,
                            child: Text(
                              'Setup, monitor and schedule giveaway disbursements in 3 minutes or less',
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color(0XFF626262),
                              ),
                            ),
                          ),
                          SizedBox(height: 52),
                          Image.asset(
                            'assets/images/onboard2.png',
                            width: SizeConfig.screenWidth,
                            height: SizeConfig.screenHeight! * 0.341,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: SizeConfig.screenWidth! * 0.45,
                            height: 20,
                            child: Text(
                              '03 of 04',
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0XFFC6C6C5),
                              ),
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                            width: SizeConfig.screenWidth! - 30,
                            child: Text(
                              'Awoof Yapa',
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontFamily: 'Bold',
                                fontWeight: FontWeight.bold,
                                fontSize: 33,
                                color: Color(0XFF02CF6D),
                              ),
                            ),
                          ),
                          SizedBox(height: 13),
                          Container(
                            width: SizeConfig.screenWidth! * 0.70,
                            height: 20,
                            child: Text(
                              'Browse through hundreds of cash giveaways from generous brands and people, across the world',
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color(0XFF626262),
                              ),
                            ),
                          ),
                          SizedBox(height: 52),
                          Image.asset(
                            'assets/images/onboard3.png',
                            width: SizeConfig.screenWidth,
                            height: SizeConfig.screenHeight! * 0.341,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: SizeConfig.screenWidth! * 0.45,
                            height: 20,
                            child: Text(
                              '04 of 04',
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0XFFC6C6C5),
                              ),
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                            width: SizeConfig.screenWidth! - 30,
                            child: Text(
                              'Support Others',
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontFamily: 'Bold',
                                fontWeight: FontWeight.bold,
                                fontSize: 33,
                                color: Color(0XFF02CF6D),
                              ),
                            ),
                          ),
                          SizedBox(height: 13),
                          Container(
                            width: SizeConfig.screenWidth! * 0.7,
                            height: 20,
                            child: Text(
                              'Give to your favorite charities and causes from anywhere in the world with no wahala',
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color(0XFF626262),
                              ),
                            ),
                          ),
                          SizedBox(height: 52),
                          Image.asset(
                            'assets/images/onboard4.png',
                            width: SizeConfig.screenWidth,
                            height: SizeConfig.screenHeight! * 0.341,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Button(
                  onTap: (){
                    timer!.cancel();
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => SignUpOne(),
                      ),
                    ).then((value) {
                      timer = Timer.periodic(
                        Duration(milliseconds: 2500),
                            (timer) => carousel(),
                      );
                    });
                  },
                  width: SizeConfig.screenWidth! * 0.50,
                  radius: 5,
                  foregroundColor: Color(0xFF1FD47D),
                  buttonColor: Color(0xFF1FD47D),
                  child: Center(
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: "Bold",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40)
              ],
            ),
          ),
        ),
      ),
    );
  }

}
