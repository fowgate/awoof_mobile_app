import 'package:awoof_app/utils/size-config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Support extends StatefulWidget {

  static const String id = 'support_page';

  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {

  /// Function to call a number using the [url_launcher] package
  _callPhone(String phone) async {
    const url = 'https://wa.me/message/DHLAOBH2RPOSD1';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch the url';
    }
  }

  /// Parameters to send email to awoof using the [url_launcher] package
  final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@awoofapp.com',
      queryParameters: {
        'subject': ''
      }
  );

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Color(0XFF060D25),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          width: 90,
          child: Image.asset(
            'assets/images/awoof-blue.png',
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 35, 30, 0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: SizeConfig.screenWidth! * 0.7,
                child: Text(
                  'How can we help?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Regular',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
              SizedBox(height: 11,),
              Container(
                width: 236,
                child: Text(
                  'If you have any issues within our platform you’d like us to solve, contact us today.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Regular',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF767676),
                  ),
                ),
              ),
              SizedBox(height: 23,),
              _buildContainer(
                  'assets/images/whatsapp.png',
                  'Reach us on Whatsapp',
                  '+1 417 413 3301'
              ),
              SizedBox(height: 10.0,),
              _buildContainer(
                  'assets/images/mail.png',
                  'Email',
                  'support@awoofapp.com'
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Function to build a widget for the container to hold the support details
  Widget _buildContainer(String image, String header, String details){
    return GestureDetector(
      onTap: (){
        HapticFeedback.lightImpact();
        if(header == "Reach us on Whatsapp"){
          _callPhone("tel: $details");
        } else {
          launch(_emailLaunchUri.toString());
        }
      },
      child: Container(
        width: SizeConfig.screenWidth! * 0.8,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  header,
                  style: TextStyle(
                    color: Color(0xFF012224).withOpacity(0.5),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Regular',
                  ),
                ),
                SizedBox(height: 4.0,),
                Text(
                  details,
                  style: TextStyle(
                    color: Color(0xFF012224),
                    fontSize: 16,
                    letterSpacing: -0.6,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Bold',
                  ),
                ),
              ],
            ),
            Container(
              width: 40,
              height: 40,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color(0xFF09AB5D).withOpacity(0.2),
              ),
              child: Image.asset(
                image,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
