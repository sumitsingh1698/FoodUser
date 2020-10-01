import 'package:Belly/data/authentication_data.dart';
import 'package:Belly/ui/screens/home_screen.dart';
import 'package:Belly/ui/screens/otp_signup_verification_page.dart';
import 'package:Belly/ui/screens/signup_page.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/ui/screens/login_page.dart';
import 'package:Belly/constants/String.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This view holds two buttons so user can either login or register as a new user

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePage createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {
  bool _loader = false;
  final _key = new GlobalKey<ScaffoldState>();
  TextEditingController _mobileController = new TextEditingController();
  bool existingUser = false;
  bool numberAlreadyRegistered = false;
  AuthDataSource authData = new AuthDataSource();
  GlobalKey<FormState> _formKey = new GlobalKey();
  bool valid = false;
  _handlePhoneValidation() async {
    setState(() {
      _loader = true;
    });

    existingUser =
        await authData.sendSignUpOtpCode(_mobileController.text, _key);

    if (existingUser) {
      setState(() {
        _loader = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                OtpSignUpVerificationPage('', true, _mobileController.text)),
      );
    } else {
      setState(() {
        _loader = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignupPage(phone: _mobileController.text),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;
    return new Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: (_loader)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(greenBellyColor),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Container(
                      // color: Colors.red,
                      height: 100,
                      width: 140,
                      child: Image.asset(
                        'images/icon.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Belly',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                          fontFamily: "NotoSansJP-Bold"),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Get Started',
                      style: TextStyle(
                          fontSize: 30, fontFamily: "NotoSansJP-Bold"),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: screen_width * 0.75,
                      child: Center(
                        child: Text(
                          'Enter your phone number and we will send an OTP to continue',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15, fontFamily: "NotoSansJP-Bold"),
                        ),
                      ),
                    ),
                    SizedBox(height: 80),
                    Container(
                      child: Container(
                        width: double.infinity,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Text(titleWelcomeText,
                              //     textScaleFactor: 1.2,
                              //     style: TextStyle(
                              //         color: blackColor,
                              //         fontSize: 16,
                              //         fontWeight: FontWeight.w500,
                              //         fontFamily: "NotoSansJP-Bold")),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.0, color: Colors.black),
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        )),
                                    child: Center(
                                        child: Text(
                                      '+91',
                                      style: TextStyle(fontSize: 15),
                                    )),
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: Container(
                                      width: screen_width * 0.7,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.0, color: Colors.black),
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          )),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 4),
                                          child: TextFormField(
                                            onChanged: (value) {
                                              if (value.length == 10)
                                                setState(() {
                                                  valid = true;
                                                });
                                              else
                                                setState(() {
                                                  valid = false;
                                                });
                                            },
                                            // validator: validateMobile,
                                            controller: _mobileController,
                                            style: CustomFontStyle
                                                .regularFormTextStyle(
                                                    blackColor),
                                            keyboardType: TextInputType.phone,
                                            decoration:
                                                new InputDecoration.collapsed(
                                                    hintText: phoneNumber),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    if (valid) {
                                      _formKey.currentState.save();
                                      _handlePhoneValidation();
                                    }
                                  },
                                  child: Container(
                                    width: screen_width * 0.7,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: valid
                                            ? greenBellyColor
                                            : Colors.grey[400],
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        )),
                                    child: Center(
                                      child: Text(
                                        signup,
                                        textScaleFactor: 1.2,
                                        style: CustomFontStyle
                                            .bottomButtonTextStyle(
                                          valid ? Colors.white : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setBool("isGuest", true);
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen()),
                                        (Route<dynamic> route) => false,
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Center(
                                        child: Text(skipLogin,
                                            style: CustomFontStyle
                                                .regularBoldTextStyle(
                                                    greyColor)),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screen_height * 0.18,
                    ),
                    Container(
                      width: screen_width * 0.75,
                      child: Center(
                        child: Text(
                          'By continuing,you agree to our \nTerms of Service  Privacy Policy  Content Policy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 10, fontFamily: "NotoSansJP-Bold"),
                        ),
                      ),
                    ),
                  ],
                ),
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
}

Widget _buildLoginButton(context) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: blackBellyColor,
          shape: BoxShape.rectangle,
        ),
        child: Container(
          width: double.infinity,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Center(
              child: Text(
                login,
                style: CustomFontStyle.bottomButtonTextStyle(whiteBellyColor),
                textScaleFactor: 1.2,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
