import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/ui/blessing/blessing.dart';
import 'package:awoof_app/ui/timeline.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {

  static const String id = 'welcome_page';

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A double variable to hold the wallet balance
  String _name = '';

  /// Setting the current user's name logged in to [_name]
  void _getCurrentUser() async {
    await futureValue.updateUser();
    await futureValue.getCurrentUser().then((user) {
      if(!mounted)return;
      setState(() {
        _name = user!.firstName!;
      });
    }).catchError((Object error) {
      print(error);
    });
  }

  @override
  void initState() {
    _getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String hour = (DateTime.now().toString()).split(' ')[1].split(':')[0];
    hour = int.parse(hour) < 12
        ? "Morning"
        : int.parse(hour) < 18 ? "Afternoon" : "Evening";
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xFF04BD64),
      appBar: AppBar(
        backgroundColor: Color(0xFF04BD64),
        title: Container(
          width: 91,
          child: Opacity(
            opacity: 0.6,
            child: Image.asset(
              'assets/images/awoof-trans.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Container(
        width: SizeConfig.screenWidth,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 54),
              Container(
                width: 50,
                child: Image.asset(
                  'assets/images/cloud.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 22),
              Text(
                'Welcome $_name',//'Good $hour, $_name',
                style: TextStyle(
                  color: Color(0xffD0F2E2),
                  fontSize: 16,
                  fontFamily: "Regular",
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: SizeConfig.screenWidth! * 0.75,
                child: Text(
                  'What would you like to do today?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xffFFFFFF),
                    fontSize: 25,
                    fontFamily: "Regular",
                  ),
                ),
              ),
              SizedBox(height: 48),
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
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
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
                },
                child: Container(
                  width: SizeConfig.screenWidth! * 0.85,
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
                  child: Center(
                    child: Text(
                      'Win Giveaways',
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: "Bold",
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

}
