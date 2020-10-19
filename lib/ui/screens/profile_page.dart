import 'package:Belly/ui/screens/addressPage.dart';
import 'package:Belly/ui/screens/favoritesPage.dart';
import 'package:Belly/ui/screens/notificationpage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/String.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/constants/constants.dart';
import 'package:Belly/data/my_profile_data.dart';
import 'package:Belly/models/user_model.dart';
import 'package:Belly/ui/screens/about_payment_page.dart';
import 'package:Belly/ui/screens/about_wasederi_page.dart';
import 'package:Belly/ui/screens/help_page.dart';
import 'package:Belly/ui/screens/profile_edit_page.dart';
import 'package:Belly/ui/screens/welcome_page.dart';
import 'package:Belly/utils/show_snackbar.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName, lastName;
  ProfileDataSource profileData = new ProfileDataSource();
  String token;
  User userData;
  final _key = new GlobalKey<ScaffoldState>();
  UserModel _userProvider;
  bool isGuest = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    userName = "";
    lastName = "";
    getSharedPrefs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // provider is instantiated if it's not already.
    if (_userProvider == null) {
      _userProvider = Provider.of<UserModel>(context);
    }
    // initialise user value of the user provider
    if (_userProvider.user == null || userData == null)
      _userProvider.getInitialData();
    userData = _userProvider.getUser;
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loggedIn = prefs.getBool("loggedIn").toString();
    if (loggedIn == 'null' || loggedIn == 'false') {
      isGuest = true;
    } else {
      token = prefs.getString('token');
      try {
        setState(() {
          userName = prefs.getString('user_name');
          lastName = prefs.getString('last_name');
        });
      } on Exception catch (error) {
        print(error);

        return null;
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      key: _key,
      body: _userProvider.loading || isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(greenBellyColor),
              ),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 60,
                      ),
                      isGuest ? Container() : profileDetail(),
                      SizedBox(height: 8.0),
                      isGuest
                          ? SizedBox(height: 50.0)
                          : Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  child: Text(
                                    accountDetails,
                                    style: CustomFontStyle.regularFormTextStyle(
                                        greenColor),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileEditPage()),
                                    );
                                  },
                                ),
                              ),
                            ),
                      buildInfoDetail(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget profileDetail() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: 'logo',
            child: Container(
              height: 70.0,
              width: 70.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(new Radius.circular(70.0)),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: CachedNetworkImageProvider(
                        userData == null ? userImageUrl : userData.profilePic),
                  )),
            ),
          ),
          SizedBox(height: 12.0),
          Text(
            userData == null
                ? lastName.toString() + " " + userName.toString()
                : userData.lastName.toString() + " " + userData.firstName,
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
        ]);
  }

  Widget buildInfoDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 12.0),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutPaymentPage()),
            );
          },
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 24.0, right: 24.0, top: 14.0, bottom: 14.0),
              child: Text(
                payment,
                style: CustomFontStyle.mediumTextStyle(blackColor),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritesPage()),
            );
          },
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 24.0, right: 24.0, top: 14.0, bottom: 14.0),
              child: Text(
                'Favourites',
                style: CustomFontStyle.mediumTextStyle(blackColor),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddressPAge()),
            );
          },
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 24.0, right: 24.0, top: 14.0, bottom: 14.0),
              child: Text(
                'Address',
                style: CustomFontStyle.mediumTextStyle(blackColor),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Notifications()),
            );
          },
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 24.0, right: 24.0, top: 14.0, bottom: 14.0),
              child: Text(
                'Notifications',
                style: CustomFontStyle.mediumTextStyle(blackColor),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HelpPage()),
            );
          },
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 24.0, right: 24.0, top: 14.0, bottom: 14.0),
              child: Text(
                help,
                style: CustomFontStyle.mediumTextStyle(blackColor),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutPage()),
            );
          },
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 24.0, right: 24.0, top: 14.0, bottom: 14.0),
              child: Text(
                aboutBelly,
                style: CustomFontStyle.mediumTextStyle(blackColor),
              ),
            ),
          ),
        ),

        Container(
          width: double.infinity,
          color: cloudsColor,
          child: Padding(
            padding: EdgeInsets.all(24.0),
          ),
        ),

        /// user is redirected to a page where he can login/register as user
        isGuest
            ? InkWell(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool("isGuest", false);
                  prefs.remove('lat');
                  prefs.remove('long');
                  prefs.remove('locality');
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => WelcomePage()),
                      (Route<dynamic> route) => false);
                },
                child: Container(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 24.0, right: 24.0, top: 14.0, bottom: 14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            login,
                            style: CustomFontStyle.mediumTextStyle(
                                whiteBellyColor),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: blackBellyColor,
                    )),
              )
            : InkWell(
                onTap: () {
                  containerForSheet<String>(
                    context: context,
                    child: CupertinoActionSheet(
                        title: Text(
                          areYouSureWantLogout,
                          style: CustomFontStyle.smallTextStyle(greyColor),
                        ),
                        actions: <Widget>[
                          CupertinoActionSheetAction(
                            child: Text(
                              signOut,
                              style: CustomFontStyle.regularBoldTextStyle(
                                  redColor),
                            ),
                            onPressed: () {
                              _handleLogout();
                            },
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          child: Text(
                            no,
                            style:
                                CustomFontStyle.regularBoldTextStyle(blueColor),
                          ),
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.pop(context, 'Cancel');
                          },
                        )),
                  );
                },
                child: Container(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 24.0, right: 24.0, top: 14.0, bottom: 14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            signOut,
                            style: CustomFontStyle.mediumTextStyle(blackColor),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: lightGrey,
                          width: 1.0,
                        ),
                        bottom: BorderSide(
                          color: lightGrey,
                          width: 1.0,
                        ),
                      ),
                    )),
              ),
      ],
    );
  }

  void containerForSheet<T>({BuildContext context, Widget child}) {
    showCupertinoModalPopup<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {});
  }

  _handleLogout() async {
    /// logout function clears the shared preference values and also will clear the fcm token from database
    var res = await _userProvider.logout();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('lat');
    prefs.remove('long');
    prefs.remove('locality');
    prefs.remove('notifications');
    if (res[0] == true)
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => WelcomePage()),
          (Route<dynamic> route) => false);
    else
      Utils.showSnackBar(_key, res[1]);
  }
}
