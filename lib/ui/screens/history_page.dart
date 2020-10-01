import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Belly/constants/String.dart';
import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/ui/screens/current_orders_page.dart';
import 'package:Belly/ui/screens/order_history_page.dart';
import 'package:Belly/utils/app_config.dart';

/// This view holds two tabs : current orders and previous history

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  var events = [];
  TabController controller;
  AppConfig _screenConfig;
  int tabCount;
  bool isGuest = false;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loggedIn = prefs.getBool("loggedIn").toString();
    if (loggedIn == 'null' || loggedIn == 'false') {
      setState(() {
        isGuest = true;
      });
    }
  }

  @override
  void dispose() {
    //controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    _screenConfig = AppConfig(context);
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
              child: Container(
                color: whiteColor,
                child: TabBar(
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 4.0),
                  ),
                  labelColor: blackColor,
                  unselectedLabelColor: blackColor,
                  indicatorColor: blackColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                      child: Text(
                        orderProceeding,
                        style: CustomFontStyle.regularBoldTextStyle(blackColor),
                      ),
                    ),
                    Tab(
                      child: Text(
                        orderHistory,
                        style: CustomFontStyle.regularBoldTextStyle(blackColor),
                      ),
                    ),
                  ],
                ),
              ),
              preferredSize: Size.fromHeight(_screenConfig.rH(14))),
          // user need to be logged in to have and view history
          body: isGuest
              ? Center(
                  child: Text(
                  youAreNotLoggedIn,
                  style: CustomFontStyle.regularBoldTextStyle(blackColor),
                ))
              : TabBarView(
                  children: [
                    CurrentOrderListPage(),
                    OrderHistoryPage(),
                  ],
                ),
        ),
      ),
    );
  }
}
