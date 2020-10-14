import 'package:Belly/data/addressbook.dart';
import 'package:Belly/models/addressBook.dart';
import 'package:Belly/ui/screens/filterbottomSheet.dart';
import 'package:Belly/ui/widgets/place_picker.dart';
import 'package:flutter/material.dart';
import 'package:Belly/constants/Color.dart';
import 'package:Belly/utils/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// customised appbar for the restaurants page
class MyCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(String) sort;
  final location;
  final double height;
  final bool defaultAppBar;
  final VoidCallback locUpdate;
  AppConfig _screenConfig;
  AddressDataSource _addressDataSource = AddressDataSource();
  MyCustomAppBar(
      {Key key,
      @required this.height,
      this.location,
      this.defaultAppBar = true,
      this.locUpdate,
      this.sort})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _screenConfig = AppConfig(context);
    return Column(
      children: [
        Container(
          height: _screenConfig.rH(9),
          color: whiteColor,
          child:
              defaultAppBar ? _customAppBar(context) : _customAppBar(context),
        ),
      ],
    );
  }

  Widget _customAppBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: whiteColor, boxShadow: [
        BoxShadow(
            color: greyColor.withOpacity(.2),
            offset: Offset(0.0, 8.0),
            blurRadius: 4.0)
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // ui part displaying the user selected campus
          Row(
            children: <Widget>[
              SizedBox(
                width: 16,
              ),
              GestureDetector(
                  onTap: () async {
                    print('ssssssssssssssssssssssssssssssssssssssssss');
                    LocationResult result =
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PlacePicker(
                                  "AIzaSyDHBgQ2en98quh7noD9v_Q9cfEqNPV9sxs",
                                  // displayLocation: LatLng(10.139429, 76.464556),
                                )));
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    print('hurrrraaaaaaaaaayyyyyyyy$result');
                    prefs.setDouble('lat', result.latLng.latitude);
                    prefs.setDouble('long', result.latLng.longitude);
                    prefs.setString('locality', result.name);
                    print(result.latLng);

                    print(
                        "address : ${result.name} | ${result.locality} | ${result.city} | ${result.zip} | ${result.latLng.latitude} | ${result.latLng.longitude}");
                    locUpdate();
                    final token = prefs.getString('token');
                    result.locality =
                        result.locality == null ? "" : result.locality;

                    AddressBook address = AddressBook(
                      result.name,
                      result.locality,
                      result.city,
                      result.zip,
                      result.latLng.latitude.toString(),
                      result.latLng.longitude.toString(),
                    );

                    print("address ${address.toJson().toString()}");
                    final response =
                        await _addressDataSource.postAddress(token, address);
                    print('adresss saved');
                    prefs.setInt('addressId', response['id']);
                    print(response);
                  },
                  child: Icon(Icons.location_on)),
              Container(
                // width: 160,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    location,
                    style: TextStyle(
                        fontSize: 16,
                        color: greyColor,
                        fontWeight: FontWeight.w400,
                        fontFamily: "NotoSansJP"),
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.sort),
            ),
            onTap: () async {
              await showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return FilterBottomSheet((text) => sort(text));
                  });
            },
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
