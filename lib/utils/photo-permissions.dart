import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoPermissions{

  /// This function builds and return a dialog to the user telling them to enable
  /// permission in settings
  static Future<void> buildImageRequest(BuildContext context){
    return showDialog(
      context: context,
      builder: (_) => Platform.isIOS
          ? CupertinoAlertDialog(
        title: Text("Photos is disabled for \"Awoof\""),
        content: Text("You can enable permissions for photos for this app in Settings"),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: (){
              Navigator.pop(context);
              AppSettings.openAppSettings();
            },
            child: Text("Settings"),
          ),
          CupertinoDialogAction(
            onPressed: (){
              Navigator.pop(context);
            },
            isDefaultAction: true,
            child: Text("OK"),
          )
        ],
      )
          : AlertDialog(
        title: Text("Permission to storage is disabled for \"Awoof\""),
        content: Text("You can enable permission to storage for this app in Settings"),
        actions: [
          TextButton(
            child: Text("Settings"),
            onPressed: () {
              Navigator.pop(context);
              AppSettings.openAppSettings();
            },
          ),
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

}

