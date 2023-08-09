import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:clipboard/clipboard.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:url_encoder/url_encoder.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Refer extends StatefulWidget {

  static const String id = 'refer_page';

  @override
  _ReferState createState() => _ReferState();
}

class _ReferState extends State<Refer> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A TextEditingController to control the searchText on the AppBar
  final TextEditingController _filter = TextEditingController();

  bool _search = false;

  List<Contact> _contacts = [];

  List<Contact> _filteredContacts = [];

  int? _contactsLength;

  String _androidUrl = 'https://play.google.com/store/apps/details?id=com.awoof.mobile_app';

  String _iosUrl = 'https://apps.apple.com/ng/app/philantro-the-giveaway-app/id1548208975';

  String _downloadUrl = 'https://www.awoofapp.com/download';

  String _whatsAppUrl = 'https://wa.me/';

  String? _whatsAppDescription;

  /// Function to trim number to add to the whatsapp url link
  String _trimNumber(String number){
    String nums = '';
    if(number.startsWith('+')){
      String x = number.substring(1);
      x.runes.forEach((int rune) {
        var character = String.fromCharCode(rune);
        if(character != ' ' && character != '-' && int.parse(character) >= 0 && int.parse(character) <= 9){
          nums += character;
        }
      });
    }
    else if(number.startsWith('0')){
      nums += '234';
      String x = number.substring(1);
      x.runes.forEach((int rune) {
        var character = String.fromCharCode(rune);
        if(character != ' ' && int.parse(character) >= 0 && int.parse(character) <= 9){
          nums += character;
        }
      });
    }
    return nums;
  }

  /// Function to launch the whatsapp url link
  _launchURL(String url, String message, String num) async {
    if(Platform.isAndroid){
      if (await canLaunch(url)) {
        await launch(url);
      }
      else {
        // Could not launch $url
        Share.share(message);
      }
    }
    else{
      await launch(Uri.encodeFull(url));
    }
  }

  /// Get all contacts without thumbnail (faster)
  Future<void> _refreshContacts() async {
    var contacts = (await ContactsService.getContacts()).toList();
    setState(() {
      _filteredContacts = _contacts = contacts;
      _contactsLength = _contacts.length;
    });
  }

  /// A String variable to hold the user's reference code
  String _refCode = '';

  /// This variable holds the number of stars to get when referral code is used
  int _starsToGet = 1;

  /// Setting the current user's ref code to [_refCode]
  void _getCurrentUser() async {
    futureValue.updateUser();
    await futureValue.getCurrentUser().then((user) {
      if(!mounted)return;
      setState(() {
        _refCode = user!.userRef!;
        _whatsAppDescription = "Hey! I've been using the Awoof app to participate in cash and item giveaways sponsored by reputable brands and people. Try using my code($_refCode) and we'll each get $_starsToGet star, which we can use to participate in Awoof SuperStar giveaways \n $_downloadUrl";
      });
    }).catchError((Object error) {
      print(error);
    });
    _refreshContacts();
  }

  /// Checking if the filter controller is empty to reset the
  /// the _filteredContacts to _contacts
  _ReferState(){
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        if (!mounted) return;
        setState(() {
          _filteredContacts = _contacts;
        });
      }
    });
  }

  /// A List to hold the all the awoof contacts
  List<String> _awoofContacts = [];

  /// An Integer variable to hold the length of [_awoofContacts]
  int? _awoofContactsLength;

  /// Function to fetch all the registered number from the database to
  /// [_awoofContacts]
  void _loadAwoofContacts() async {
    Future<List<String>> contacts = futureValue.getAllPhilantroContacts();
    await contacts.then((value) {
      if(value.isEmpty || value.length == 0){
        if(!mounted)return;
        setState(() {
          _awoofContactsLength = 0;
          _awoofContacts = [];
        });
      } else if (value.length > 0){
        if(!mounted)return;
        setState(() {
          _awoofContacts.addAll(value);
          _awoofContactsLength = value.length;
        });
      }
    }).catchError((error){
      print(error);
    });
  }

  /// Function to check if contact is registered on awoof
  bool _checkUserContact(String number){
    if(_awoofContacts != null){
      for(int i = 0; i < _awoofContacts.length; i++){
        if(_awoofContacts.contains(number)
            || _awoofContacts.contains(_trimNumber(number))
            || _awoofContacts.contains('+${_trimNumber(number)}')
        ){
          return true;
        }
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _loadAwoofContacts();
    _getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0XFF09AB5D),
      appBar: AppBar(
        backgroundColor: Color(0XFF09AB5D),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              size: 22,
              color: Color(0XFF62C797),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        elevation: 0,
      ),
      body: Scrollbar(
        thickness: 3,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollUpdateNotification) {
              HapticFeedback.selectionClick();
            }
            return false;
          },
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              width: SizeConfig.screenWidth,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.people_outline,
                            size: 24,
                            color: Color(0XFF09AB5D),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          width: SizeConfig.screenWidth! * 0.6,
                          child: RichText(
                            text: TextSpan(
                              text: '',
                              style: TextStyle(),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Invite Friends and Get 1 ⭐️ Each.',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Regular",
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                                TextSpan(
                                  text: ' ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Regular",
                                    color: Color(0xFF06202C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Text(
                          'Your referral code',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Regular",
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        SizedBox(height: 17),
                        Container(
                          width: SizeConfig.screenWidth,
                          height: 73,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            color: Color(0XFF54B687),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  _refCode,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: "Regular",
                                    color: Color(0xFFD5ECE1),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    FlutterClipboard.copy(_refCode).then(( value ) {
                                      Constants.showInfo(context, 'Copied to Clipboard');
                                    });
                                  },
                                  child: Icon(
                                    Icons.content_copy,
                                    color: Color(0xFFD5ECE1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            !_search
                                ? Text(
                              'My Contacts',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Bold",
                                color: Color(0xFFFFFFFF),
                              ),
                            )
                                : Container(
                              width: SizeConfig.screenWidth! * 0.7,
                                  child: TextField(
                              controller: _filter,
                              onChanged: (value){
                                if(_filter.text != '' || _filter.text.isNotEmpty){
                                  List<Contact> tempList = [];
                                  for (int i = 0; i < _filteredContacts.length; i++) {
                                    if (_filteredContacts[i].displayName != null
                                        && _filteredContacts[i].displayName!.toLowerCase()
                                            .contains(_filter.text.toLowerCase())
                                    ) {
                                      tempList.add(_filteredContacts[i]);
                                    }
                                  }
                                  if(!mounted)return;
                                  setState(() {
                                    _filteredContacts = tempList;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  hintText: 'Search...'
                              ),
                            ),
                                ),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                color: Color(0XFF060D25),
                              ),
                              child: Center(
                                child: !_search
                                    ? GestureDetector(
                                  onTap: (){
                                    if(!mounted)return;
                                    setState(() {
                                      _search = true;
                                    });
                                  },
                                  child: Center(
                                    child: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: 22,
                                ),
                                  ),
                                  )
                                    : GestureDetector(
                                  onTap: (){
                                    if(!mounted)return;
                                    setState(() {
                                      _search = false;
                                      _filteredContacts = _contacts;
                                      _filter.clear();
                                    });
                                  },
                                  child: Center(
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                      ],
                    ),
                    _filteredContacts != null
                        ? Scrollbar(
                          thickness: 3,
                          child: ListView.builder(
                              primary: false,
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _filteredContacts?.length ?? 0,
                              itemBuilder: (BuildContext context, int i) {
                                try {
                                  if(_filteredContacts[i].displayName != null && _filteredContacts[i].phones!.first.value != null) {
                                    bool usesAwoof = _checkUserContact(_filteredContacts[i].phones!.first.value!);
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: SizeConfig.screenWidth! - 150,
                                                  child: Text(
                                                    _filteredContacts[i].displayName!,
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontFamily: "Regular",
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFFFFFFFF),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  usesAwoof ? 'Uses Awoof' : _filteredContacts[i].phones!.first.value!,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: "Regular",
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFFB5E6CF),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                if(!usesAwoof){
                                                  String number = _trimNumber(_filteredContacts[i].phones!.first.value!);
                                                  if(number != ''){
                                                    _launchURL(
                                                        _whatsAppUrl + number + "?text=${Uri.encodeFull( _whatsAppDescription!)}",
                                                        _whatsAppDescription!,
                                                        number
                                                    );
                                                  }
                                                }
                                              },
                                              child: Opacity(
                                                opacity: usesAwoof ? 0.3 : 1,
                                                child: Container(
                                                  height: 36,
                                                  width: 103,
                                                  decoration: BoxDecoration(
                                                    color: Color(0XFF009245),
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(30),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: usesAwoof
                                                        ? Icon(Icons.check, color: Color(0xFFFFFFFF))
                                                        : Text(
                                                      'Get 1 ⭐️',
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        fontFamily: "Regular",
                                                        fontWeight: FontWeight.bold,
                                                        color: Color(0xFFFFFFFF),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                      ],
                                    );
                                  }
                                  return Container();
                                } catch (e) {
                                  return Container();
                                }
                              }
                          ),
                        )
                        : Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}