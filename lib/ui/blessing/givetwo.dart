import 'dart:io';
import 'dart:typed_data';
import 'package:awoof_app/model/create-giveaway.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/photo-permissions.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'givetwo-review.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker/multi_image_picker.dart';

class GiveTwo extends StatefulWidget {

  static const String id = 'give_two_page';

  final CreateGiveaway giveaway;

  const GiveTwo({
    Key? key,
    required this.giveaway
  }) : super(key: key);

  @override
  _GiveTwoState createState() => _GiveTwoState();
}

class _GiveTwoState extends State<GiveTwo> {

  /// A [GlobalKey] to hold the form state of my form widget for form validation
  final _formKey = GlobalKey<FormState>();

  /// A [TextEditingController] to control the input text for the give away message
  TextEditingController _messageController = TextEditingController();

  /// A [TextEditingController] to control the input text for the give away facebook link
  TextEditingController _facebookLink = TextEditingController();

  /// A [TextEditingController] to control the input text for the give away twitter link
  TextEditingController _twitterLink = TextEditingController();

  /// A [TextEditingController] to control the input text for the give away intagram link
  TextEditingController _instagramLink = TextEditingController();

  List<http.MultipartFile> uploads = [];

  String _imageName = 'Select image or skip';

  dynamic _image;

  /// A list of Asset to store all images
  List<Asset> images = [];

  /// A list of Asset to store all selected
  List<Asset> resultList = [];

