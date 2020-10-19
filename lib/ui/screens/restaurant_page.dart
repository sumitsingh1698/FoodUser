import 'package:Belly/constants/Style.dart';
import 'package:Belly/data/addressbook.dart';
import 'package:Belly/models/addressBook.dart';
import 'package:Belly/ui/screens/search_page.dart';
import 'package:Belly/ui/widgets/place_picker.dart';
import 'package:Belly/utils/base_url.dart';
import 'package:Belly/utils/network_utils.dart';
import 'package:Belly/utils/show_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:Belly/constants/Color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Belly/data/restaurant_data.dart';
import 'package:Belly/models/restaurant_model.dart';
import 'package:Belly/ui/screens/restaurant_detail_page.dart';
import 'package:Belly/ui/widgets/location_custom_app_bar.dart';
import 'package:Belly/utils/app_config.dart';

class RestaurantPage extends StatefulWidget {
  final Function(int) offerpage;
  RestaurantPage({this.offerpage});
  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  bool isLoading = true;
  SharedPreferences prefs;
  String token;
  RestaurantDataSource _restaurantDataSource = new RestaurantDataSource();
  List<RestaurantModel> data = [];
  bool isGuest = false;
  List<RestaurantModel> restaurant = [];
  static final _key1 = new GlobalKey<ScaffoldState>();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<List<Color>> colors = [
    [
      Color(0xFF0ba360),
      Color(0xFF3cba92),
    ],
    [Color(0xFFff0844), Color(0xFFffb199)],
    [Color(0xFFf43b47), Color(0xFF453a94)],
    [Color(0xFFfeada6), Color(0xFFf5efef)],
    [Color(0xFFd558c8), Color(0xFF24d292)],
    [Color(0xfff6d365), Color(0xfffda085)],
    [
      Color(0xFF0ba360),
      Color(0xFF3cba92),
    ],
    [Color(0xFFff0844), Color(0xFFffb199)],
    [Color(0xFFf43b47), Color(0xFF453a94)],
    [Color(0xFFfeada6), Color(0xFFf5efef)],
    [Color(0xFFd558c8), Color(0xFF24d292)],
  ];
  List<String> images = [
    "images/offer0.jpg",
    "images/offer1.jpg",
    "images/offer2.jpg",
    "images/offer3.jpg"
  ];
  // List<String> category = ["Pure Veg", "Non-Veg", "Family", "Chineese"];
  List<String> category = [];
  double lat;
  double long;
  String locality;
  AddressDataSource _addressDataSource = AddressDataSource();
  void sortRestaurants(String sorttext) {
    List<RestaurantModel> temp = data;

    if (sorttext == 'CostLtoH') {
      temp.sort((a, b) {
        if (a.pricemin == null) a.pricemin = 0;
        if (b.pricemin == null) b.pricemin = 0;
        return a.pricemin.compareTo(b.pricemin);
      });
    }
    if (sorttext == 'CostHtoL') {
      temp.sort((a, b) {
        if (a.pricemax == null) a.pricemax = 0;
        if (b.pricemax == null) b.pricemax = 0;
        return b.pricemax.compareTo(a.pricemax);
      });
    }
    if (sorttext == 'RatingHtoL') {
      temp.sort((a, b) {
        if (a.rating == null) a.rating = 1;
        if (b.rating == null) b.rating = 1;
        return b.rating.compareTo(a.rating);
      });
    }
    setState(() {
      restaurant = temp;
    });
  }

  void sort(int index) {
    List<RestaurantModel> temp = [];
    int x = 0;
    if (index == 3) {
      widget.offerpage(1);
    }
    switch (index) {
      case 0:
        {
          x = 20;
          // statements;
        }
        break;

      case 1:
        {
          x = 30;
        }
        break;
      case 2:
        {
          x = 40;
          //statements;
        }
        break;
      //  case 3: {
      //     //statements;
      //  }
      //  break;
      default:
        {
          //statements;
        }
        break;
    }
    if (index != 3) {
      data.forEach((e) {
        if (e.discount.toInt() == x) {
          temp.add(e);
        }
      });
      setState(() {
        restaurant = temp;
      });
    }
  }

