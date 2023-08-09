import 'package:awoof_app/ui/bottom-navs/giveaways/giveaways.dart';
import 'package:awoof_app/ui/bottom-navs/home/home.dart';
import 'package:awoof_app/ui/bottom-navs/pay/wallet.dart';
import 'package:awoof_app/ui/bottom-navs/profile/profile.dart';
import 'package:awoof_app/ui/blessing/blessing.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Timeline extends StatefulWidget {

  static const String id = 'timeline_page';

  final dynamic giveawayPayload;

  final bool? referral;

  Timeline({
    this.giveawayPayload,
    this.referral,
    required this.currentIndex
  });

  final currentIndex;

  @override
  _TimelineState createState() => _TimelineState(this.currentIndex);
}

class _TimelineState extends State<Timeline> {

  Future refreshTL() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {
      return 1;
    });
  }

  _TimelineState(this.currentIndex);

  int currentIndex;

  Widget view(context, index) {
    List views = [
      Home(/*payload: widget.giveawayPayload != null ? widget.giveawayPayload : null*/),
      Giveaways(),
      Blessing(payload: 2),
      Wallet(),
      // Notifications(),
      Profile(payload: widget.referral != null ? widget.referral : null)
    ];
    return views[index];
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0XFF060D25),
      body: view(context, currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 5,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: Color(0xFF1FD47D),
        selectedLabelStyle: TextStyle(
          fontFamily: 'Regular'
        ),
        unselectedItemColor: Color(0xFFCFCFCF),
        selectedFontSize: 10,
        unselectedFontSize: 10,
        unselectedLabelStyle: TextStyle(
            fontFamily: 'Regular'
        ),
        onTap: (index) {
          _onTabChanged(index);
        },
        items: [
          _bottomNav('home', 'home-active', 'Home'),
          _bottomNav('trophy', 'trophy-active', 'Giveaways'),
          _bottomNav('gift', 'gift', 'Post'),
          _bottomNav('wallet', 'wallet-active', 'Awoof Pay'),
          //_bottomNav('notifications', 'notifications-active', 'Notifications'),
          _bottomNav('user', 'user-active', 'Profile'),
        ],
      ),
    );
  }

  void _onTabChanged(int index){
    HapticFeedback.selectionClick();
    if(!mounted)return;
    setState(() {
      currentIndex = index;
    });
  }

  BottomNavigationBarItem _bottomNav(String icon, String activeIcon, String text){
    return BottomNavigationBarItem(
      icon: icon != 'wallet'
          ? Image.asset(
        'assets/images/$icon.png',
        width: 24,
        height: 24,
        color: Color(0xFFCFCFCF),
        fit: BoxFit.contain,
      )
          : Image.asset(
        'assets/images/$icon.png',
        width: 24,
        height: 24,
        fit: BoxFit.contain,
      ),
      activeIcon: Image.asset(
        'assets/images/$activeIcon.png',
        width: 24,
        height: 24,
        color: Color(0xFF1FD47D),
        fit: BoxFit.contain,
      ),
      label: text,
    );
  }

}
