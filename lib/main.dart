import 'package:awoof_app/ui/blessing/blessing.dart';
import 'package:awoof_app/ui/blessing/giveaway-successful.dart';
import 'package:awoof_app/ui/blessing/giveone.dart';
import 'package:awoof_app/ui/bottom-navs/home/giveaway/response-successful.dart';
import 'package:awoof_app/ui/bottom-navs/home/givers-list.dart';
import 'package:awoof_app/ui/bottom-navs/pay/wallet-topup-successful.dart';
import 'package:awoof_app/ui/bottom-navs/profile/add-bank.dart';
import 'package:awoof_app/ui/bottom-navs/profile/bank.dart';
import 'package:awoof_app/ui/bottom-navs/profile/my-giveaways.dart';
import 'package:awoof_app/ui/bottom-navs/profile/profile.dart';
import 'package:awoof_app/ui/bottom-navs/profile/refer.dart';
import 'package:awoof_app/ui/bottom-navs/profile/security.dart';
import 'package:awoof_app/ui/bottom-navs/profile/settings.dart';
import 'package:awoof_app/ui/bottom-navs/profile/social.dart';
import 'package:awoof_app/ui/bottom-navs/profile/support.dart';
import 'package:awoof_app/ui/register/signinemail.dart';
import 'package:awoof_app/ui/register/signupone.dart';
import 'package:awoof_app/ui/register/signuppin.dart';
import 'package:awoof_app/ui/sliders.dart';
import 'package:awoof_app/ui/splash-screen.dart';
import 'package:awoof_app/ui/timeline.dart';
import 'package:awoof_app/ui/welcome.dart';
// import 'package:awoof_app/utils/firebase_core-0.7.0/lib/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(options: 
   DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     // Replace with actual values
//     options: FirebaseOptions(
//       apiKey: "XXX",
//       appId: "XXX",
//       messagingSenderId: "XXX",
//       projectId: "XXX",
//     ),
//   );
//   runApp(MyApp());
// }

class MyApp extends StatefulWidget {

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
// final ThemeData theme = ThemeData();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awoof',
      debugShowCheckedModeBanner: false,
      navigatorKey: MyApp.navigatorKey,
      initialRoute: Splash.id,
      theme: ThemeData(
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xFF1FD47D)),
        appBarTheme: AppBarTheme(
          //backgroundColor: Colors.transparent
          color: Colors.transparent
        )
      ),
      routes: {
        Splash.id: (context) => Splash(),
        Welcome.id: (context) => Welcome(),
        Sliders.id: (context) => Sliders(),
        SignInEmail.id: (context) => SignInEmail(),
        SignUpOne.id: (context) => SignUpOne(),
        SignUpPin.id: (context) => SignUpPin(),
        Blessing.id: (context) => Blessing(payload: 1),
        Timeline.id: (context) => Timeline(currentIndex: 0),
        GiveOne.id: (context) => GiveOne(),
        GiveawaySuccessful.id: (context) => GiveawaySuccessful(),
        Profile.id: (context) => Profile(),
        MyGiveaways.id: (context) => MyGiveaways(),
        GiversList.id: (context) => GiversList(),
        Refer.id: (context) => Refer(),
        Social.id: (context) => Social(),
        Bank.id: (context) => Bank(),
        AddBank.id: (context) => AddBank(),
        Security.id: (context) => Security(),
        Support.id: (context) => Support(),
        Settings.id: (context) => Settings(),
        TopUpSuccess.id: (context) => TopUpSuccess(),
        ResponseSuccessful.id: (context) => ResponseSuccessful()
      },
    );
  }
}
