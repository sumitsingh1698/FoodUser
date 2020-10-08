import 'package:Belly/models/cart_upload_request_model.dart';
import 'package:Belly/ui/screens/cartbottomsheet.dart';
import 'package:Belly/ui/screens/food_searchPage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/constants/String.dart';
import 'package:Belly/data/restaurant_data.dart';
import 'package:Belly/models/cart_provider_class.dart';
import 'package:Belly/models/restaurant_detail_model.dart';
import 'package:Belly/ui/widgets/menu_list_cell.dart';

class RestaurantDetailPage extends StatefulWidget {
  final restaurantId;

  RestaurantDetailPage(this.restaurantId);

  @override
  _RestaurantDetailPage createState() => new _RestaurantDetailPage();
}

class _RestaurantDetailPage extends State<RestaurantDetailPage> {
  bool _dataLoaded;
  String token;
  RestaurantDataSource _restaurantDataSource = new RestaurantDataSource();
  RestaurantDetailResponse data;
  bool isGuest = false;
  String slug = '';
  String categoryName = '';
  bool heading = true;
  bool veg = false;
  bool nonveg = false;
  bool egg = false;
  List<String> tabheading = [];
  int initPosition = 0;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _dataLoaded = false;
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
    }
    getData();
  }

  void getData() async {
    data = await _restaurantDataSource.restaurantDetail(
        token, widget.restaurantId);
    print(data);
    print('caaaaatttttttttteeeeeeeeeeeggggggoryyyyy');
    data.single.forEach((e) {
      if (!tabheading.contains(e.category)) {
        tabheading.add(e.category);
        print(tabheading);
      }
    });
    setState(() {
      _dataLoaded = true;
    });
  }

  selectedAdd(String itemSlug) {
    setState(() {
      slug = itemSlug;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _cartProvider = Provider.of<CartModel>(context, listen: true);
    double hscreen = MediaQuery.of(context).size.height;
    double wscreen = MediaQuery.of(context).size.width;
    categoryName = '';
    return Scaffold(
        body: _dataLoaded == false
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(greenBellyColor),
                ),
              )
            : Container(
                color: Colors.black,
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                      color: whiteColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Column(
                                  mainAxisSize: MainAxisSize.min,
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Stack(
                                      children: <Widget>[
                                        Container(
                                          height: hscreen * 0.27,
                                          width: wscreen,
                                          child: ClipRRect(
                                              child: data.restaurant[0].logo ==
                                                      null
                                                  ? Container(
                                                      color: cloudsColor,
                                                    )
                                                  : CachedNetworkImage(
                                                      imageUrl: data
                                                          .restaurant[0].logo,
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          new Icon(Icons.error),
                                                      fit: BoxFit.cover,
                                                    )),
                                        ),
                                        Positioned(
                                          top: 4,
                                          left: 0,
                                          child: IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        )
                                        // Positioned(
                                        //     top: 0,
                                        //     right: 0,
                                        //     child: IconButton(
                                        //       onPressed: addToFav,
                                        //       icon: Icon(
                                        //         saved
                                        //             ? Icons.favorite
                                        //             : Icons.favorite_border,
                                        //         color: Colors.red,
                                        //       ),
                                        //     )),
                                        //     Positioned(
                                        //       bottom: 10,
                                        //       left: 0,
                                        //       child: Container(
                                        //           width: 60,
                                        //           decoration: BoxDecoration(
                                        //               color: Colors.blue[800],
                                        //               borderRadius:
                                        //                   BorderRadius.only(
                                        //                       bottomRight:
                                        //                           Radius.circular(
                                        //                               4),
                                        //                       topRight:
                                        //                           Radius.circular(
                                        //                               4))),
                                        //           child: Padding(
                                        //             padding: EdgeInsets.all(2.0),
                                        //             child: Column(
                                        //               children: <Widget>[
                                        //                 // Text(
                                        //                 //   '30% OFF',
                                        //                 //   style: TextStyle(
                                        //                 //       fontFamily:
                                        //                 //           'NotoSansJP',
                                        //                 //       fontSize: 12,
                                        //                 //       color:
                                        //                 //           whiteBellyColor),
                                        //                 // )
                                        //               ],
                                        //             ),
                                        //           )),
                                        //     ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(8, 8, 4, 6),
                                      child: Container(
                                        color: whiteColor,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Text(data.restaurant[0].name,
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
                                            data.restaurant[0].pricemin ==
                                                        null ||
                                                    data.restaurant[0]
                                                            .pricemax ==
                                                        null
                                                ? SizedBox.shrink()
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: <Widget>[
                                                      Column(
                                                        children: <Widget>[
                                                          Container(
                                                            child: Text(
                                                              '${data.restaurant[0].pricemin.toInt().toString()}~${data.restaurant[0].pricemax.toInt().toString()}',
                                                              style: TextStyle(
                                                                letterSpacing:
                                                                    1.0,
                                                                fontFamily:
                                                                    'MontserratMedium',
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            'Price',
                                                            style: TextStyle(
                                                                fontSize: 7),
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
                                                          Text(data.restaurant[0]
                                                                      .rating ==
                                                                  null
                                                              ? '1.0'
                                                              : '${data.restaurant[0].rating}'),
                                                          Text(
                                                            'Rating',
                                                            style: TextStyle(
                                                                fontSize: 7),
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
                                                              data.restaurant[0]
                                                                          .foodType !=
                                                                      null
                                                                  ? data
                                                                      .restaurant[
                                                                          0]
                                                                      .foodType
                                                                  : 'Kind of dishes',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                letterSpacing:
                                                                    1.0,
                                                                fontFamily:
                                                                    'MontserratMedium',
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            'Dishes',
                                                            style: TextStyle(
                                                                fontSize: 7),
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
                                            '${data.restaurant[0].preperationtime}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: whiteBellyColor),
                                          ),
                                          Text(
                                            'mins',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 8,
                                                color: whiteBellyColor),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 26.0, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Veg',
                                      style: TextStyle(
                                          color: veg
                                              ? Colors.green[900]
                                              : Colors.grey),
                                    ),
                                    Switch(
                                      activeColor: Colors.green[900],
                                      value: veg,
                                      onChanged: (value) {
                                        setState(() {
                                          veg = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      menu,
                                      style:
                                          CustomFontStyle.mediumBoldTextStyle(
                                              blackColor),
                                    ),
                                    GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            _dataLoaded = false;
                                          });
                                          await Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return FoodSearch(data.single);
                                          }));
                                          setState(() {
                                            _dataLoaded = true;
                                          });
                                        },
                                        child: Icon(Icons.search))
                                  ],
                                ),
                              ],
                            ),
                          ),
                          tabheading.isNotEmpty
                              ? Container(
                                  height: 450,
                                  child: CustomTabView(
                                    initPosition: initPosition,
                                    itemCount: tabheading.length,
                                    onPositionChange: (index) {
                                      print('current position: $index');
                                      initPosition = index;
                                    },
                                    pageBuilder: (context, indexP) {
                                      return Container(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            physics: ScrollPhysics(),
                                            itemBuilder: ((context, index) {
                                              return Column(
                                                children: <Widget>[
                                                  tabheading[indexP] ==
                                                          data.single[index]
                                                              .category
                                                      ? Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top:
                                                                      index == 0
                                                                          ? 10.0
                                                                          : 0),
                                                          child: veg
                                                              ? data.single[index].diet ==
                                                                      'Veg'
                                                                  ? MenuCell(
                                                                      data.single[
                                                                          index],
                                                                      index,
                                                                      slug,
                                                                      selectedAdd)
                                                                  : SizedBox
                                                                      .shrink()
                                                              : MenuCell(
                                                                  data.single[
                                                                      index],
                                                                  index,
                                                                  slug,
                                                                  selectedAdd))
                                                      : SizedBox.shrink()
                                                ],
                                              );
                                            }),
                                            itemCount: data.single.length),
                                      );
                                    },
                                    tabBuilder: (context, index) {
                                      return Tab(
                                        text: tabheading[index],
                                      );
                                    },
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        bottomNavigationBar: Consumer<CartModel>(
          builder: (context, cartRepo, child) =>
              cartRepo.itemCount != 0 && cartRepo.itemCount != null
                  ? _buildBottomButton(
                      context,
                      cartRepo.totalPrice.toInt().toString(),
                      cartRepo.itemCount.toString())
                  : Container(
                      height: 0,
                    ),
        ));
  }

  Widget _buildBottomButton(context, String _totalPrice, String itemCount) {
    return InkWell(
        onTap: () async {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return CartBottomSheet();
              });
          // await Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => OrderConfirmationPage()));
          setState(() {
            selectedAdd('');
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: greenBellyColor,
            shape: BoxShape.rectangle,
          ),
          child: Container(
            width: double.infinity,
            height: 60,
            child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '$itemCount ITEMS',
                          style:
                              TextStyle(color: Colors.white, letterSpacing: 1),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          '₹ $_totalPrice  plus taxes',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    Text(
                      'View Cart',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )
                  ],
                )),
          ),
        ));
  }
}

class CustomTabView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget stub;
  final ValueChanged<int> onPositionChange;
  final ValueChanged<double> onScroll;
  final int initPosition;

  CustomTabView({
    @required this.itemCount,
    @required this.tabBuilder,
    @required this.pageBuilder,
    this.stub,
    this.onPositionChange,
    this.onScroll,
    this.initPosition,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView>
    with TickerProviderStateMixin {
  TabController controller;
  int _currentCount;
  int _currentPosition;

  @override
  void initState() {
    _currentPosition = widget.initPosition ?? 0;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition;
      }

      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              widget.onPositionChange(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller.animateTo(widget.initPosition);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.animation.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount < 1) return widget.stub ?? Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: TabBar(
            isScrollable: true,
            controller: controller,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).hintColor,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
            ),
            tabs: List.generate(
              widget.itemCount,
              (index) => widget.tabBuilder(context, index),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: List.generate(
              widget.itemCount,
              (index) => widget.pageBuilder(context, index),
            ),
          ),
        ),
      ],
    );
  }

  onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange(_currentPosition);
      }
    }
  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll(controller.animation.value);
    }
  }
}
