import 'package:awoof_app/bloc/future-values.dart';
import 'package:awoof_app/model/giveaways.dart';
import 'package:awoof_app/ui/blessing/blessing.dart';
import 'package:awoof_app/ui/bottom-navs/home/giveaway/giveaway-details.dart';
import 'package:awoof_app/utils/constants.dart';
import 'package:awoof_app/utils/my-widgets.dart';
import 'package:awoof_app/utils/size-config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class Search extends StatefulWidget {

  static const String id = 'search_page';

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A TextEditingController to control the searchText on the AppBar
  final TextEditingController _filter = TextEditingController();

  /// Converting [dateTime] in string format to return a formatted time
  /// of hrs, minutes and am/pm
  String _getFormattedTime(DateTime dateTime) {
    return DateFormat('d, MMMM').format(dateTime).toString();
  }

  /// A List to hold all the giveaways
  List<AllGiveaways> _giveaways = [];

  /// Variable of List<[AllGiveaways]> to hold all the filtered giveaways
  List<AllGiveaways> _filteredGiveaways = [];

  /// An Integer variable to hold the length of [_giveaways]
  int? _giveawayLength;

  /// A List to hold the widgets of the giveaways
  List<Widget> _giveawayContainer = [];

  /// Checking if the filter controller is empty to reset the
  /// the filteredGiveaways to giveaways
  _SearchState(){
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        if (!mounted) return;
        setState(() {
          _filteredGiveaways = _giveaways;
        });
      }
    });
  }

  /// Function to fetch all the giveaways from the database to
  /// [_giveaways]
  void _allGiveaways() async {
    Future<List<AllGiveaways>> giveaways = futureValue.getAllGiveaways();
    await giveaways.then((value) {
      _giveaways.clear();
      _filteredGiveaways.clear();
      _giveawayLength = null;
      if(value.isEmpty || value.length == 0){
        if(!mounted)return;
        setState(() {
          _giveawayLength = 0;
          _giveaways = [];
          _filteredGiveaways = [];
        });
      } else if (value.length > 0){
        List<AllGiveaways> val = [];
        for(int i = 0; i < value.length; i++){
          if(value[i].type == 'normal'){
            val.add(value[i]);
          }
        }
        if(!mounted)return;
        setState(() {
          _giveawayLength = val.length;
          _giveaways.addAll(val);
          _filteredGiveaways.addAll(val);
        });
      }
    }).catchError((error){
      print(error);
      Constants.showError(context, error);
    });
  }

  /// A function to build the list of all the giveaways
  Widget _buildGiveawayList() {
    _giveawayContainer.clear();
    if(_giveaways.length > 0 && _giveaways.isNotEmpty){
      _giveawayContainer.add(SizedBox(height: 18));
      for (int i = 0; i < _filteredGiveaways.length; i++){
        var giveaway = _filteredGiveaways[i];
        _giveawayContainer.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GiveawayDetails(
                          giveaway: giveaway,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: SizeConfig.screenWidth,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 17, 15, 12),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 40,
                                height: 40,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: giveaway.isAnonymous!
                                        ? Image.asset(
                                      "assets/images/tl6.png",
                                      fit: BoxFit.cover,
                                    )
                                        : (giveaway.user.image != null)
                                        ? CachedNetworkImage(
                                        imageUrl: giveaway.user.image,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) => Container(color: Color(0xFFE8E8E8))
                                    )
                                        : Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF09AB5D),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          giveaway.user.userName.split('').first.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Regular',
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFFFFFFFF),
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                              ),
                              SizedBox(width: 15),
                              Text(
                                giveaway.isAnonymous!
                                    ? "Anonymous Giver"
                                    : '${giveaway.user.userName}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Regular',
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF000000),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: SizeConfig.screenWidth,
                          height: 400,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFE8E8E8), width: 1),
                          ),
                          child: giveaway.image != null
                              ? CachedNetworkImage(
                            imageUrl: giveaway.image!,
                            width: SizeConfig.screenWidth,
                            height: 400,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF060D25)),
                                    value: downloadProgress.progress
                                ),
                            errorWidget: (context, url, error) => Container(color: Color(0xFFE8E8E8)),
                          )
                              : Image.asset(
                            'assets/images/default-image.jpeg',
                            width: SizeConfig.screenWidth,
                            height: 400,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/images/cash.png',
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.contain,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Posted ${Constants.getTimeDifference(giveaway.createdAt!)} - ',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontFamily: 'Regular',
                                          color: Color(0xFF000000),
                                        ),
                                      ),
                                      Text(
                                        giveaway.completed! ? 'Expired' : 'Open',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontFamily: 'Regular',
                                          color: giveaway.completed!
                                              ? Colors.red
                                              : Color(0xFF09AB5D),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              giveaway.isAnonymous!
                                  ? Text(
                                "From Anonymous Giver with love ❤",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Regular',
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF000000),
                                ),
                              )
                                  : Container(
                                width: SizeConfig.screenWidth,
                                alignment: Alignment.centerLeft,
                                child: ExpandableText(
                                  ' ${giveaway.message}',
                                  trimLines: 3,
                                  username: giveaway.user.userName,
                                ),
                              ),
                            ],
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
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          children: _giveawayContainer,
        ),
      );
    }
    else if(_giveawayLength == 0){
      return Container(
        width: 300,
        height: MediaQuery.of(context).size.height - 183,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/empty.png',
              width: MediaQuery.of(context).size.width * 0.712,
              fit: BoxFit.contain,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Blessing.id);
                },
                child: Text(
                  'Bless Others',
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: "Bold",
                    color: Color(0xFF1FD47D),
                  ),
                ),
                //color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      child: SkeletonLoader(
        builder: Container(
          margin: EdgeInsets.only(bottom: 15),
          alignment: Alignment.center,
          width: SizeConfig.screenWidth,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(15, 17, 15, 12),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 15),
                    Text(
                      '',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Regular',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: SizeConfig.screenWidth,
                height: 400,
                color: Colors.white,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 10,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 12,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        items: 10,
        period: Duration(seconds: 2),
        highlightColor: Color(0xFF0C0C0C),
        direction: SkeletonDirection.ltr,
      ),
    );
  }

  Future refreshTL() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {
      return 1;
    });
  }

  int currentIndex = 0;

  Widget view(context, index) {
    List views = [Container()];
    return views[index];
  }

  List<String> amountPerWinner = [
    "Recent",
  ];

  String selectedAmountPerWinner = "Recent";

  @override
  void initState() {
    _allGiveaways();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
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
      body: RefreshIndicator(
        onRefresh: refreshTL,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              SizedBox(height: 5),
              Container(
                width: SizeConfig.screenWidth,
                height: 46,
                margin: EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 16,
                    fontFamily: "Regular",
                  ),
                  controller: _filter,
                  onChanged: (value){
                    if(_filter.text != '' || _filter.text.isNotEmpty){
                      List<AllGiveaways> tempList = [];
                      for (int i = 0; i < _filteredGiveaways.length; i++) {
                        if ('${_filteredGiveaways[i].user.firstName} ${_filteredGiveaways[i].user.lastName}'.toLowerCase()
                            .contains(_filter.text.toLowerCase())) {
                          tempList.add(_filteredGiveaways[i]);
                        }
                      }
                      if(!mounted)return;
                      setState(() {
                        _filteredGiveaways = tempList;
                      });
                    }
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Search users, giveaways',
                    hintStyle: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 16,
                      fontFamily: "Regular",
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xFF000000),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xFF1FD47D),
                      ),
                    ),
                    prefixIcon: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: 22,
                              maxHeight: 22,
                            ),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  5,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: 22,
                                height: 22,
                                child: Image.asset(
                                  'assets/images/search-white.png',
                                  width: 18,
                                  height: 18,
                                  fit: BoxFit.contain,
                                  color: Color(0xFF0C0C0C)

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
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    width: 103,
                    height: 35,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: DropdownButtonFormField(
                      value: selectedAmountPerWinner,
                      onChanged: (newValue) {
                        setState(() {
                          selectedAmountPerWinner = newValue!;
                        });
                      },
                      iconEnabledColor: Color(0xFF0C0C0C),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xFF5FC894),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xffB9B9B9),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xFF0C0C0C),
                          ),
                        ),
                      ),
                      items: amountPerWinner.map((amountPerWinner) {
                        return DropdownMenuItem(
                          child: Text(
                            amountPerWinner,
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 16,
                              fontFamily: "Regular",
                            ),
                          ),
                          value: amountPerWinner,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              _buildGiveawayList(),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

}
