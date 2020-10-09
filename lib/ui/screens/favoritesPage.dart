import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/models/restaurant_model.dart';
import 'package:Belly/ui/screens/restaurant_detail_page.dart';
import 'package:Belly/ui/screens/restaurant_page.dart';
import 'package:Belly/ui/widgets/custom_close_app_bar.dart';
import 'package:Belly/utils/base_url.dart';
import 'package:Belly/utils/network_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  SharedPreferences prefs;
  bool isLoading = true;
  bool isGuest = false;
  String token;
  List<RestaurantModelFav> restaurants;
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
      print('guest guest guest is now shown');
      print(isGuest);
    } else {
      token = prefs.getString('token');
      print(token);
    }
    getData();
  }

  void getData() async {
    NetworkUtil _networkUtil = NetworkUtil();
    setState(() {
      isLoading = true;
    });
    String url = BaseUrl().mainUrl + 'favourite/';
    if (!isGuest) {
      final List<dynamic> res =
          await _networkUtil.getUserRestaurants(url, token);
      restaurants = res.map((e) => RestaurantModelFav.fromJson(e)).toList();
      print(restaurants);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomCloseAppBar(
        title: 'Favorites',
      ),
      body: isGuest
          ? Center(
              child: Text('You need to Login :(',
                  style: CustomFontStyle.mediumTextStyle(blackBellyColor)),
            )
          : isLoading
              ? Center(child: CupertinoActivityIndicator())
              : ListView.builder(
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            elevation: 2,
                            child:
                                RestaurantCellFavorites(restaurants[index])));
                  }),
    );
  }
}

class RestaurantCellFavorites extends StatefulWidget {
  final RestaurantModelFav restaurant;
  RestaurantCellFavorites(this.restaurant);
  @override
  _RestaurantCellFavoritesState createState() =>
      _RestaurantCellFavoritesState();
}

class _RestaurantCellFavoritesState extends State<RestaurantCellFavorites> {
  NetworkUtil _networkUtil = NetworkUtil();
  bool saved = true;
  addToFav() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if (!saved) {
      setState(() {
        saved = true;
      });
      String url = BaseUrl().mainUrl + 'favourite/';
      final res = await _networkUtil.postFavorites(
          url, token, widget.restaurant.id.toString());
      print(res);
    } else {
      setState(() {
        saved = false;
      });
      String url = BaseUrl().mainUrl + 'unfavourite/${widget.restaurant.id}/';
      final res = await _networkUtil.deleteFavorites(url, token);
      print(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    double hscreen = MediaQuery.of(context).size.height;
    double wscreen = MediaQuery.of(context).size.width;
    return Container(
        child: InkWell(
      child: Stack(
        children: <Widget>[
          Column(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: hscreen * 0.170,
                      width: wscreen,
                      child: ClipRRect(
                          child: widget.restaurant.logo == null
                              ? Container(
                                  color: cloudsColor,
                                )
                              : CachedNetworkImage(
                                  imageUrl: widget.restaurant.logo,
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                  fit: BoxFit.cover,
                                )),
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () => addToFav(),
                          icon: Icon(
                            saved ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                        )),
                    // Positioned(
                    //   bottom: 10,
                    //   left: 0,
                    //   child: Container(
                    //       width: 60,
                    //       decoration: BoxDecoration(
                    //           color: Colors.blue[800],
                    //           borderRadius: BorderRadius.only(
                    //               bottomRight: Radius.circular(4),
                    //               topRight: Radius.circular(4))),
                    //       child: Padding(
                    //         padding: EdgeInsets.all(2.0),
                    //         child: Column(
                    //           children: <Widget>[
                    //             Text(
                    //               '30% OFF',
                    //               style: TextStyle(
                    //                   fontFamily: 'NotoSansJP',
                    //                   fontSize: 12,
                    //                   color: whiteBellyColor),
                    //             )
                    //           ],
                    //         ),
                    //       )),
                    // ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 4, 6),
                  child: Container(
                    color: whiteColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(widget.restaurant.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: blackBellyColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'NotoSansJP',
                              letterSpacing: 1,
                              fontSize: 18.0,
                            )
                            // CustomFontStyle.regularBoldTextStyle(blackBellyColor),
                            ),
                        SizedBox(
                          height: 3,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: <Widget>[
                        //     Column(
                        //       children: <Widget>[
                        //         Container(
                        //           child: Text(
                        //             '${widget.restaurant.pricemin.toInt().toString()}~${widget.restaurant.pricemax.toInt().toString()}',
                        //             style: TextStyle(
                        //               letterSpacing: 1.0,
                        //               fontFamily: 'MontserratMedium',
                        //               color: Colors.black,
                        //               fontSize: 12.0,
                        //               fontWeight: FontWeight.w300,
                        //             ),
                        //           ),
                        //         ),
                        //         Text(
                        //           'Price',
                        //           style: TextStyle(fontSize: 7),
                        //         )
                        //       ],
                        //     ),
                        //     Container(
                        //       width: 1,
                        //       height: 20,
                        //       color: Colors.green,
                        //     ),
                        //     Column(
                        //       children: <Widget>[
                        //         Text(widget.restaurant.rating == null
                        //             ? '1.0'
                        //             : '${widget.restaurant.rating}'),
                        //         Text(
                        //           'Rating',
                        //           style: TextStyle(fontSize: 7),
                        //         )
                        //       ],
                        //     ),
                        //     Container(
                        //       width: 1,
                        //       height: 20,
                        //       color: Colors.green,
                        //     ),
                        //     Column(
                        //       children: <Widget>[
                        //         Container(
                        //           child: Text(
                        //             widget.restaurant.foodType != null
                        //                 ? widget.restaurant.foodType
                        //                 : 'Kind of dishes',
                        //             overflow: TextOverflow.ellipsis,
                        //             style: TextStyle(
                        //               letterSpacing: 1.0,
                        //               fontFamily: 'MontserratMedium',
                        //               color: Colors.black,
                        //               fontSize: 12.0,
                        //               fontWeight: FontWeight.w300,
                        //             ),
                        //           ),
                        //         ),
                        //         Text(
                        //           'Dishes',
                        //           style: TextStyle(fontSize: 7),
                        //         )
                        //       ],
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ]),
          // Positioned(
          //   bottom: 55,
          //   right: 10,
          //   child: Container(
          //       width: 60,
          //       decoration: BoxDecoration(
          //           color: Colors.blue[100],
          //           borderRadius: BorderRadius.circular(4)),
          //       child: Padding(
          //         padding: EdgeInsets.all(2.0),
          //         child: Column(
          //           children: <Widget>[
          //             Text(
          //               '${widget.restaurant.preparationtime}',
          //               style: TextStyle(fontSize: 14, color: whiteBellyColor),
          //             ),
          //             Text(
          //               'mins',
          //               textAlign: TextAlign.center,
          //               style: TextStyle(fontSize: 8, color: whiteBellyColor),
          //             ),
          //           ],
          //         ),
          //       )),
          // ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RestaurantDetailPage(widget.restaurant.id)),
        );
      },
    ));
  }
}
