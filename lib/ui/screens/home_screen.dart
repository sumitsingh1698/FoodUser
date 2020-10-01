import 'package:Belly/presentation/custom_icons_icons.dart';
import 'package:Belly/ui/screens/cartui.dart';
import 'package:Belly/ui/screens/offers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/String.dart';
import 'package:Belly/data/authentication_data.dart';
import 'package:Belly/models/cart_provider_class.dart';
import 'package:Belly/ui/screens/history_page.dart';
import 'package:Belly/ui/screens/restaurant_page.dart';
import 'package:Belly/ui/screens/profile_page.dart';
import 'package:Belly/ui/widgets/no_internet_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:Belly/utils/internet_connectivity.dart';

/// This view holds all tabs & its models: restaurant page, history and my profile page
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController;
  int _page = 0;
  String token;
  AuthDataSource authDataSource = new AuthDataSource();
  bool isGuest = false;
  CartModel _cart;

  @override
  void initState() {
    super.initState();
    getFCMToken();
    getSharedPrefs();
    // display no network error dialog if connection is lost
    Future.delayed(Duration(seconds: 1), () {
      MyConnectivity.instance.initialise();
      MyConnectivity.instance.myStream.listen((onData) {
        if (MyConnectivity.instance.isIssue(onData)) {
          if (MyConnectivity.instance.isShow == false) {
            MyConnectivity.instance.isShow = true;
            showDialogNotInternet(context).then((onValue) {
              MyConnectivity.instance.isShow = false;
            });
          }
        } else {
          if (MyConnectivity.instance.isShow == true) {
            Navigator.of(context).pop();
            MyConnectivity.instance.isShow = false;
          }
        }
      });
    });
    pageController = PageController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initialise cart if its provider value is null
    if (_cart == null) {
      _cart = Provider.of<CartModel>(context);
    }
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loggedIn = prefs.getBool("loggedIn").toString();
    if (loggedIn == 'null' || loggedIn == 'false') {
      isGuest = true;
    } else {
      try {
        token = prefs.getString('token');
      } on Exception catch (error) {
        print(error);
        return null;
      }
    }
    _cart.getSharedPrefs();
  }

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  /// get fcm token and register it as a device in our database
  void getFCMToken() async {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        print("title=" + message['notification']['title']);
        print("body=" + message['notification']['body']);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String> noti = prefs.getStringList("notifications");
        if (noti == null) {
          noti = [];
        }
        noti.add(
            "${message['notification']['title']} : ${message['notification']['body']}");
        prefs.setStringList("notifications", noti);
        // return;
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String> noti = prefs.getStringList("notifications");
        if (noti == null) {
          noti = [];
        }
        noti.add(
            "${message['notification']['title']} : ${message['notification']['body']}");
        prefs.setStringList("notifications", noti);
        // return;
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String> noti = prefs.getStringList("notifications");
        if (noti == null) {
          noti = [];
        }
        noti.add(
            "${message['notification']['title']} : ${message['notification']['body']}");
        prefs.setStringList("notifications", noti);
        // return;
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.getToken().then((fcmToken) {
      try {
        print("FCM token = " + fcmToken);
        // register fcm device only if the user is logged in
        if (!isGuest) authDataSource.sendFCMToken(token, fcmToken);
      } on Exception catch (e) {
        print(e);
      }
    });
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    double _labelFontSize = 10;

    return Scaffold(
      backgroundColor: whiteColor,
      body: PageView(
        children: <Widget>[
          Container(
            child: RestaurantPage(offerpage: (page) => navigationTapped(page)),
          ),
          Container(
            child: OffersPage(),
          ),
          Container(
              child: CartDetailPage(
            back: false,
          )),
          Container(
            child: HistoryPage(),
          ),
          Container(
            child: ProfilePage(),
          ),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: Container(
        child: CupertinoTabBar(
          backgroundColor: blackColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: greyColor,
                size: 22,
              ),
              activeIcon: Icon(
                Icons.home,
                color: whiteColor,
                size: 22,
              ),
              title: Text(
                home,
                style: TextStyle(
                    fontSize: _labelFontSize,
                    color: (_page == 0) ? whiteColor : Colors.grey),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                MyIcon.offerbutton,
                color: greyColor,
                size: 22,
              ),
              activeIcon: Icon(
                MyIcon.offerbutton,
                color: whiteColor,
                size: 22,
              ),
              title: Text(
                'Offers',
                style: TextStyle(
                    fontSize: _labelFontSize,
                    color: (_page == 1) ? whiteColor : Colors.grey),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                MyIcon.bellyBag,
                color: greyColor,
                size: 40,
              ),
              activeIcon: Icon(
                MyIcon.bellyBag,
                color: whiteColor,
                size: 40,
              ),
              title: Text(
                'Cart',
                style: TextStyle(
                    fontSize: _labelFontSize,
                    color: (_page == 2) ? whiteColor : Colors.grey),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.history,
                color: greyColor,
                size: 22,
              ),
              activeIcon: Icon(
                Icons.history,
                color: whiteColor,
                size: 22,
              ),
              title: Text(
                orders,
                style: TextStyle(
                    fontSize: _labelFontSize,
                    color: (_page == 3) ? whiteColor : Colors.grey),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: greyColor,
                size: 22,
              ),
              activeIcon: Icon(
                Icons.person,
                color: whiteColor,
                size: 22,
              ),
              title: Text(
                profile,
                style: TextStyle(
                    fontSize: _labelFontSize,
                    color: (_page == 4) ? whiteColor : Colors.grey),
              ),
            ),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }
}
