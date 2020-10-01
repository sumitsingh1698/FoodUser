import 'dart:math';
import 'package:Belly/data/addressbook.dart';
import 'package:Belly/models/addressBook.dart';
import 'package:Belly/ui/widgets/place_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Belly/constants/String.dart';
import 'dart:ui';
import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/constants/constants.dart';
import 'package:Belly/data/authentication_data.dart';
import 'package:Belly/models/university_model.dart';
import 'package:Belly/models/user_signup_model.dart';
import 'package:Belly/ui/screens/home_screen.dart';
import 'package:Belly/ui/screens/otp_signup_verification_page.dart';
import 'package:Belly/ui/screens/otp_verification_password_reset.dart';
import 'package:Belly/ui/widgets/custom_close_app_bar.dart';
import 'package:Belly/utils/app_config.dart';
import 'package:Belly/utils/show_snackbar.dart';

class SignupPage extends StatefulWidget {
  final String phone;

  const SignupPage({
    Key key,
    @required this.phone,
  }) : super(key: key);

  @override
  _SignupPage createState() => _SignupPage();
}

class _SignupPage extends State<SignupPage> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  AuthDataSource authData = new AuthDataSource();
  bool _loader = false;
  bool signUpSuccessFlag = false;
  final _key = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = new GlobalKey();
  bool _validate = false;
  var passKey = GlobalKey<FormFieldState>();
  FocusNode _focusNode = new FocusNode();
  var signUpResponse;

  // default campuses are hardcoded, if this default university and campus is removed, it will throw an error in UI
  // var universitySelectedItem = "Kochi", campusSelectedItem = "Edapally";
  bool otpSentFlag = false;
  TapGestureRecognizer _recognizer1;
  TapGestureRecognizer _recognizer2;
  bool addressSaved = false;

  @override
  void initState() {
    super.initState();
    _nameController = new TextEditingController();
    _emailController = new TextEditingController();
    _focusNode.addListener(_focusNodeListener);
    _recognizer1 = TapGestureRecognizer()
      ..onTap = () {
        // launch('https://wasedeli-term-of-use.studio.design/');
      };
    _recognizer2 = TapGestureRecognizer()
      ..onTap = () {
        // launch('https://wasedeli-privacy-policy.studio.design/');
      };
    // getUniversities();
  }

  Future<Null> _focusNodeListener() async {
    if (_focusNode.hasFocus) {
      print('TextField got the focus');
    } else {
      print('TextField lost the focus');
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  _handleSignUpDataSubmission() async {
    // country code is hardcoded to +81, otp will asked in the next screen(for time being its given a dummy value)
    UserSignupModel _userData = UserSignupModel(
        _emailController.text, _nameController.text, 'xxxx', widget.phone);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              OtpSignUpVerificationPage(_userData, false, '')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _key,
      backgroundColor: whiteColor,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: CustomCloseAppBar(title: signup),
      body: (_loader)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(greenBellyColor),
              ),
            )
          : SingleChildScrollView(
              reverse: false,
              child: _buildAuthenticationUi(context),
            ),
      bottomNavigationBar: _buildBottomButton(context),
    );
  }

  Widget _buildAuthenticationUi(context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        autovalidate: _validate,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
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
                  validator: validateEmail,
                  focusNode: _focusNode,
                  decoration: new InputDecoration.collapsed(hintText: 'Email'),
                  style: TextStyle(
                    letterSpacing: 1.0,
                    fontFamily: 'MontserratMedium',
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                  ),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
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
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    child: TextFormField(
                      validator: validateName,
                      style: TextStyle(
                        letterSpacing: 1.0,
                        fontFamily: 'MontserratMedium',
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w300,
                      ),
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      decoration:
                          new InputDecoration.collapsed(hintText: fullname),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            SizedBox(height: 30),
            SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(
                text: disclaimer1,
                style: CustomFontStyle.smallTextStyle(blackColor),
                children: <TextSpan>[
                  TextSpan(
                    text: termsOfService,
                    recognizer: _recognizer1,
                    style: CustomFontStyle.smallTextStyle(blueColor),
                  ),
                  TextSpan(
                    text: disclaimer2,
                    style: CustomFontStyle.smallTextStyle(blackColor),
                  ),
                  TextSpan(
                    text: privacypolicy,
                    recognizer: _recognizer2,
                    style: CustomFontStyle.smallTextStyle(blueColor),
                  ),
                  TextSpan(
                    text: disclaimer3,
                    style: CustomFontStyle.smallTextStyle(blackColor),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
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
              _handleSignUpDataSubmission();
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
                  newRegistration,
                  style: TextStyle(
                    letterSpacing: 1.0,
                    fontFamily: 'MontserratMedium',
                    color: whiteBellyColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                  textScaleFactor: 1.2,
                ),
              ),
            ),
          ),
        ));
  }
}

String validateName(String value) {
  if (value.length == 0) {
    return noEmptyFields;
  }
  return null;
}

String validateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return noEmptyFields;
  } else if (!regExp.hasMatch(value)) {
    return invalidEmail;
  } else {
    return null;
  }
}
