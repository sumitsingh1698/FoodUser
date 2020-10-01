import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/String.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/models/addressBook.dart';
import 'package:Belly/ui/widgets/custom_close_app_bar.dart';
import 'package:Belly/utils/base_url.dart';
import 'package:Belly/utils/network_utils.dart';
import 'package:Belly/utils/show_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressPAge extends StatefulWidget {
  @override
  _AddressPAgeState createState() => _AddressPAgeState();
}

class _AddressPAgeState extends State<AddressPAge> {
  bool isGuest = false;
  SharedPreferences prefs;
  String token;
  bool isLoading = true;
  NetworkUtil _networkUtil = NetworkUtil();
  String baseurl = BaseUrl().mainUrl;
  List<AddressBook> data = [];
  String lat = '';
  String long = '';
  String name = '';
  int addressId;
  final _key = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  void getData() async {
    String url = baseurl + 'addressbook/';
    List res = await _networkUtil.getAddress(url, token);
    List<AddressBook> addresses =
        res.map((e) => AddressBook.fromJson(e)).toList();
    addresses.forEach((e) {
      print('mapping mapping');
      print(prefs.getDouble('lat'));
      print(e.lat);
      if (e.lat == prefs.getDouble('lat').toString() &&
          e.long == prefs.getDouble('long').toString()) {
        print('kkkkkkkkkkkkkkkkkkkkkkkkkk');
        setState(() {
          lat = e.lat;
          long = e.long;
          name = e.name;
          addressId = e.id;
        });
      }
    });
    setState(() {
      data = addresses;
      isLoading = false;
    });
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
    if (isGuest)
      setState(() {
        isLoading = false;
      });
    else
      getData();
  }

  Widget addressWidget() {
    return ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          String use = 'Use';
          if (lat == data[index].lat && long == data[index].long) {
            use = 'Current Address';
          }
          print(data[index].name);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 2,
              child: Container(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "ID  " + data[index].id.toString(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              data[index].name,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              data[index].address,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              data[index].pincode,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        Positioned(
                          top: 0,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              print(data[index].id);
                              prefs.setInt('addressId', data[index].id);
                              prefs.setDouble(
                                  'lat', double.parse(data[index].lat));
                              prefs.setDouble(
                                  'long', double.parse(data[index].long));
                              prefs.setString('locality', data[index].name);
                              setState(() {
                                lat = data[index].lat;
                                long = data[index].long;
                                addressId = data[index].id;
                              });
                            },
                            child: Text(
                              use,
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 8,
                          child: GestureDetector(
                              onTap: () async {
                                String url =
                                    baseurl + 'addressbook/${data[index].id}/';
                                final res = await _networkUtil.deleteAddress(
                                    url, token);
                                Utils.showSnackBar(_key, res['message']);
                                setState(() {
                                  getData();
                                });
                                if (data[index].id == addressId) {
                                  prefs.remove('addressId');
                                  prefs.remove("lat");
                                  prefs.remove("long");
                                  prefs.remove("locality");
                                }
                              },
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              )),
                        )
                      ],
                    )),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        appBar: CustomCloseAppBar(
          title: 'Your Addresses',
        ),
        body: isLoading
            ? Center(child: CupertinoActivityIndicator())
            : isGuest
                ? Center(
                    child: Text('You need to Login :(',
                        style:
                            CustomFontStyle.mediumTextStyle(blackBellyColor)),
                  )
                : addressWidget());
  }
}
