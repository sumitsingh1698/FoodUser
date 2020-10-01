import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/String.dart';
import 'package:Belly/data/authentication_data.dart';
import 'package:Belly/ui/screens/forgot_password.dart';
import 'package:Belly/ui/screens/home_screen.dart';
import 'package:Belly/ui/widgets/custom_close_app_bar.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/utils/app_config.dart';
import 'package:Belly/utils/show_snackbar.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  bool _loader = false;
  bool loginSuccessFlag = false;
  final _key = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = new GlobalKey();
  bool _validate = false;
  AuthDataSource authData = new AuthDataSource();

  _handleLogin() async {
    setState(() {
      _loader = true;
    });
    loginSuccessFlag = await authData.loginOtpAuthentication(
        _phoneController.text, _passwordController.text);
    if (loginSuccessFlag) {
      _loader = false;
      // if the login success user is taken to homepage
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      setState(() {
        _loader = false;
      });
      Utils.showSnackBar(_key, loginError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _key,
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.white,
      appBar: CustomCloseAppBar(title: login),
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidate: _validate,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 26),
              Container(
                width: 400,
                decoration: BoxDecoration(
                    color: formBgColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    )),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                  child: TextFormField(
                    controller: _phoneController,
                    validator: validateMobile,
                    decoration:
                        new InputDecoration.collapsed(hintText: phoneNumber),
                    style: CustomFontStyle.regularFormTextStyle(blackColor),
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: 400,
                decoration: BoxDecoration(
                    color: formBgColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: TextFormField(
                    style: CustomFontStyle.regularFormTextStyle(blackColor),
                    controller: _passwordController,
                    validator: validatePassword,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration:
                        new InputDecoration.collapsed(hintText: password),
                  ),
                ),
              ),
              SizedBox(height: 14),
              InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(forgotPassword,
                        style: CustomFontStyle.smallTextStyle(greenColor)),
                  )),
            ],
          ),
        ),
      ),
    );
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
              _handleLogin();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: blackBellyColor,
              shape: BoxShape.rectangle,
            ),
            child: Container(
              width: double.infinity,
              height: _screenConfig.rH(8),
              child: Center(
                child: Text(
                  login,
                  style: CustomFontStyle.bottomButtonTextStyle(whiteBellyColor),
                ),
              ),
            ),
          ),
        ));
  }

  String validateMobile(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return noEmptyFields;
    } else if (value.length != 10) {
      //phone number should be 10 digits
      return phoneShouldbe10Digits;
    } else if (!regExp.hasMatch(value)) {
      return "Invalid phone number";
    }
    return null;
  }

  String validatePassword(String password) {
    if (password.length == 0) {
      return noEmptyFields;
    } else {
      return null;
    }
  }
}