  Future<void> _loadAssets() async {
    uploads.clear();
    if(!mounted)return;
    setState(() {
      images = [];
    });
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        materialOptions: MaterialOptions(
          statusBarColor: '#006437',
          actionBarColor: '#006437',
          selectCircleStrokeColor: '#006437',
          allViewTitle: "All Photos",
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
      if(!mounted)return;
      setState(() { _imageName = 'Upload Giveaway image or skip'; });
      if(e.toString() == "The user has denied the gallery access."){
        PhotoPermissions.buildImageRequest(context);
      }
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      images = resultList;
      if(images != null){
        if(images.length > 0){
          _setImageDetails(images[0]);
        }
      }
    });
  }

  void _setImageDetails(Asset asset) async {
    ByteData thumbData = await asset.getByteData();
    final directory = await getTemporaryDirectory();
    _image = await File('${directory.path}/${asset.name}').create();
    await _image.writeAsBytes(thumbData.buffer.asUint8List());

    uploads.add(
      await http.MultipartFile.fromPath("image", _image.path, filename: "AdImage${DateTime.now()}.${_image.path.split('.').last}"),
    );
    setState(() {
      _imageName = "AdImage.${_image.path.split('.').last}";
    });
  }

  bool blur = false;

  bool greyFacebook = false;
  bool showFacebook = false;
  bool likeFacebook = false;
  bool followFacebook = false;

  bool greyInstagram = false;
  bool showInstagram = false;
  bool likeInstagram = false;
  bool followInstagram = false;

  bool greyTwitter = false;
  bool showTwitter = false;
  bool likeTwitter = false;
  bool followTwitter = false;

  @override
  void initState() {
    super.initState();
    if(widget.giveaway.isAnonymous!){
      if(!mounted)return;
      setState(() { blur = true; });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus){
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFF09AB5D),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Color(0XFF09AB5D),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: Center(
                child: Text(
                  '02 of 03',
                  style: TextStyle(
                    color: Color(0XFF8BD7B2),
                    fontSize: 13,
                    fontFamily: 'Regular',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
          elevation: 0,
        ),
        body: Container(
          width: SizeConfig.screenWidth,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 40),
                  Container(
                    width: SizeConfig.screenWidth! * 0.4,
                    child: Text(
                      'Finalize Giveaway!',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 28,
                        fontFamily: "Regular",
                      ),
                    ),
                  ),
                  SizedBox(height: 37),
                  Container(
                    height: 56,
                    width: SizeConfig.screenWidth,
                    child: TextFormField(
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 16,
                        fontFamily: "Regular",
                      ),
                      readOnly: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: _imageName,
                        hintStyle: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 16,
                          fontFamily: "Regular",
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Color(0xFF5FC894),
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xFF5FC894),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: (){
                            _loadAssets();
                          },
                          child: Container(
                            width: 100,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(3),
                                bottomRight: Radius.circular(3),
                              ),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                'Select Image',
                                style: TextStyle(
                                  color: Color(0xFF1FD47D),
                                  fontSize: 12,
                                  fontFamily: "Regular",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 18),
                  Form(
                    key: _formKey,
                    child: Container(
                      width: SizeConfig.screenWidth,
                      child: TextFormField(
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 16,
                          fontFamily: "Regular",
                        ),
                        controller: _messageController,
                        keyboardType: TextInputType.text,
                        /*validator: (value){
                          if(_messageController.text.isEmpty){
                            return 'Please enter giveaway caption';
                          }
                          return null;
                        },*/
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Enter Giveaway caption or skip',
                          hintStyle: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 16,
                            fontFamily: "Regular",
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFF5FC894),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 11),
                  GestureDetector(
                    onTap: (){
                      _buildConfirmDialog();
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Please Select Platform of engagement.',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 14,
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Learn More.',
                          style: TextStyle(
                            color: Color(0XFF000000),
                            fontSize: 14,
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        blur = !blur;
                      });
                    },
                    child: Container(
                      width: SizeConfig.screenWidth,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Color(0xFF5FC894),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(3),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/logo.png',
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'No Engagement',
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 14,
                                    fontFamily: 'Regular',
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            Icon(
                              (blur)
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              size: 25,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    child: blur
                        ? Container()
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showTwitter = !showTwitter;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Color(0xFF5FC894),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/t.png',
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Twitter',
                                        style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 14,
                                          fontFamily: 'Regular',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  Icon(
                                    (showTwitter)
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 2),
                        (showTwitter)
                            ? Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(3),
                            ),
                            color: Color(0XFF3ABC7D),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 2,
                                        color: Color(0xFF5FC894),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Follow User on Twitter',
                                        style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 14,
                                          fontFamily: 'Regular',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(10, 0),
                                        child: IconButton(
                                          icon: Icon(
                                            (followTwitter)
                                                ? Icons.check_box
                                                : Icons
                                                .check_box_outline_blank,
                                            size: 25,
                                            color: Colors.white,
                                          ),
                                          onPressed: () => setState(() {
                                            followTwitter = !followTwitter;
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'Twitter Username',
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 14,
                                    fontFamily: 'Regular',
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 2,
                                        color: Color(0xFF5FC894),
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 16,
                                      fontFamily: "Regular",
                                    ),
                                    keyboardType: TextInputType.text,
                                    controller: _twitterLink,
                                    decoration: kLinkFieldDecoration.copyWith(
                                      hintText: 'awoof',
                                      hintStyle: TextStyle(
                                        color: Color(0xffE0E6E3),
                                        fontSize: 16,
                                        fontFamily: "Regular",
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                        )
                            : Container(),

                        SizedBox(height: 12),

                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showInstagram = !showInstagram;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Color(0xFF5FC894),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/i.png',
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Instagram',
                                        style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 14,
                                          fontFamily: 'Regular',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  Icon(
                                    (showInstagram)
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 2),
                        (showInstagram)
                            ? Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(3),
                            ),
                            color: Color(0XFF3ABC7D),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 2,
                                        color: Color(0xFF5FC894),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Follow User on Instagram',
                                        style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 14,
                                          fontFamily: 'Regular',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(10, 0),
                                        child: IconButton(
                                          icon: Icon(
                                            (followInstagram)
                                                ? Icons.check_box
                                                : Icons
                                                .check_box_outline_blank,
                                            size: 25,
                                            color: Colors.white,
                                          ),
                                          onPressed: () => setState(() {
                                            followInstagram = !followInstagram;
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'Instagram Username',
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 14,
                                    fontFamily: 'Regular',
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 2,
                                        color: Color(0xFF5FC894),
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    style: TextStyle(
                                      color: Color(0XFF000000),
                                      fontSize: 16,
                                      fontFamily: "Regular",
                                    ),
                                    controller: _instagramLink,
                                    keyboardType: TextInputType.text,
                                    decoration: kLinkFieldDecoration.copyWith(
                                      hintText: 'awoof',
                                      hintStyle: TextStyle(
                                        color: Color(0xffE0E6E3),
                                        fontSize: 16,
                                        fontFamily: "Regular",
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                        )
                            : Container(),

                        SizedBox(height: 12),

                        /// Facebook Condition
                        /*GestureDetector(
                          onTap: () {
                            setState(() {
                              showFacebook = !showFacebook;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Color(0xFF5FC894),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/f-white.png',
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Facebook',
                                        style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 14,
                                          fontFamily: 'Regular',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  Icon(
                                    (showFacebook)
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 2),
                        (showFacebook)
                            ? Container(
                          width: SizeConfig.screenWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(3),
                            ),
                            color: Color(0XFF3ABC7D),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: SizeConfig.screenWidth,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 2,
                                        color: Color(0xFF5FC894),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Follow Page on Facebook',
                                        style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 14,
                                          fontFamily: 'Regular',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(10, 0),
                                        child: IconButton(
                                          icon: Icon(
                                            (followFacebook)
                                                ? Icons.check_box
                                                : Icons
                                                .check_box_outline_blank,
                                            size: 25,
                                            color: Colors.white,
                                          ),
                                          onPressed: () => setState(() {
                                            followFacebook = !followFacebook;
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'Facebook Profile URL',
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 14,
                                    fontFamily: 'Regular',
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  width: SizeConfig.screenWidth,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 2,
                                        color: Color(0xFF5FC894),
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 16,
                                      fontFamily: "Regular",
                                    ),
                                    controller: _facebookLink,
                                    keyboardType: TextInputType.url,
                                    decoration: kLinkFieldDecoration.copyWith(
                                      hintText: 'https://facebook.com/awoof',
                                      hintStyle: TextStyle(
                                        color: Color(0xffE0E6E3),
                                        fontSize: 16,
                                        fontFamily: "Regular",
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                        )
                            : Container(),*/
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    width: SizeConfig.screenWidth,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()){
                          _saveDetails();
                        }
                      },
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: "Regular",
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1FD47D),
                        ),
                      ),
                      //color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 55),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveDetails() {
    widget.giveaway.image = uploads;
    if(_messageController.text.isEmpty){
      widget.giveaway.message = "";
    } else {
      widget.giveaway.message = _messageController.text;
    }
    if(blur){
      widget.giveaway.likePostOnFacebook = false;
      widget.giveaway.likeFacebook = false;
      widget.giveaway.likefacebookLink = null;
      widget.giveaway.followPageOnFacebook = null;

      widget.giveaway.likeTweet = false;
      widget.giveaway.followTwitter = false;
      widget.giveaway.likeTweetLink = null;
      widget.giveaway.followTwitterLink = null;

      widget.giveaway.likeInstagram = false;
      widget.giveaway.followInstagram = false;
      widget.giveaway.likeInstagramLink = null;
      widget.giveaway.followInstagramLink = null;
    }
    else {
      widget.giveaway.likePostOnFacebook = likeFacebook;
      widget.giveaway.likeFacebook = (_facebookLink.text.isEmpty) ? false : true;
      widget.giveaway.likefacebookLink = _facebookLink.text;
      widget.giveaway.followPageOnFacebook = followFacebook.toString();

      widget.giveaway.likeTweet = likeTwitter;
      widget.giveaway.followTwitter = (_twitterLink.text.isEmpty) ? false : true;
      widget.giveaway.likeTweetLink = _twitterLink.text;
      widget.giveaway.followTwitterLink = _twitterLink.text;

      widget.giveaway.likeInstagram = likeInstagram;
      widget.giveaway.followInstagram = (_instagramLink.text.isEmpty) ? false : true;
      widget.giveaway.likeInstagramLink = _instagramLink.text;
      widget.giveaway.followInstagramLink = _instagramLink.text;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GiveTwoReview(
          giveaway: widget.giveaway,
          image: _image,
        ),
      ),
    );
  }

  /// Function that shows a confirm dialog when the user is about submit response
  Future<void> _buildConfirmDialog(){
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        elevation: 0.0,
        child: Container(
          width: 252,
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF).withOpacity(0.91),
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Platform',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Raleway',
                        color: Color(0xFF1D1D1D)
                    ),
                  )
              ),
              Container(
                width: 220,
                padding: EdgeInsets.only(top: 12, bottom: 11),
                child: Text(
                  "Select a platform of engagement if you would like users to interact with your social accounts",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Raleway',
                  ),
                ),
              ),
              Container(
                width: 252,
                height: 1,
                color: Color(0xFF9C9C9C).withOpacity(0.44),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 12.0, bottom: 11),
                  child: Text(
                    'Ok',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Raleway',
                        color: Color(0xFF1FD47D)
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
