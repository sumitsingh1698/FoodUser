import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/constants/String.dart';
import 'package:Belly/data/authentication_data.dart';
import 'package:Belly/ui/screens/password_reset_page.dart';
import 'package:Belly/ui/widgets/custom_close_app_bar.dart';
import 'package:Belly/utils/show_snackbar.dart';

class OtpPasswordResetPage extends StatefulWidget {
  final String phone;

  const OtpPasswordResetPage({
    Key key,
    @required this.phone,
  }) : super(key: key);

  @override
  _OtpState createState() => new _OtpState();
}

class _OtpState extends State<OtpPasswordResetPage>
    with SingleTickerProviderStateMixin {
  // Constants
  TextEditingController controller = TextEditingController();
  int pinLength = 4;
  bool hasError = false;
  String errorMessage;
  AuthDataSource authData = new AuthDataSource();
  bool otpCorrectFlag = false;
  bool otpResentFlag = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  _handleOTPVerification(String otp) async {
    otpCorrectFlag = await authData.verifyOtpCode(widget.phone, otp);
    // if otp is sent proceed to password reset else show error message
    if (otpCorrectFlag) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PasswordResetPage(
                  phone: widget.phone,
                )),
      );
    } else
      Utils.showSnackBar(scaffoldKey, invalidCode);
  }

  _handleResendOtp() async {
    // to resend an otp
    otpResentFlag = await authData.sendOtpCode(widget.phone);
    if (otpResentFlag) {
      Utils.showSnackBar(scaffoldKey, otpResend);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: CustomCloseAppBar(
        title: resetting_password,
      ),
      backgroundColor: Colors.white,
      body: _getInputPart,
    );
  }

  get _getInputPart {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 30),
          _getVerificationCodeLabel,
          SizedBox(height: 60),
          _getInputField(),
          SizedBox(height: 20),
          _getResendButton,
        ],
      ),
    );
  }

  get _getVerificationCodeLabel {
    return new Text(enter_passcode,
        textAlign: TextAlign.left,
        style: CustomFontStyle.regularFormTextStyle(blackColor));
  }

  Widget _getInputField() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64.0),
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
            _handleOTPVerification(text);
          },
          wrapAlignment: WrapAlignment.start,
          pinBoxDecoration: ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
          pinTextStyle: TextStyle(fontSize: 20.0),
          pinTextAnimatedSwitcherTransition:
              ProvidedPinBoxTextAnimation.scalingTransition,
          pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
        ),
      ),
    );
  }

  get _getResendButton {
    return new Center(
        child: InkWell(
      child: Padding(
        padding: EdgeInsets.all(20),
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
