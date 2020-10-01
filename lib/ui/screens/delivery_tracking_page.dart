import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/constants/String.dart';
import 'package:Belly/data/my_profile_data.dart';
import 'package:Belly/utils/show_snackbar.dart';

class DeliveryTrackingPage extends StatefulWidget {
  final deliveryId, bucketId, orderId;

  DeliveryTrackingPage(this.deliveryId, this.bucketId, this.orderId);

  @override
  _DeliveryTrackingPageState createState() {
    return _DeliveryTrackingPageState();
  }
}

class _DeliveryTrackingPageState extends State<DeliveryTrackingPage> {
  Completer<GoogleMapController> _mapController = Completer();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  Set<Marker> markers = Set();
  String userName;
  bool _dataLoaded = false;
  bool _enabledTracking = true;
  String token;
  ProfileDataSource _otherContentsData = new ProfileDataSource();
  var data;

  @override
  void initState() {
    super.initState();
    _dataLoaded = false;
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    getData();
  }

  void getData() async {
    data = await _otherContentsData.checkDeliveryTracking(
        token, widget.bucketId, widget.orderId);
    setState(() {
      _dataLoaded = true;
    });
    if (_dataLoaded) if (!data['status'])
      _enabledTracking = false;
    else
      _getDeliLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
          _backButton(),
          _dataLoaded && !_enabledTracking ? _buildErrorWidget() : Container()
        ],
      ),
    );
  }

  _getDeliLocations() {
    Firestore.instance
        .collection('deliLocations')
        .document(widget.deliveryId)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> firestoreInfo = documentSnapshot.data;
      print('on location update');
      _plotMarker(firestoreInfo['posLat'], firestoreInfo['posLng']);
    }).onError((error) {
      print("Something went wrong: ${error.message}");
      Utils.showSnackBar(_scaffoldKey, error.message);
    });
  }

  Widget _backButton() {
    return Positioned(
      bottom: 60,
      left: 10,
      child: InkWell(
        onTap: () async {
          Navigator.of(context).pop(true);
        },
        child: Container(
          width: 160.0,
          height: 50.0,
          child: new Container(
            decoration: new BoxDecoration(
                color: whiteColor,
                borderRadius: new BorderRadius.all(const Radius.circular(8.0))),
            child: Center(
              child: Text(
                returnText,
                style: CustomFontStyle.mediumBoldTextStyle(blackColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          color: cloudsColor,
          margin: EdgeInsets.symmetric(vertical: 0.0),
          width: double.infinity,
          height: 50.0,
          child: Center(
            child: Text(
              "error " + data['message'],
              style: CustomFontStyle.smallTextStyle(blackColor),
            ),
          )),
    );
    //   );
  }

  void _plotMarker(double lat, double lng) {
    LatLng _target = LatLng(lat, lng);
    this._mapController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _target,
            zoom: 15.0,
          ),
        ),
      );
    });
    markers.clear();
    Marker resultMarker = Marker(
        markerId: MarkerId((lat + lng).toString()),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: LatLng(lat, lng));

    setState(() {
      markers.add(resultMarker);
    });
  }

  Widget _buildGoogleMap(BuildContext context) {
    CameraPosition _defaultPos =
        new CameraPosition(target: LatLng(35.652832, 139.839478), zoom: 12);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        initialCameraPosition: _defaultPos,
        onMapCreated: onMapCreated,
        markers: markers,
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    this._mapController.complete(controller);
    getCurrentUserLocation();
  }

  void getCurrentUserLocation() {
    var location = Location();
    location.getLocation().then((locationData) {
      LatLng target = LatLng(locationData.latitude, locationData.longitude);
      moveToLocation(target);
    }).catchError((error) {
      // TODO: Handle the exception here
      print(error);
    });
  }

  void moveToLocation(LatLng latLng) {
    this._mapController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: latLng,
            zoom: 15.0,
          ),
        ),
      );
    });
  }
}
