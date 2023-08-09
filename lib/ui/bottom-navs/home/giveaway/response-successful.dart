import 'dart:io';
import 'package:awoof_app/ui/blessing/blessing.dart';
import 'package:awoof_app/ui/timeline.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

class ResponseSuccessful extends StatefulWidget {

  static const String id = 'response_successful_page';

  @override
  _ResponseSuccessfulState createState() => _ResponseSuccessfulState();
}

class _ResponseSuccessfulState extends State<ResponseSuccessful> {

  final InAppReview _inAppReview = InAppReview.instance;

  String _appStoreId = '1548208975';

  bool? _isAvailable;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _inAppReview
          .isAvailable().then(
              (bool isAvailable) => setState(() => _isAvailable = isAvailable && !Platform.isAndroid)
      ).catchError((_) {
        setState(() => _isAvailable = false);
      });
    });
    _setAppStoreId('1548208975');
  }

  void _setAppStoreId(String id) => _appStoreId = id;

  Future<void> _requestReview() => _inAppReview.requestReview();

  Future<void> _openStoreListing() => _inAppReview.openStoreListing(
    appStoreId: _appStoreId,
  );

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0XFF09AB5D),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color(0XFF09AB5D),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - 136,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 25,
                      color: Color(0XFF09AB5D),
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    'Response has been submitted',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 28,
                      fontFamily: "Bold",
                    ),
                  ),
                ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      'You’d be notified as soon as the results are out.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 17,
                        fontFamily: "Regular",
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFFFFFFF),
                      onPrimary: Color(0xFFFFFFFF),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Timeline(
                            currentIndex: 2,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: SizeConfig.screenWidth,
                      height: 56,
                      child: Center(
                        child: Text(
                          'Bless Others',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: "Bold",
                            color: Color(0xFF1FD47D),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
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
                          'More Giveaways',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: "Bold",
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _requestReview();
    super.dispose();
  }

}
