import 'package:awoof_app/model/create-giveaway.dart';
import 'package:awoof_app/ui/blessing/givetwo.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:awoof_app/utils/switch.dart';
import 'package:flutter/material.dart';
import 'package:awoof_app/utils/flutter_datetime_picker-1.5.1/lib/flutter_datetime_picker.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/services.dart';

class GiveOne extends StatefulWidget {

  static const String id = 'give_one_page';

  @override
  _GiveOneState createState() => _GiveOneState();
}

class _GiveOneState extends State<GiveOne> {

  /// A [TextEditingController] to control the input text for the give away amount
  TextEditingController _amountController = TextEditingController();

  /// A [TextEditingController] to control the input text for the number of winners
  TextEditingController _winnerController = TextEditingController();

  /// A [TextEditingController] to control the input text for the frequency of the giveaway
  TextEditingController _frequencyController = TextEditingController();

  /// A [GlobalKey] to hold the form state of my form widget for form validation
  final _formKey = GlobalKey<FormState>();

  /// A boolean variable to hold if user is anonymous time
  bool _isAnon = false;

  /// This variable holds the list of available amount per winner
  List<double> _allAmounts = [1000, 2000, 5000, 10000, 20000, 50000, 100000];

  /// This variable holds the giveaway selected amount per winner
  double? _selectedAmount;

  /// This variable holds the giveaway total amount
  String? _totalAmount;

  /// This variable holds the giveaway number of giveaway winners
  int? _amountPerWinner;