  sortCategory(String cat) {
    List<RestaurantModel> temp = [];
    data.forEach((e) {
      if (e.foodType == cat) {
        temp.add(e);
      }
    });
    setState(() {
      restaurant = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
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

  void getData() async {
    setState(() {
      isLoading = true;
    });

    lat = prefs.getDouble('lat');
    long = prefs.getDouble('long');
    locality = prefs.getString('locality');
    if (lat == null || long == null) {
      // print('lat and lon were null');
      // lat = 10.139429;
      // long = 76.464556;
      // locality = 'ekm';
      print("here");

      print('ssssssssssssssssssssssssssssssssssssssssss');
      LocationResult result =
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PlacePicker(
                    "AIzaSyDHBgQ2en98quh7noD9v_Q9cfEqNPV9sxs",
                    // displayLocation: LatLng(10.139429, 76.464556),
                  )));
      print('hurrrraaaaaaaaaayyyyyyyy       $result');
      print(result.latLng);
      final token = prefs.getString('token');
      if (!isGuest) {
        AddressBook address = AddressBook(
            result.name,
            result.locality == null ? "" : result.locality,
            result.city,
            result.zip,
            result.latLng.latitude.toString(),
            result.latLng.longitude.toString());

        print("address ${address.toJson().toString()}");
        final response = await _addressDataSource.postAddress(token, address);
        print('adresss saved');
        prefs.setInt('addressId', response['id']);
        prefs.setDouble('lat', result.latLng.latitude);
        prefs.setDouble('long', result.latLng.longitude);
        prefs.setString('locality', result.name);
        print(response['id']);
        print(response);
      }
      setState(() {
        lat = result.latLng.latitude;
        long = result.latLng.longitude;
        locality = result.name;
      });
    } else {}
    if (isGuest)
      data =
          await _restaurantDataSource.getGuestRestaurants("$lat", "$long", '');
    else
      data = await _restaurantDataSource.getUserRestaurants(
          token, "$lat", "$long", '');

    print('ssssssssdaaaffafaaaggaga');
    print("$lat hhhh hhhh  hh $long");
    category = [];
    data.forEach((e) {
      print("${e.name} ${e.availableStatus}");
      if (!category.contains(e.foodType)) {
        category.add(e.foodType);
      }
    });
    setState(() {
      restaurant = data;
      isLoading = false;
      print("All Refresh Done");
    });
  }

  @override
  Widget build(BuildContext context) {
    AppConfig _screenConfig = AppConfig(context);
    return SafeArea(
      child: Scaffold(
          key: _key1,
          body: (isLoading)
              ? Center(child: CupertinoActivityIndicator())
              : NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        expandedHeight: 115,
                        pinned: true,
                        backgroundColor: Colors.white,
                        flexibleSpace: FlexibleSpaceBar(
                          background: MyCustomAppBar(
                              location: locality,
                              height: _screenConfig.rH(10),
                              defaultAppBar: true,
                              sort: (text) => sortRestaurants(text),
                              locUpdate: () => getData()),
                        ),
                        bottom: PreferredSize(
                            preferredSize: Size.fromHeight(14),
                            child: Container(
                              height: 60,
                              color: Colors.white,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return SearchPage();
                                  }));
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(6, 10, 6, 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0, color: Colors.grey[300]),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.search,
                                          size: 30,
                                          color: Colors.grey[500],
                                        ),
                                        Text(
                                          'Search for restaurants,cuisines...',
                                          style: TextStyle(
                                              color: Colors.grey[500],
                                              letterSpacing: 1),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      )
                    ];
                  },
                  body: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: WaterDropHeader(),
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          // body = Container(
                          //   child: Center(
                          //     child: CircularProgressIndicator(),
                          //   ),
                          // );
                        } else if (mode == LoadStatus.loading) {
                          body = CupertinoActivityIndicator();
                        } else if (mode == LoadStatus.failed) {
                          body = Text("Load Failed!Click retry!");
                        } else if (mode == LoadStatus.canLoading) {
                          body = Text("release to load more");
                        } else {
                          body = Text("No more Data");
                        }
                        return Container(
                          height: 55.0,
                          child: Center(child: body),
                        );
                      },
                    ),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: ListView(
                      children: <Widget>[
                        _buildRestaurantList(context),
                      ],
                    ),
                  ))),
    );
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));

    setState(() {
      isLoading = true;
    });
    try {
      await getSharedPrefs().then((_) {
        _refreshController.refreshCompleted();
      });
    } catch (e) {
      _refreshController.refreshFailed();
    }

    // if failed,use refreshFailed()
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length + 1).toString());
    print("hello");
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Widget _buildRestaurantList(context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              height: 100,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: 4.0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          // if (restaurant.length < data.length) {
                          //   setState(() {
                          //     restaurant = data;
                          //   });
                          // } else {
                          sort(index);
                          // }
                        },
                        child: Container(
                            height: 100,
                            width: 100,
                            child: Image.asset(
                              images[index],
                              fit: BoxFit.fill,
                            )),
                      ),
                    );
                  })),
          Container(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 80 / 30, crossAxisCount: 3),
              itemBuilder: (_, index) => Padding(
                padding: EdgeInsets.all(2),
                child: GestureDetector(
                  onTap: () {
                    sortCategory(category[index]);
                  },
                  child: Container(
                    // height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: colors[index])),
                    child: Center(
                      child: Text(category[index],
                          textAlign: TextAlign.center,
                          style: CustomFontStyle.RegularTextStyle(
                              whiteBellyColor)),
                    ),
                  ),
                ),
              ),
              itemCount: category.length,
            ),
          ),
          restaurant.length != 0
              ? Container(
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: restaurant.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return new Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              elevation: 2,
                              child:
                                  RestaurantCell(restaurant[index], snackbar)));
                    },
                  ),
                )
              : Container(
                  height: 250.0,
                  child: Center(child: Text("No Restaurant Found")),
                )
        ]);
  }

  void snackbar() {
    Utils.showSnackBar(_key1, "Restaurant is Closed");
  }
}

