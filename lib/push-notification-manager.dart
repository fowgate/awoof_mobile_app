import 'package:awoof_app/networking/rest-data.dart';
///import 'package:awoof_app/utils/firebase_core-0.7.0/lib/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'ui/timeline.dart';
import 'package:awoof_app/ui/bottom-navs/home/giveaway/giveaway-details.dart';
import 'package:awoof_app/main.dart';
import 'package:awoof_app/ui/splash-screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awoof_app/model/giveaways.dart';
import 'package:awoof_app/ui/bottom-navs/notifications.dart';

class PushNotificationsManager {

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FirebaseApp? _app;

  bool _initialized = false;

  /// Create a [AndroidNotificationChannel] for heads up notifications
  AndroidNotificationChannel? channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  /// Define a top-level named handler which background/terminated messages will
  /// call.
  ///
  /// To verify things are working, check out the native platform logs.
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage remoteMessage) async {
    await Firebase.initializeApp();
    print('Handling a background message ${remoteMessage.messageId}');
    navigate(remoteMessage.data);
  }

  Future<void> init() async {
    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (!kIsWeb) {
      _firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.', // description
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin!
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel!);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }


    _app = await Firebase.initializeApp();
    assert(_app != null);
    print('Initialized default app $_app');
    // For iOS request permission first.
    _triggerFirebase();

    String? token = await _firebaseMessaging.getToken();
    print(token);
    var rest = RestDataSource();
    await rest.sendFCM(token!).then((value) {
      print("FirebaseMessaging token: sent");
    }).catchError((e) {
      print(e);
    });
    _initialized = true;
  }

  _triggerFirebase() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) async {
      if (remoteMessage != null) {
        print("onMessage");
        navigate(remoteMessage.data);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin!.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel!.id,
                channel!.name,
                channelDescription: channel!.description,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) async {
      print('A new onMessageOpenedApp event was published!');
      print("onResume");
      navigate(remoteMessage.data);
    });
    print("FirebaseMessaging: Configured");
  }

  /// This function that checks whether a user is logged in with
  /// a [SharedPreferences] value of bool
  /// It navigates to [Index] if the value is true and [Sliders]
  /// if the value is false
  Future<bool?> _getBoolValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn');
  }

  /// Function to navigate to appropriate places when user taps on a notification
  navigate(Map<String, dynamic> message) async {
    bool? loggedIn = await _getBoolValuesSF();
    if (message.containsKey('giveaway')) {
      if (message.containsKey('giveaway') || message.containsKey("giveaway_ended")){
        if(!loggedIn!){
          return Navigator.push(
              MyApp.navigatorKey.currentContext!,
              MaterialPageRoute(builder: (context) => Splash(),)
          );
        }
        else {
          if(AllGiveaways.fromJson(json.decode(message["giveaway"])).hidden == true){
            return Navigator.push(
              MyApp.navigatorKey.currentContext!,
              MaterialPageRoute(builder: (context) => Timeline(
                currentIndex: 0,
                giveawayPayload: null,
                referral: null,
              )),
            );
          }
          else {
            return Navigator.push(
              MyApp.navigatorKey.currentContext!,
              MaterialPageRoute(builder: (context) => GiveawayDetails(
                giveaway: AllGiveaways.fromJson(json.decode(message["giveaway"])),
              )),
            );
          }
        }
      }
      else if(message.containsKey("star")){
        if(!loggedIn!){
          return Navigator.push(
              MyApp.navigatorKey.currentContext!,
              MaterialPageRoute(builder: (context) => Splash(),)
          );
        }
        else {
          return Navigator.push(
            MyApp.navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => Timeline(currentIndex: 0, referral: true,)),
          );
        }
      }
      else {
        if(!loggedIn!){
          return Navigator.push(
              MyApp.navigatorKey.currentContext!,
              MaterialPageRoute(builder: (context) => Splash(),)
          );
        }
        else {
          return Navigator.push(
            MyApp.navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => Notifications()),
          );
        }
      }
    }
    else {
      if(!loggedIn!){
        return Navigator.push(
            MyApp.navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => Splash(),)
        );
      }
      return Navigator.push(
        MyApp.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => Notifications()),
      );
    }
  }

}