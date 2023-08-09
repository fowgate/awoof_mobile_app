// ignore_for_file: unused_import

import 'dart:async';
import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/push-notification-manager.dart';
import 'package:awoof_app/ui/register/signuppin.dart';
import 'package:awoof_app/ui/sliders.dart';
import 'package:awoof_app/ui/timeline.dart';
import 'package:awoof_app/ui/welcome.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A StatefulWidget class to show the splash screen of my application
class Splash extends StatefulWidget {

  static const String id = 'splash_screen_page';

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// Calling [navigate()] before the page loads
  @override
  void initState() {
    super.initState();
    navigate();
  }

  /// A function to set a 3 seconds timer for my splash screen to show
  /// and navigate to my [welcome] screen after
  void navigate(){
    Timer( Duration(seconds: 2), () { getBoolValuesSF(); }, );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xFF09AB5D),
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/awoof-trans.png',
              width: 250,
              height: 65,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/images/splash-bottom.png',
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight! * 0.35,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  /// This function that checks whether a user is logged in with
  /// a [SharedPreferences] value of bool
  /// It navigates to [Index] if the value is true and [Sliders]
  /// if the value is false
  void getBoolValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? boolValue = prefs.getBool('loggedIn');
    if(boolValue == true){
      await futureValue.getCurrentUser().then((user) {
        if(user!.isPinSet!){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Timeline(
                currentIndex: 0,
                giveawayPayload: null,
                referral: null,
              ),
            ),
          );
        }
        else {
          Navigator.pushReplacementNamed(context, SignUpPin.id);
        }
        PushNotificationsManager().init();
      }).catchError((Object error) {
        print(error);
        Navigator.pop(context);
      });
    }
    else if(boolValue == false){
      Navigator.of(context).pushReplacementNamed(Sliders.id);
    }
    else {
      Navigator.of(context).pushReplacementNamed(Sliders.id);
    }
  }

}