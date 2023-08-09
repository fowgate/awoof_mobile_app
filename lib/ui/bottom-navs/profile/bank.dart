import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/model/banks.dart';
import 'package:awoof_app/networking/rest-data.dart';
import 'package:awoof_app/ui/bottom-navs/profile/add-bank.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:flutter/material.dart';

class Bank extends StatefulWidget {

  static const String id = 'bank_page';

  @override
  _BankState createState() => _BankState();
}

class _BankState extends State<Bank> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// GlobalKey of a my RefreshIndicatorState to refresh my list items in the page
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  /// A List to hold the all the banks user has
  List<Banks> _banks = [];

  /// An Integer variable to hold the length of [_banks]
  int? _bankLength;

  /// A List to hold the widgets of th bank accounts
  List<Widget> _bankAccounts = [];

  /// Function to fetch all the user banks from the database to
  /// [_banks]
  void _allBanks() async {
    Future<List<Banks>> names = futureValue.getAllUserBanksFromDB();
    await names.then((value) {
      if(value.isEmpty || value.length == 0){
        if(!mounted)return;
        setState(() {
          _bankLength = 0;
          _banks = [];
        });
      } else if (value.length > 0){
        if(!mounted)return;
        setState(() {
          _banks.addAll(value);
          _bankLength = value.length;
        });
      }
    }).catchError((error){
      print(error);
      Constants.showError(context, error);
    });
  }

  /// A function to build the list of all the accounts the user has
  Widget _buildList() {
    if(_banks.length > 0 && _banks.isNotEmpty){
      _bankAccounts.clear();
      for (int index = 0; index < _banks.length; index++){
        _bankAccounts.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: SizeConfig.screenWidth,
                  height: 63,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Color(0XFF1F253B),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              _banks[index].accountName!,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Regular",
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                            SizedBox(height: 3),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  _banks[index].bankName!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Regular",
                                    color: Color(0xFF9DA0A9),
                                  ),
                                ),
                                SizedBox(width: 6),
                                Transform.translate(
                                  offset: Offset(0, -3),
                                  child: Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(2),
                                      ),
                                      color: Color(0XFF4C5162),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  _banks[index].accountNumber!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Regular",
                                    color: Color(0xFF9DA0A9),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            _buildDeleteDialog(
                                _banks[index].id!,
                                _banks[index].bankName!,
                                _banks[index].accountName!
                            );
                          },
                          child: Icon(
                            Icons.delete_outline,
                            size: 19,
                            color: Color(0xFFE64C3C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
              ],
            )
        );
      }
      return Column(
        children: _bankAccounts,
      );
    }
    else if(_bankLength == 0){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.assignment_late,
            size: 65,
            color: Colors.white,
          ),
          SizedBox(height: 17),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              'Add an account to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontFamily: "Medium",
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF)),
        ),
      ),
    );
  }

  /// Function to refresh details of the list of all the accounts the user has
  /// similar to [_allBanks()]
  Future<Null> _refresh() {
    Future<List<Banks>> names = futureValue.getAllUserBanksFromDB();
    return names.then((value) {
      if(!mounted)return;
      setState(() {
        _bankLength = 0;
        _banks.clear();
      });
      if(value.isEmpty || value.length == 0){
        if(!mounted)return;
        setState(() {
          _bankLength = 0;
          _banks = [];
        });
      } else if (value.length > 0){
        if(!mounted)return;
        setState(() {
          _banks.addAll(value);
          _bankLength = value.length;
        });
      }
    }).catchError((error){
      print(error);
      Constants.showError(context, error);
    });
  }

  /// Function to refresh details of the banks
  /// by calling [_allBanks()]
  void _refreshData(){
    if (!mounted) return;
    setState(() {
      _banks.clear();
      _bankLength = null;
      _allBanks();
    });
  }

  @override
  void initState() {
    super.initState();
    _allBanks();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      color: Color(0xFFFFFFFF),
      child: Scaffold(
        backgroundColor: Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Container(
            width: 90,
            child: Image.asset(
              'assets/images/awoof-blue.png',
              fit: BoxFit.contain,
            ),
          ),
          centerTitle: true,
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
        ),
        body: Stack(
          children: [
            Container(
              width: SizeConfig.screenWidth,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 15),
                      Text(
                        'Bank Accounts',
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Regular',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                      SizedBox(height: 40),
                      _buildList(),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(top: 40, bottom: 40),
                width: SizeConfig.screenWidth! - 30,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AddBank.id);
                  },
                  child: Text(
                    'Add new account',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: "Regular",
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  //color: Color(0xFF1FD47D),
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  /// Function that shows a dialog to confirm if you want to delete a bank
  _buildDeleteDialog(String id, String bankName, String accountName){
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Material(
              type: MaterialType.transparency,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(17, 20, 17, 20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Color.fromRGBO(250, 250, 250, 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 25, 18, 20),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Delete Account',
                              style: TextStyle(
                                color: Color(0XFF808080),
                                fontSize: 18,
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 25),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'Delete bank account ',
                                style: TextStyle(
                                  color: Color(0XFF808080),
                                  fontSize: 15,
                                  fontFamily: 'Regular',
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: accountName,
                                    style: TextStyle(
                                      color: Color(0XFF808080),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Regular',
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' of ',
                                    style: TextStyle(
                                      color: Color(0XFF808080),
                                      fontSize: 15,
                                      fontFamily: 'Regular',
                                    ),
                                  ),
                                  TextSpan(
                                    text: bankName,
                                    style: TextStyle(
                                      color: Color(0XFF808080),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Regular',
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' from your Awoof account.',
                                    style: TextStyle(
                                      color: Color(0XFF808080),
                                      fontSize: 15,
                                      fontFamily: 'Regular',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 25),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        color: Colors.transparent,
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 25, 0),
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Regular',
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1FD47D),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      _deleteBankAccount(id);
                                    },
                                    child: Container(
                                      height: 35,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        color: Color(0xFF1FD47D),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Regular',
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFFFFFF),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Function that deletes a user bank by calling
  /// [deleteBankAccount] in the [RestDataSource] class
  Future<void> _deleteBankAccount(String id) async {
    var api = RestDataSource();
    await api.deleteBankAccount(id).then((value) {
      Constants.showSuccess(
        context,
        'Account successfully deleted',
        where: (){
          _refreshData();
        }
      );
    }).catchError((error) {
      print(error);
      Constants.showError(context, error);
    });
  }

}