  /// This variable holds the giveaway end at time
  DateTime? _endAt;

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
              padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: Center(
                child: Text(
                  '01 of 03',
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
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 30),
                  Container(
                    width: SizeConfig.screenWidth! * 0.4,
                    child: Text(
                      'New Giveaway!',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 28,
                        fontFamily: "Regular",
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 19),
                      _isAnon
                          ? Container(
                        width: 25.0,
                        height: 25.0,
                        margin: EdgeInsets.only(bottom: 10, right: 20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage( 'assets/images/tl6.png'),
                              fit: BoxFit.cover
                          ),
                        ),
                      )
                          : Container(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Anonymous Mode',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 14,
                          fontFamily: 'Regular',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: 63,
                        height: 28,
                        child: CustomSwitch(
                          activeTextColor: Colors.white,
                          inactiveTextColor: Colors.white,
                          activeColor: Colors.white,
                          inactiveColor: Colors.white,
                          value: _isAnon,
                          activeText: 'Yes',
                          inactiveText: 'No',
                          onChanged: (value) {
                            if(!mounted)return;
                            setState(() {
                              _isAnon = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 20,
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  _buildForm(),
                  Container(
                    height: 27,
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: SizeConfig.screenWidth! - 40,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 13, 5, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          /*Text(
                            'Your giveaway qualifies you for a',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 14,
                              fontFamily: 'Regular',
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _packageType,
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 14,
                              fontFamily: 'Regular',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 15),
                          Image.asset(
                            'assets/images/$_packageUrl.png',
                            width: 28,
                            height: 28,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 18),*/
                          /*Text(
                            'Follow us on Awoof',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 14,
                              fontFamily: 'Regular',
                            ),
                          ),
                          SizedBox(height: 4),
                          GestureDetector(
                            onTap: (){
                              Constants.showNormalMessage('Select a platform of engagement if you would like users to interact with your social accounts');
                            },
                            child: Text(
                              'Learn More.',
                              style: TextStyle(
                                color: Color(0XFF060d25),
                                fontSize: 14,
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),*/
                        ],
                      ),
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
                  SizedBox(height: 20),
                  /*GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, GiveTwo.id);
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
                          'Continue Without Package',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: "Regular",
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ),
                  ),*/
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// A function to build the form widget where users enter details of what to
  /// fill in the form
  Widget _buildForm(){
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Amount Per Winner',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 14,
                  fontFamily: 'Regular',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'No. of Winners',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 14,
                  fontFamily: 'Regular',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: (SizeConfig.screenWidth! - 20) / 2,
                child: DropdownButtonFormField(
                  dropdownColor: Color(0XFF09AB5D),
                  value: _selectedAmount,
                  onChanged: (value) {
                    if(!mounted)return;
                    setState(() {
                      _selectedAmount = value;//_selectedAmount;
                      if(_winnerController.text != '' && _winnerController.text.isNotEmpty && _winnerController.text != null && _selectedAmount != null){
                        try{
                          _amountController.text = Constants.money((double.parse(_winnerController.text) * _selectedAmount!), '');
                          _totalAmount = (double.parse(_winnerController.text) * _selectedAmount!).toString();
                        } catch(e){
                          print(e);
                        }
                      }
                    });
                  },
                  validator: (value) {
                    if (_selectedAmount == null) {
                      return 'Select amount';
                    }
                    return null;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: '0',
                    hintStyle: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 16,
                      fontFamily: "Regular",
                    ),
                  ),
                  items: _allAmounts.map((amount) {
                    return DropdownMenuItem(
                      child: Text(
                        Constants.money(amount, 'N'),
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 16,
                          fontFamily: "Regular",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      value: amount/*Constants.money(amount, 'N')*/,
                    );
                  }).toList(),
                ),
              ),
              Container(
                width: (SizeConfig.screenWidth! - 80) / 2,
                child: TextFormField(
                  controller: _winnerController,
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 16,
                    fontFamily: "Regular",
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter no of winners';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if(!mounted)return;
                    setState(() {
                      _amountPerWinner = int.parse(value);
                      if(_winnerController.text != '' && _winnerController.text.isNotEmpty && _winnerController.text != null && _selectedAmount != null){
                        try{
                          _amountController.text = Constants.money((double.parse(_winnerController.text) * _selectedAmount!), '');
                          _totalAmount = (double.parse(_winnerController.text) * _selectedAmount!).toString();
                        } catch(e){
                          print(e);
                        }
                      }
                    });
                  },
                  decoration: kTextPinDecoration.copyWith(
                    hintText: "0",
                    hintStyle: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 16,
                      fontFamily: "Regular",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 18),
          /*Text(
            'Total Amount',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 14,
              fontFamily: 'Regular',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 18),
          Container(
            width: SizeConfig.screenWidth,
            child: TextFormField(
              style: TextStyle(
                color: Color(0xffFFFFFF),
                fontSize: 16,
                fontFamily: "Regular",
              ),
              controller: _amountController,
              readOnly: true,
              decoration: kTextPinDecoration.copyWith(
                prefixIcon: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 14,
                        height: 14,
                        child: Center(
                          child: Image.asset(
                            'assets/images/naira.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 18),*/
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Total Amount',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 14,
                  fontFamily: 'Regular',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Due Date',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 14,
                  fontFamily: 'Regular',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: (SizeConfig.screenWidth! - 20) / 2,
                child: TextFormField(
                  style: TextStyle(
                    color: Color(0xffFFFFFF),
                    fontSize: 16,
                    fontFamily: "Regular",
                  ),
                  controller: _amountController,
                  readOnly: true,
                  decoration: kTextPinDecoration.copyWith(
                    prefixIcon: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 14,
                            height: 14,
                            child: Center(
                              child: Image.asset(
                                'assets/images/naira.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: (SizeConfig.screenWidth! - 80) / 2,
                child: TextFormField(
                  controller: _frequencyController,
                  readOnly: true,
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 16,
                    fontFamily: "Regular",
                    fontWeight: FontWeight.bold,
                  ),
                  onTap: (){
                    _showDateTime();
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Select the time';
                    }
                    if (value == '0 day') {
                      return 'Invalid selection';
                    }
                    return null;
                  },
                  decoration: kTextPinDecoration.copyWith(
                    hintText: "Select",
                    hintStyle: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 16,
                      fontFamily: "Regular",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 18),
        ],
      ),
    );
  }

  /// Function to show the bottom date time picker fo selecting frequency time
  void _showDateTime(){
    DateTime now = DateTime.now();
    DatePicker.showDateTimePicker(
        context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime(now.year, now.month, now.day + 8),
        onChanged: (date) {
          if(!mounted)return;
          setState(() {
            _frequencyController.text = Constants.getTimeLeft(date);
            _endAt = date;
          });
        },
        onConfirm: (date) {
          if(!mounted)return;
          setState(() {
            _frequencyController.text = Constants.getTimeLeft(date);
            _endAt = date;
          });
        },
        currentTime: DateTime.now(),
        locale: LocaleType.en
    );
  }

  /// Function to save the details of giveaway
  void _saveDetails(){
    //DateTime now = DateTime.now();
    //DateTime end = DateTime(now.year, now.month, now.day + 3);
    var createGiveaway = CreateGiveaway();
    createGiveaway.isAnonymous = _isAnon;
    createGiveaway.type = 'normal';
    createGiveaway.amount = _totalAmount!;
    createGiveaway.frequency = _endAt.toString();
    createGiveaway.expiry = _frequencyController.text;
    createGiveaway.endAt = _endAt!.toUtc();
    createGiveaway.amountPerWinner = _selectedAmount.toString();
    createGiveaway.numberOfWinners = _amountPerWinner!;
    if(_isAnon){
      createGiveaway.message = 'From Anonymous Giver with love ❤';
      createGiveaway.likePostOnFacebook = false;
      createGiveaway.followPageOnFacebook = 'false';
      createGiveaway.likeFacebook = false;
      createGiveaway.likeTweet = false;
      createGiveaway.followTwitter = false;
      createGiveaway.likeInstagram = false;
      createGiveaway.followInstagram = false;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GiveTwo(
            giveaway: createGiveaway,
          ),
        ),
      );
      /*Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GiveThree(
            giveaway: createGiveaway,
            image: null,
          ),
        ),
      );*/
    }
    else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GiveTwo(
            giveaway: createGiveaway,
          ),
        ),
      );
    }
  }

}
