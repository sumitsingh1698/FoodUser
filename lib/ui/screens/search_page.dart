import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/data/restaurant_data.dart';
import 'package:Belly/models/restaurant_model.dart';
import 'package:Belly/ui/screens/restaurant_page.dart';
import 'package:Belly/utils/show_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchContrller = TextEditingController();
  bool isLoading = false;
  SharedPreferences prefs;
  String token;
  String userCampus = "";
  RestaurantDataSource _restaurantDataSource = new RestaurantDataSource();
  List<RestaurantModel> data = [];
  bool isGuest = false;
  bool empty = false;
  static final _key2 = new GlobalKey<ScaffoldState>();

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // if the user is not logged and is in home page, he is a guest user
    var loggedIn = prefs.getBool("loggedIn").toString();
    if (loggedIn == 'null' || loggedIn == 'false') {
      setState(() {
        isGuest = true;
      });
    } else {
      token = prefs.getString('token');
    }
  }

  getSearchData() async {
    setState(() {
      isLoading = true;
    });
    if (isGuest)
      await _restaurantDataSource
          .getGuestRestaurantsForSearch(
              "10.139429", "76.464556", searchContrller.text)
          .then((value) {
        setState(() {
          data = value;
        });
      });
    else
      await _restaurantDataSource
          .getUserRestaurantsForSearch(
              token, "10.139429", "76.464556", searchContrller.text)
          .then((value) {
        setState(() {
          data = value;
          isLoading = false;
          empty = true;
        });
      }).catchError((onError) {
        setState(() {
          isLoading = false;
        });
        Utils.showSnackBar(_key2, "Communication Error, Try Again :)");
      });
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key2,
        backgroundColor: whiteBellyColor,
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey[500]),
                      shape: BoxShape.rectangle,
                    ),
                    child: Center(
                      child: TextFormField(
                        onEditingComplete: () {
                          getSearchData();
                        },
                        controller: searchContrller,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 18),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey[500],
                              size: 24,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                searchContrller.clear();
                              },
                              icon: Icon(Icons.clear),
                              color: Colors.grey[500],
                              iconSize: 24,
                            ),
                            hintText: "Search for restaurants,cuisines..."),
                      ),
                    )),
              ),
              Expanded(
                  child: (isLoading)
                      ? Center(child: CupertinoActivityIndicator())
                      : data.isNotEmpty
                          ? Container(
                              child: ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return new Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 10),
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.zero),
                                          elevation: 2,
                                          child: RestaurantCell(
                                              data[index], snackbar)));
                                },
                              ),
                            )
                          : empty
                              ? Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                0.2),
                                    child: Container(
                                      child: Text('Sorry,No Results Matched :(',
                                          style:
                                              CustomFontStyle.mediumTextStyle(
                                                  blackBellyColor)),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }

  void snackbar() {
    Utils.showSnackBar(_key2, "Restaurant Closed");
  }
}
