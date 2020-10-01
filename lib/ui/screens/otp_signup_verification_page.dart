import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/constants/String.dart';
import 'package:Belly/data/authentication_data.dart';
import 'package:Belly/models/user_signup_model.dart';
import 'package:Belly/ui/screens/home_screen.dart';
import 'package:Belly/ui/widgets/custom_close_app_bar.dart';
import 'package:Belly/utils/app_config.dart';
import 'package:Belly/utils/show_snackbar.dart';

class OtpSignUpVerificationPage extends StatefulWidget {
  final dynamic userData;
  final bool login;
  final String phoneNumber;
  OtpSignUpVerificationPage(this.userData, this.login, this.phoneNumber);

  @override
  _OtpState createState() => new _OtpState();
}

class _OtpState extends State<OtpSignUpVerificationPage>
    with SingleTickerProviderStateMixin {
  TextEditingController controller = TextEditingController();
  String thisText = "";
  int pinLength = 4;
  bool hasError = false;
  String errorMessage;
  AuthDataSource authData = new AuthDataSource();
  bool otpCorrectFlag = false;
  bool otpResentFlag = false;
  bool _loader = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  AppConfig _screenConfig;

  _handleLoginOtp(String otp) async {
    setState(() {
      _loader = true;
    });
    bool loginSuccessFlag =
        await authData.loginOtpAuthentication(widget.phoneNumber, otp);
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
      Utils.showSnackBar(scaffoldKey, 'Try again :(');
    }
  }

  _handleOTPVerification(String otp) async {
    widget.userData.otp = otp;
    // otp entered is added to user signup model and sent through api
    var res = await authData.signUpOtpAuthentication(widget.userData.toJson());
    if (res[0]) {
      // flag true means a new user is created in our database
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false,
      );
    } else
      // display the error message returned, if the signup failed.
      Utils.showSnackBar(scaffoldKey, res[1]);
  }

  _handleResendOtp() async {
    // api call to resend an otp, this will generate a new otp code
    // if (widget.login) {
    //   otpResentFlag = await authData.sendOtpCode(widget.phoneNumber);
    // } else {
    //   otpResentFlag = await authData.sendOtpCode(widget.userData.mobile);
    // }
    // if (otpResentFlag) {
    //   Utils.showSnackBar(scaffoldKey, otpResend);
    // }
  }

  @override
  Widget build(BuildContext context) {
    _screenConfig = AppConfig(context);
    return new Scaffold(
      key: scaffoldKey,
      appBar: CustomCloseAppBar(
        title: oneTimePassword,
      ),
      backgroundColor: Colors.white,
      body: (_loader)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(greenBellyColor),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: _screenConfig.rH(6)),
                _getVerificationCodeLabel,
                SizedBox(height: _screenConfig.rH(10)),
                _getInputField(),
                SizedBox(height: _screenConfig.rH(4)),
                _getResendButton,
              ],
            ),
    );
  }

  get _getVerificationCodeLabel {
    return Row(
      children: <Widget>[
        SizedBox(width: _screenConfig.rH(4)),
        new Text(enter_passcode_signUp,
            textAlign: TextAlign.left,
            style: CustomFontStyle.regularFormTextStyle(blackColor)),
      ],
    );
  }

  Widget _getInputField() {
    return Center(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60.0),
          child: PinCodeTextField(
            pinBoxWidth: 30,
            pinBoxOuterPadding: EdgeInsets.symmetric(horizontal: 20),
            autofocus: false,
            controller: controller,
            hideCharacter: false,
            defaultBorderColor: disabledGrey,
            hasTextBorderColor: blackColor,
            maxLength: pinLength,
            hasError: hasError,
            onTextChanged: (text) {
              setState(() {
                hasError = false;
              });
            },
            onDone: (text) {
              widget.login
                  ? _handleLoginOtp(text)
                  : _handleOTPVerification(text);
            },
            wrapAlignment: WrapAlignment.start,
            pinBoxDecoration:
                ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
            pinTextStyle: TextStyle(fontSize: 20.0),
            pinTextAnimatedSwitcherTransition:
                ProvidedPinBoxTextAnimation.scalingTransition,
            pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
          ),
        ),
      ),
    );
  }

  get _getResendButton {
    return new Center(
        child: InkWell(
      child: Padding(
        padding: EdgeInsets.all(_screenConfig.rH(2)),
        child: new Container(
          alignment: Alignment.center,
          child: new Text(
            resend_passcode,
            style: CustomFontStyle.smallTextStyle(blueColor),
          ),
        ),
      ),
      onTap: () {
        _handleResendOtp();
      },
    ));
  }
}
