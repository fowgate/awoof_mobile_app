import 'package:awoof_app/ui/timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:social_share/social_share.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:awoof_app/utils/size-config.dart';

class GiveawaySuccessful extends StatefulWidget {

  static const String id = 'give_away_successful_page';

  @override
  _GiveawaySuccessfulState createState() => _GiveawaySuccessfulState();
}

class _GiveawaySuccessfulState extends State<GiveawaySuccessful> {

  String _androidUrl = 'https://play.google.com/store/apps/details?id=com.awoof.mobile_app';

  String _iosUrl = 'https://apps.apple.com/ng/app/philantro-the-giveaway-app/id1548208975';

  String _downloadUrl = 'https://www.awoofapp.com/download';

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
      backgroundColor: Color(0xFF09AB5D),
      body: Container(
        width: SizeConfig.screenWidth,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  Icons.check,
                  size: 25,
                  color: Color(0XFF09AB5D),
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: SizeConfig.screenWidth! * 0.8,
                child: Text(
                  'Your Giveaway has been posted',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 29,
                    fontFamily: "Bold",
                  ),
                ),
              ),
              SizedBox(height: 44),
              Container(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 35),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Share on Social Media',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Regular",
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF021642),
                      ),
                    ),
                    SizedBox(height: 17),
                    Container(
                      height: 1,
                      width: 270,
                      color: Color(0xFFBCBCBC).withOpacity(0.32),
                    ),
                    SizedBox(height: 19),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){
                            _shareWhatsapp();
                          },
                          child: Image.asset(
                            'assets/images/whatsapp.png',
                            width: 36,
                            height: 36,
                            fit: BoxFit.contain,
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            _shareTwitter();
                          },
                          child: Image.asset(
                            'assets/images/twitter.png',
                            width: 36,
                            height: 36,
                            fit: BoxFit.contain,
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            _shareInstagramStory();
                          },
                          child: Image.asset(
                            'assets/images/instagram.png',
                            width: 36,
                            height: 36,
                            fit: BoxFit.contain,
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            _shareFacebookStory();
                          },
                          child: Image.asset(
                            'assets/images/facebook.png',
                            width: 75.27,
                            height: 14.66,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                    builder: (context) => Timeline(
                      currentIndex: 0,
                    ),
                  ),
                     (Route<dynamic> route) => false
                  );
                },
                child: Container(
                  width: SizeConfig.screenWidth,
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
                      'Return to Home',
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: "Regular",
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
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

  /// Function to share post to whatsapp status
  void _shareWhatsapp() async {
    File file = await _getFile();
    Share.shareFiles([file.path], text: "Just sponsored a cash #giveaway on ⁦‪@AwoofApp‬⁩ 🤑. ‬Tap the link below to join and win this and many more #giveaways!  \n $_downloadUrl",);
  }

  /// Function to share post to instagram story
  void _shareInstagramStory() async {
    // var picker = ImagePicker();
    //var file = await picker.getImage(source: ImageSource.gallery);
    File file = await _getFile();
    SocialShare.shareInstagramStory(imagePath: file.path,
        backgroundTopColor: "#FFFFFF",
        backgroundBottomColor: "#000000",
        attributionURL: _downloadUrl,
        appId: "2843898835847760"
    ).then((data) {
      print(data);
    });
  }

  /// Function to post tweet on twitter3
  ///
  ///
  void _shareTwitter() async {
    File file = await _getFile();
    SocialShare.shareOptions(
        "Just sponsored a cash #giveaway on ⁦‪@AwoofApp‬⁩ 🤑. ‬Tap the link below to join and win this and many more #giveaways!  \n $_downloadUrl",
        imagePath: file.path
    );
    /*SocialShare.shareTwitter(
        "Just posted a giveaway on the Awoof App. Join and participate to win",
        hashtags: ["awoof", "giveaway", "philantrogiveaways"],
        url: Platform.isAndroid ? _androidUrl : _iosUrl,
        trailingText: "\nAwoof")
        .then((data) {
      print('Successfully shared on twitter');
    });*/
  }

  /// Function to share post to facebook story
  void _shareFacebookStory() async {
    // var picker = ImagePicker();
    // var file = await picker.getImage(source: ImageSource.gallery);
    File file = await _getFile();

    Platform.isAndroid
        ? SocialShare.shareFacebookStory(imagePath: file.path,
        backgroundTopColor: "#FFFFFF",
        backgroundBottomColor: "#000000",
        attributionURL: _downloadUrl,
        appId: "2843898835847760")
        .then((data) {
      print(data);
    })
        : SocialShare.shareFacebookStory(imagePath: file.path,
        backgroundTopColor: "#FFFFFF",
        backgroundBottomColor: "#000000",
        attributionURL: _downloadUrl,
        appId: "2843898835847760")
        .then((data) {
      print(data);
    });
  }

  Future<File> _getFile() async {
    final ByteData bytes = await rootBundle.load('assets/images/default-image.jpeg');
    final file = File('${(await getTemporaryDirectory()).path}/default-image.jpeg');
    await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    return file;
  }

}
