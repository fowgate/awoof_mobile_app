import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationPermissionCheck{

  Future<bool> checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return false;
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return true;
  }

  /// This function builds and return a dialog to the user telling them to enable
  /// permission in settings
  Future<void> buildLocationRequest(BuildContext context){
    return showDialog(
      context: context,
      builder: (_) => Platform.isIOS
          ? CupertinoAlertDialog(
        title: Text("Location is disabled for \"Awoof\""),
        content: Text("You can enable location for this app in Settings"),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: (){
              Navigator.pop(context);
              AppSettings.openLocationSettings();
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
        title: Text("Location is disabled for \"Awoof\""),
        content: Text("You can enable location for this app in Settings"),
        actions: [
          TextButton(
            child: Text("Settings"),
            onPressed: () {
              Navigator.pop(context);
              AppSettings.openLocationSettings();
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