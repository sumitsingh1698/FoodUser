import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Belly/models/cart_provider_class.dart';
import 'package:Belly/models/user_model.dart';
import 'package:Belly/ui/screens/home_screen.dart';
import 'package:Belly/ui/screens/welcome_page.dart';

void main() async {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State createState() => new MyAppState();

  MyApp({Key key}) : super(key: key);
}

class MyAppState extends State<MyApp> {
  Widget _defaultHome = new WelcomePage();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    initSharedPreference();
  }

  void initSharedPreference() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    // user is led to welcome page only if he is first time
    var loggedIn = _sharedPreferences.getBool("loggedIn").toString();
    var isGuest = _sharedPreferences.getBool("isGuest").toString();
    if (loggedIn != 'null' && loggedIn != 'false') {
      Timer(Duration(milliseconds: 120), () {
        setState(() {
          _loading = false;
          _defaultHome = new HomeScreen();
        });
      });
    } else if (isGuest != 'null' && isGuest != 'false')
      _defaultHome = new HomeScreen();

    Timer(Duration(milliseconds: 1200), () {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    /// Builds the necessary providers, as well as the home page.
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: CartModel()),
          ChangeNotifierProvider.value(value: UserModel()),
        ],
        child: new MaterialApp(
          debugShowCheckedModeBanner: false,
          home: _loading ? SplashScreen() : _defaultHome,
          title: 'Belly',
          theme: ThemeData(primarySwatch: Colors.green),
        ));
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(1, 190, 100, 1),
      // greenBellyColor,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
          child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          'images/splashscreen.png',
          fit: BoxFit.contain,
        ),
      )),
    );
  }
}
