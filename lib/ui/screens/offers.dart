import 'package:Belly/data/restaurant_data.dart';
import 'package:Belly/models/offerModel.dart';
import 'package:Belly/models/restaurant_model.dart';
import 'package:Belly/presentation/custom_icons_icons.dart';
import 'package:Belly/ui/screens/addressPage.dart';
import 'package:Belly/ui/screens/restaurant_page.dart';
import 'package:Belly/ui/widgets/custom_close_app_bar.dart';
import 'package:Belly/utils/base_url.dart';
import 'package:Belly/utils/network_utils.dart';
import 'package:Belly/utils/show_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OffersPage extends StatefulWidget {
  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  bool isLoading = true;
  bool isGuest = false;
  SharedPreferences prefs;
  String token;
  String baseurl = BaseUrl().mainUrl;
  // NetworkUtil _networkUtil = NetworkUtil();
  List<OfferModel> offers = [];
  RestaurantDataSource _restaurantDataSource = RestaurantDataSource();
  List<RestaurantModel> data = [];
  static final _key3 = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    var loggedIn = prefs.getBool("loggedIn").toString();
    if (loggedIn == 'null' || loggedIn == 'false') {
      setState(() {
        isGuest = true;
      });
    } else {
      token = prefs.getString('token');
      print(token);
    }
    getData();
  }

  getData() async {
    // print('gggggggettttttttttDDDDDDDaaata');
    // String url = baseurl + 'offers/';
    // final List res = await _networkUtil.getOffers(url, token);
    // List<OfferModel> temp = res.map((e) => OfferModel.fromJson(e)).toList();
    // setState(() {
    //   offers = temp;
    //   isLoading = false;
    // });
    // print(offers[1]);
    // print('ressssssssssssss');
    setState(() {
      isLoading = true;
    });

    double lat = prefs.getDouble('lat');
    double long = prefs.getDouble('long');
    //  double  locality = prefs.getString('locality');
    if (lat == null || long == null) {
      // print('lat and lon were null');
      // lat = 10.139429;
      // long = 76.464556;
      // locality = 'ekm';
      print('ssssssssssssssssssssssssssssssssssssssssss');

      // final token = prefs.getString('token');
    } else {
      if (isGuest)
        data = await _restaurantDataSource.getGuestRestaurants(
            "$lat", "$long", '');
      else
        data = await _restaurantDataSource.getUserRestaurants(
            token, "$lat", "$long", '');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key3,
      appBar: CustomCloseAppBar(
        back: false,
        title: "Restaurant Offers",
      ),
      body: isGuest
          ? Center(child: Text('Please Login :)'))
          : isLoading
              ? Center(child: CupertinoActivityIndicator())
              : data.length == 0
                  ? Center(child: Text("No Offer"))
                  : ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return data[index].discount != 0
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RestaurantCell(data[index], snackbar),
                              )
                            : SizedBox.shrink();
                      }),
    );
  }

  void snackbar() {
    Utils.showSnackBar(_key3, "Restaurant Closed");
  }
}
