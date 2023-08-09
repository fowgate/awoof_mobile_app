import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Constants{

  /// Method to capitalize the first letter of each word in [string]
  static String capitalize(String string) {
    String result = '';

    if (string == null) {
      throw ArgumentError("string: $string");
    }

    if (string.isEmpty) {
      return string;
    }

    else{
      List<String> values = string.split(' ');
      List<String> valuesToJoin = [];

      if(values.length == 1){
        result = string[0].toUpperCase() + string.substring(1);
      }
      else{
        for(int i = 0; i < values.length; i++){
          if(values[i].isNotEmpty){
            valuesToJoin.add(values[i][0].toUpperCase() + values[i].substring(1));
          }
        }
        result = valuesToJoin.join(' ');
      }

    }
    return result;
  }

  /// Method to get the first letter of each word in [string], maximum of 2
  /// letters to return
  static String profileName(String string) {
    String result = '';

    if (string == null) {
      throw ArgumentError("string: $string");
    }

    if (string.isEmpty) {
      return string;
    }

    else{
      List<String> values = string.split(' ');
      List<String> valuesToJoin = [];

      if(values.length == 1){
        result = string[0];
      }
      else{
        valuesToJoin.add(values[0][0].toUpperCase());
        valuesToJoin.add(values[1][0].toUpperCase());
        result = valuesToJoin.join(' ');
      }

    }
    return result;
  }

  /// Function to show success message with [_showAlert]
  static showSuccess(BuildContext context, String message, {bool shouldDismiss = true, Function? where}) {
    if(context != null){
      Timer.run(() => _showAlert(
          context,
          message,
          Color(0xFFE2F8FF),
          CupertinoIcons.check_mark_circled_solid,
          Color.fromRGBO(91, 180, 107, 1),
          shouldDismiss,
          where: where!
      ));
    }
  }

  /// Function to show info message with [_showAlert]
  static showInfo(BuildContext context, String message, {bool shouldDismiss = true, Function? where}) {
    if(context != null){
      Timer.run(() => _showAlert(
          context,
          message,
          Color(0xFFE7EDFB),
          Icons.info_outline,
          Color.fromRGBO(54, 105, 214, 1),
          shouldDismiss,
          where: where!
      ));
    }
  }

  /// Function to show error message with [_showAlert]
  static showError(BuildContext context, String message, {bool shouldDismiss = true}) {
    if(context != null){
      Timer.run(() => _showAlert(
          context,
          message,
          Color(0xFFFDE2E1),
          Icons.error_outline,
          Colors.red,
          shouldDismiss
      ));
    }
  }

  /// Building a custom general dialog for my toast message with dynamic details
  static _showAlert(BuildContext context, String message, Color color, IconData icon, Color iconColor, bool shouldDismiss, {Function? where}) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
          if(shouldDismiss){
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.of(context, rootNavigator: true).pop();
            }).then((value) {
              if(where != null){
                where();
              }
            });
          }
          return Material(
            type: MaterialType.transparency,
            child: WillPopScope(
              onWillPop: () async => false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10),
                              bottom: Radius.circular(10)
                          ),
                          color: color
                      ),
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            icon,
                            size: 30,
                            color: iconColor,
                          ),
                          SizedBox(width: 5),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                message,
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  /// Convert a double [value] to a currency
  static String money(double value, String currency){
    final nf = NumberFormat("#,##0.00", "en_US");
    return '$currency${nf.format(value)}';
  }

  /// A function to return the time difference from transaction date [time]
  /// till now
  static String getTimeDifference(DateTime time){
    DateTime now = DateTime.now();
    if(now.difference(time).inSeconds > 1 && now.difference(time).inSeconds < 60){
      return '${now.difference(time).inSeconds} secs ago';
    }
    else if(now.difference(time).inSeconds == 1){
      return '1 sec ago';
    }
    else if(now.difference(time).inMinutes > 1 && now.difference(time).inMinutes < 60){
      return '${now.difference(time).inMinutes} mins ago';
    }
    else if(now.difference(time).inMinutes == 1){
      return '1 min ago';
    }
    else if(now.difference(time).inHours > 1 && now.difference(time).inHours < 24){
      return '${now.difference(time).inHours} hrs ago';
    }
    else if(now.difference(time).inHours == 1){
      return '1 hr ago';
    }
    else if(now.difference(time).inDays > 1){
      return '${now.difference(time).inDays} days ago';
    }
    else if(now.difference(time).inDays == 1){
      return '1 day ago';
    }
    else {
      return '';
    }
  }

  /// A function to return the time left from transaction date [time]
  /// till now
  static String getTimeLeft(DateTime time){
    DateTime now = DateTime.now();
    if(time.difference(now).inSeconds > 1 && time.difference(now).inSeconds < 60){
      return '${time.difference(now).inSeconds} secs';
    }
    else if(time.difference(now).inSeconds == 1){
      return '1 sec';
    }
    else if(time.difference(now).inMinutes > 1 && time.difference(now).inMinutes < 60){
      return '${time.difference(now).inMinutes} mins';
    }
    else if(time.difference(now).inMinutes == 1){
      return '1 min';
    }
    else if(time.difference(now).inHours > 1 && time.difference(now).inHours < 24){
      return '${time.difference(now).inHours} hrs';
    }
    else if(time.difference(now).inHours == 1){
      return '1 hr';
    }
    else if(time.difference(now).inDays > 1){
      return '${time.difference(now).inDays} days';
    }
    else if(time.difference(now).inDays == 1){
      return '1 day';
    }
    else {
      return '';
    }
  }

}

/// setting a constant [kTextFieldDecoration] for [InputDecoration] styles
const kTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 15.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(3.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFE6E6E6), width: 1.0, style: BorderStyle.solid),
    borderRadius: BorderRadius.all(Radius.circular(3.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color:  Color(0xFF1FD47D), width: 1.0, style: BorderStyle.solid),
    borderRadius: BorderRadius.all(Radius.circular(3.0)),
  ),
);

/// setting a constant [kLinkFieldDecoration] for [InputDecoration] styles
const kLinkFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 15.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(3.0)),
  ),
  filled: true,
  fillColor: Colors.white,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, width: 2.0, style: BorderStyle.solid),
    borderRadius: BorderRadius.all(Radius.circular(3.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, width: 2.0, style: BorderStyle.solid),
    borderRadius: BorderRadius.all(Radius.circular(3.0)),
  ),
);

/// setting a constant [kCardFieldDecoration] for [InputDecoration] styles
const kCardFieldDecoration = InputDecoration(
  fillColor: Color(0xFFFFFFFF),
  contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromRGBO(41, 41, 41, 0.3), width: 1.0, style: BorderStyle.solid),
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromRGBO(41, 41, 41, 0.3), width: 2.0, style: BorderStyle.solid),
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
);

/// setting a constant [kTextBigFieldDecoration] for [InputDecoration] styles
const kTextBigFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFC3D3D4), width: 1.0, style: BorderStyle.solid),
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFC3D3D4), width: 2.0, style: BorderStyle.solid),
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
  ),
);


const kTextPinDecoration = InputDecoration(
  //contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 15.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(3.0)),
  ),
  counterText: '',
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFB9B9B9), width: 1.0, style: BorderStyle.solid),
    borderRadius: BorderRadius.all(Radius.circular(3.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF1FD47D), width: 1.0, style: BorderStyle.solid),
    borderRadius: BorderRadius.all(Radius.circular(3.0)),
  ),
);

const kPinTextStyle = TextStyle(
  color: Color(0xFF0C0C0C),
  fontSize: 25,
  fontFamily: "Regular",
);

