import 'package:Belly/ui/widgets/custom_close_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<String> data;
  bool loading = true;
  bool isGuest = false;
  SharedPreferences prefs;
  @override
  void initState() {
    getSharedPrefs();
    super.initState();
  }

  Future<Null> getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    var loggedIn = prefs.getBool("loggedIn").toString();
    if (loggedIn == 'null' || loggedIn == 'false') {
      setState(() {
        isGuest = true;
      });
    }
    getNotification();
  }

  void getNotification() async {
    List<String> noti = prefs.getStringList("notifications");
    if (noti == null) {
      noti = [];
    }
    setState(() {
      data = noti;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomCloseAppBar(
          title: 'Notification',
        ),
        body: loading
            ? Center(child: CupertinoActivityIndicator())
            : isGuest
                ? Center(child: Text('Please Login :)'))
                : data.length == 0
                    ? Center(
                        child: Text('You Have No Notifications Currently :)'))
                    : Container(
                        child: Column(
                        children: <Widget>[
                          RaisedButton(
                            color: Colors.white,
                            child: Text(
                              'Clear',
                              style: TextStyle(color: Colors.green),
                            ),
                            onPressed: () {
                              prefs.remove('notifications');
                              setState(() {
                                data = [];
                              });
                            },
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: 10,
                              // data.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Card(
                                    elevation: 2,
                                    child: Center(
                                      child: Container(
                                        color: Colors.red,
                                        // width: MediaQuery.of(context).size.width,
                                        child: Center(
                                          child: Text(
                                            data[index],
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ],
                      )));
  }
}