class RestaurantCell extends StatefulWidget {
  final RestaurantModel restaurant;
  final VoidCallback snackbar;
  RestaurantCell(this.restaurant, this.snackbar);
  @override
  _RestaurantCellState createState() => _RestaurantCellState();
}

class _RestaurantCellState extends State<RestaurantCell> {
  NetworkUtil _networkUtil = NetworkUtil();
  bool saved;
  String availableStatus = "available";
  @override
  void initState() {
    super.initState();
    print(widget.restaurant.isfavourite);
    setState(() {
      saved = widget.restaurant.isfavourite;
      availableStatus = widget.restaurant.availableStatus;
    });
    availabilityCheck();
  }

  void availabilityCheck() {
    String c = widget.restaurant.closingtime;
    TimeOfDay cTime = TimeOfDay(
        hour: int.parse(c.split(":")[0]), minute: int.parse(c.split(":")[1]));

    final now = new DateTime.now();
    DateTime closingtime =
        DateTime(now.year, now.month, now.day, cTime.hour, cTime.minute);
    String o = widget.restaurant.openingtime;
    TimeOfDay oTime = TimeOfDay(
        hour: int.parse(o.split(":")[0]), minute: int.parse(o.split(":")[1]));
    DateTime openingtime =
        DateTime(now.year, now.month, now.day, oTime.hour, oTime.minute);
    print('openin tIme is $openingtime');
    print('closing time is $closingtime');
    print("current time $now");
    print(now.isAfter(closingtime));
    print(now.isBefore(openingtime));
    if (now.isAfter(closingtime) || now.isBefore(openingtime))
      setState(() {
        print('not Available');
        availableStatus = "notAvailable";
      });
  }

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
                                  ))),
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
                    widget.restaurant.discount == 0 ||
                            widget.restaurant.discount == null
                        ? SizedBox.shrink()
                        : Positioned(
                            bottom: 10,
                            left: 0,
                            child: Container(
                                width: 60,
                                decoration: BoxDecoration(
                                    color: Colors.blue[800],
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(4),
                                        topRight: Radius.circular(4))),
                                child: Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        '${widget.restaurant.discount.toInt()}% OFF',
                                        style: TextStyle(
                                            fontFamily: 'NotoSansJP',
                                            fontSize: 12,
                                            color: whiteBellyColor),
                                      )
                                    ],
                                  ),
                                )),
                          ),
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
                        widget.restaurant.pricemin == null ||
                                widget.restaurant.pricemax == null
                            ? SizedBox.shrink()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          '${widget.restaurant.pricemin.toInt().toString()}~${widget.restaurant.pricemax.toInt().toString()}',
                                          style: TextStyle(
                                            letterSpacing: 1.0,
                                            fontFamily: 'MontserratMedium',
                                            color: Colors.black,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Price',
                                        style: TextStyle(fontSize: 7),
                                      )
                                    ],
                                  ),
                                  Container(
                                    width: 1,
                                    height: 20,
                                    color: Colors.green,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(widget.restaurant.rating == null
                                          ? '1.0'
                                          : '${widget.restaurant.rating}'),
                                      Text(
                                        'Rating',
                                        style: TextStyle(fontSize: 7),
                                      )
                                    ],
                                  ),
                                  Container(
                                    width: 1,
                                    height: 20,
                                    color: Colors.green,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          widget.restaurant.foodType != null
                                              ? widget.restaurant.foodType
                                              : 'Kind of dishes',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            letterSpacing: 1.0,
                                            fontFamily: 'MontserratMedium',
                                            color: Colors.black,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Dishes',
                                        style: TextStyle(fontSize: 7),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ]),
          Positioned(
            bottom: 55,
            right: 10,
            child: Container(
                width: 60,
                decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        '${widget.restaurant.preparationtime}',
                        style: TextStyle(fontSize: 14, color: whiteBellyColor),
                      ),
                      Text(
                        'mins',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 8, color: whiteBellyColor),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
      onTap: () {
        if (availableStatus == "available") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RestaurantDetailPage(widget.restaurant.id)),
          );
        } else {
          widget.snackbar();
        }
      },
    ));
  }
}
