import 'package:flutter/material.dart';
import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/Style.dart';

class Utils {
  /// a utility to show snackbar on respective screens
  /// pass the respective scaffold key and the message to be shown
  static showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      backgroundColor: blackColor,
      content: Container(
        constraints: BoxConstraints(maxWidth: 280),
        child: new Text(message ?? 'You are offline',
            style: CustomFontStyle.smallTextStyle(whiteColor)),
      ),
    ));
  }
}
