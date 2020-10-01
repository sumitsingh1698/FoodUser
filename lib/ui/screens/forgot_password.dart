import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/String.dart';
import 'package:Belly/constants/constants.dart';
import 'package:Belly/data/authentication_data.dart';
import 'package:Belly/ui/widgets/custom_close_app_bar.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/utils/app_config.dart';
import '../screens/otp_verification_password_reset.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPage createState() => _ForgotPasswordPage();
}

class _ForgotPasswordPage extends State<ForgotPasswordPage> {
  TextEditingController _phoneController = new TextEditingController();

  bool _loader = false;
  bool validPhoneFlag = false;
  bool otpSentFlag = false;
  final _key = new GlobalKey<ScaffoldState>();
  AuthDataSource authData = new AuthDataSource();
  GlobalKey<FormState> _formKey = new GlobalKey();
  bool _validate = false;

  _handlePhoneVerification() async {
    setState(() {
      _loader = true;
    });
    validPhoneFlag = await authData.passwordResetPhoneValidation(
        _phoneController.text, countryCode);
    if (validPhoneFlag) {
      _loader = false;
      otpSentFlag = await authData.sendOtpCode(_phoneController.text);
      if (otpSentFlag) {
        _loader = false;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtpPasswordResetPage(
                    phone: _phoneController.text
                        .substring(_phoneController.text.length - 10),
                  )),
        );
      }
    } else {
      setState(() {
        _loader = false;
      });
      _showSnackBar(invalidPhoneNumber);
    }
  }

  _showSnackBar(text) {
    _key.currentState.showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: greenBellyColor,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _key,
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
    return Form(
        key: _formKey,
        autovalidate: _validate,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  forgotPassword,
                  style: CustomFontStyle.mediumTextStyle(greenColor),
                  textScaleFactor: 1.2,
                ),
              ),
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: TextFormField(
                    style: CustomFontStyle.regularFormTextStyle(blackColor),
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    validator: validateMobile,
                    decoration:
                        new InputDecoration.collapsed(hintText: phoneNumber),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildBottomButton(context) {
    AppConfig _screenConfig = AppConfig(context);
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: InkWell(
          onTap: () {
            if (_formKey.currentState.validate()) {
              FocusScope.of(context).requestFocus(new FocusNode());
              _handlePhoneVerification();
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
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Center(
                  child: Text(
                    send,
                    style: CustomFontStyle.bottomButtonTextStyle(whiteColor),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
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
