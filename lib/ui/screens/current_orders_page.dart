import 'package:flutter/cupertino.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Belly/constants/String.dart';
import 'package:flutter/material.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/constants/Color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Belly/data/order_history_data.dart';
import 'package:Belly/models/current_orders_model.dart';
import 'package:Belly/models/past_order_model.dart';

import 'delivery_tracking_page.dart';

class CurrentOrderListPage extends StatefulWidget {
  @override
  _CurrentOrderListPageState createState() => _CurrentOrderListPageState();
}

class _CurrentOrderListPageState extends State<CurrentOrderListPage> {
  bool isLoading = true;
  String token;
  OrderHistoryDataSource _orderHistoryDataSource = new OrderHistoryDataSource();

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      token = prefs.getString('token');
      setState(() {
        isLoading = false;
      });
    } on Exception catch (error) {
      print(error);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: (isLoading)
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(greenBellyColor),
                ),
              )
            : Stack(children: <Widget>[
                Container(
                  color: whiteColor,
                ),
                _buildMyOrderList(context),
              ])
        // Center(child: _buildNoOrderUi(context)),
        );
  }

  Widget _buildNoOrderUi() {
    return Center(
        child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Icon(
              Icons.history,
              color: greyTextColor,
              size: 90,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              noCurrentOrder,
              style: CustomFontStyle.regularBoldTextStyle(greyTextColor),
            ),
          )
        ],
      ),
    ));
  }

  Widget _buildMyOrderList(context) {
    print('My Orderssss');
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: FutureBuilder<List<CurrentOrderModel>>(
            future: _orderHistoryDataSource.getCurrentOrders(token, "1"),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                print('entereeeedd ${snapshot.data.length}');
                return snapshot.data.length != 0
                    ? Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    child: PagewiseListView(
                                        pageSize: snapshot.data.length,
                                        loadingBuilder: (context) {
                                          return CupertinoActivityIndicator();
                                        },
                                        itemBuilder: (context,
                                            CurrentOrderModel snapshot,
                                            int index) {
                                          return InkWell(
                                            child: new Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8.0),
                                                child: OrderCell(
                                                  index,
                                                  snapshot,
                                                )),
                                          );
                                        },
                                        pageFuture: (pageIndex) =>
                                            _orderHistoryDataSource
                                                .getCurrentOrders(
                                                    token,
                                                    (pageIndex + 1)
                                                        .toString()))),
                              ],
                            ),
                          ),
                        ],
                      )
                    : _buildNoOrderUi();
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }
}

class OrderCell extends StatelessWidget {
  final i;
  final CurrentOrderModel data;

  OrderCell(this.i, this.data);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12.0),
      child: Container(
          child: InkWell(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: new AspectRatio(
                        aspectRatio: 2 / 1,
                        child: Container(
                            child: data.restaurantImage == null
                                ? Container(
                                    color: cloudsColor,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: data.restaurantImage,
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: data.tracking.status ? 150 : 100,
                      color: whiteColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 24,
                                ),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    data.restaurantName,
                                    style: CustomFontStyle.mediumTextStyle(
                                        grey1Color),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    data.status,
                                    style: CustomFontStyle.mediumTextStyle(
                                        greenColor),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                SizedBox(
                                  width: 24,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 24,
                              ),
                              Text(
                                orderDate + " : ",
                                style: TextStyle(
                                  letterSpacing: 1.0,
                                  fontFamily: 'MontserratMedium',
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                data.slottime.substring(5, 7) +
                                    "/" +
                                    data.slottime.substring(8, 10) +
                                    "  " +
                                    data.slottime.substring(11, 16),
                                style: TextStyle(
                                  letterSpacing: 1.0,
                                  fontFamily: 'NotoSansJP-Bold',
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SizedBox(
                                width: 24,
                              ),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      orderNumber + " : ",
                                      style: TextStyle(
                                        letterSpacing: 1.0,
                                        fontFamily: 'MontserratMedium',
                                        color: Colors.black,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Text(
                                      data.orderNo,
                                      style: TextStyle(
                                        letterSpacing: 1.0,
                                        fontFamily: 'NotoSansJP-Bold',
                                        color: Colors.black,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
//                              Expanded(
//                                child: Text(
//                                  data.status,
//                                  style: TextStyle(
//                                    letterSpacing: 1.0,
//                                    fontFamily: 'NotoSansJP-Bold',
//                                    color: greenColor,
//                                    fontSize: 12.0,
//                                    fontWeight: FontWeight.w300,
//                                  ),
//                                ),
//                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          data.tracking.status
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DeliveryTrackingPage(
                                                      data.tracking
                                                          .deliveryStaff,
                                                      data.tracking.orderId,
                                                      data.id)),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: blackColor,
                                          shape: BoxShape.rectangle,
                                        ),
                                        height: 45,
                                        width: 180,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0, right: 16.0),
                                          child: Center(
                                            child: Text(
                                              trackDeliveryStatus,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: whiteColor,
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily: "NotoSansJP"),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 24,
                                    ),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ]),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => _buildDialog(context));
              })),
    );
  }

  Widget _buildDialog(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: SingleChildScrollView(
        child: Container(
          width: 327.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  billForThisOrder,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Container(
                height: 1,
                color: cloudsColor,
              ),
              Padding(
                  padding: EdgeInsets.all(15.0),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: data.orderitems.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) =>
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  data.orderitems[index].itemName +
                                      " x " +
                                      data.orderitems[index].count.toString(),
                                  style: TextStyle(color: blackColor),
                                ),
                                Text(
                                  data.orderitems[index].itemtotal.toString(),
                                  style: TextStyle(color: blackColor),
                                )
                              ],
                            ),
                          ))),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      subTotal + " : ",
                      style: TextStyle(color: blackColor),
                    ),
                    Text(
                      data.grandtotal.toString(),
                      style: TextStyle(color: blackColor),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      totalAmount + " : ",
                      style: TextStyle(color: blackColor),
                    ),
                    Text(
                      data.grandtotal.toString() + " " + taxIncluding,
                      style: TextStyle(color: blackColor),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: cloudsColor,
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      address + '  ID',
                      style: TextStyle(color: blackColor),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          data.address != null ? data.address.toString() : '',
                          style: TextStyle(color: blackColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 50.0)),
              Container(
                height: 1,
                color: cloudsColor,
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    close,
                    style: TextStyle(fontSize: 18.0),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
