import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/String.dart';
import 'package:Belly/constants/constants.dart';
import 'package:Belly/data/authentication_data.dart';
import 'package:Belly/ui/screens/signup_page.dart';
import 'package:Belly/ui/widgets/custom_close_app_bar.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/utils/app_config.dart';

/// First view in the new user work flow, user need to add a new phone number
class NewPhoneRegistrationPage extends StatefulWidget {
  @override
  _NewPhoneRegistrationPage createState() => _NewPhoneRegistrationPage();
}

class _NewPhoneRegistrationPage extends State<NewPhoneRegistrationPage> {
  TextEditingController _mobileController = new TextEditingController();
  bool _loader = false;
  bool phoneValidFlag = false;
  bool numberAlreadyRegistered = false;
  GlobalKey<FormState> _formKey = new GlobalKey();
  bool _validate = false;
  AuthDataSource authData = new AuthDataSource();

  _handlePhoneValidation() async {
    setState(() {
      _loader = true;
    });
    // japanese phone number entered is trimmed removing the first zero, but later added with country code +81
    phoneValidFlag = await authData.signUpPhoneValidation(
        _mobileController.text, countryCode);
    if (phoneValidFlag) {
      setState(() {
        _loader = false;
      });
// if the entered phone number is not already registered user is allowed to continue registration process
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignupPage(phone: _mobileController.text),
          ));
    } else {
      setState(() {
        _loader = false;
        // to display the error message
        numberAlreadyRegistered = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: CustomCloseAppBar(title: ""),
      body: (_loader)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(greenBellyColor),
              ),
            )
          : Stack(
              children: <Widget>[
                _buildAuthenticationUi(context),
              ],
            ),
      bottomNavigationBar: _buildBottomButton(context),
    );
  }

  Widget _buildAuthenticationUi(context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Form(
        key: _formKey,
        autovalidate: _validate,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 60),
            Text(
              pleaseEnterPhoneNumber,
              style: CustomFontStyle.mediumTextStyle(blackColor),
              textScaleFactor: 1.2,
            ),
            SizedBox(height: 30),
            Container(
              width: 400,
              decoration: BoxDecoration(
                  color: cloudsColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  )),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: TextFormField(
                  validator: validateMobile,
                  controller: _mobileController,
                  style: CustomFontStyle.regularFormTextStyle(blackColor),
                  keyboardType: TextInputType.phone,
                  decoration:
                      new InputDecoration.collapsed(hintText: phoneNumber),
                ),
              ),
            ),
            SizedBox(height: 20),
            numberAlreadyRegistered
                ? Text(
                    phoneAlreadyRegistered,
                    style: CustomFontStyle.mediumTextStyle(redColor),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  String validateMobile(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return noEmptyFields;
    } else if (value.length != 10) {
      return phoneShouldbe10Digits;
    } else if (!regExp.hasMatch(value)) {
      return "Invalid phone number";
    }
    return null;
  }

  Widget _buildBottomButton(context) {
    AppConfig _screenConfig = AppConfig(context);
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: InkWell(
          onTap: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              _handlePhoneValidation();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: blackColor,
              shape: BoxShape.rectangle,
            ),
            child: Container(
              width: double.infinity,
              height: _screenConfig.rH(8),
              child: Center(
                child: Text(
                  send,
                  style: CustomFontStyle.bottomButtonTextStyle(whiteColor),
                ),
              ),
            ),
          ),
        ));
  }
}
