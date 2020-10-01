import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Belly/constants/String.dart';
import 'dart:ui';
import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/constants/constants.dart';
import 'package:Belly/data/authentication_data.dart';
import 'package:Belly/data/my_profile_data.dart';
import 'package:Belly/models/university_model.dart';
import 'package:Belly/models/user_model.dart';
import 'package:Belly/ui/widgets/custom_close_app_bar.dart';
import 'package:Belly/utils/base_url.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart' as Picker;
import 'package:image/image.dart' as _Image;
import 'package:Belly/utils/show_snackbar.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPage createState() => _ProfileEditPage();
}

class _ProfileEditPage extends State<ProfileEditPage> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  bool _loader = true;
  bool signUpSuccessFlag = false;
  final _key = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = new GlobalKey();
  var passKey = GlobalKey<FormFieldState>();
  bool _validate = false;
  FocusNode _focusNode = new FocusNode();
  var signUpResponse;
  List<UniversityResponse> universityData = [];
  bool otpSentFlag = false;
  String token;
  ProfileDataSource profileData = new ProfileDataSource();
  User _userResponse;
  File _image;

  static final baseUrl = BaseUrl().mainUrl;
  static final saveEditProfileUrl = baseUrl + "editprofile/";

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_focusNodeListener);
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    getInitialData();
  }

  void getInitialData() async {
    var _response = await profileData.getMyProfileData(token);
    if (_response[0]) _userResponse = _response[1];

    _nameController = new TextEditingController(text: _userResponse.firstName);
    _emailController = new TextEditingController(text: _userResponse.email);
    setState(() {
      _loader = false;
    });
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

  _handleSaveDetails(context) async {
    showLoading();
    // password field not empty means user is trying to update the password also
    // a separate api is there to change the password, existing password should be correct
    // if (_passwordController.text != "") {
    //   bool passFlag = await profileData.changePassword(
    //       token, _passwordController.text, _newPasswordController.text);
    //   if (passFlag) {
    //     // pass flag true, proceed to change other profile details also
    //     var res = await addNewItem({
    //       "first_name": _nameController.text,
    //       "email_address": _emailController.text,
    //       "campus": selectedCampus.name,
    //     }, _image);
    //     Utils.showSnackBar(_key, profileUpdated);
    //   }
    //   // passflag false means the entered current password is wrong
    //   else
    //     Utils.showSnackBar(_key, passwordDoNotMatch);
    // } else
    var res = await addNewItem({
      "first_name": _nameController.text,
      "email_address": _emailController.text
    }, _image);
    Utils.showSnackBar(_key, profileUpdated);
    var _response = await profileData.getMyProfileData(token);
    if (_response[0] == true) {
      _userResponse = _response[1];
      // update user provider with new data if the profile is successfully updated
      Provider.of<UserModel>(context, listen: false).updateUser(_userResponse);
    }
    hideLoading();
  }

  void showLoading() {
    setState(() {
      _loader = true;
    });
  }

  void hideLoading() {
    setState(() {
      _loader = false;
    });
  }

  Future<Map<String, dynamic>> addNewItem(var body, File file) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String token = shared.getString("token");
    var stream;
    var length;
    var mulipartFile;
    var request = new http.MultipartRequest("PUT",
        Uri.parse(saveEditProfileUrl + _userResponse.id.toString() + "/"));
    if (file != null) {
      stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
      length = await file.length();
      mulipartFile = new http.MultipartFile('profile_pic', stream, length,
          filename: basename(file.path));
    }
    request.headers['Authorization'] = "Token " + token;
    request.fields['first_name'] = body['first_name'];
    // request.fields['last_name'] = body['last_name'];
    request.fields['email'] = body['email_address'];
    request.fields['id'] = _userResponse.id.toString();
    // request.fields['campus'] = selectedCampus.name;
    if (file != null) {
      request.files.add(mulipartFile);
    }

    http.StreamedResponse postresponse = await request.send();
    if (postresponse.statusCode == 200) {
      var res = await http.Response.fromStream(postresponse);
      return json.decode(res.body);
    } else {
      throw new Exception("Error while fetching data");
    }
  }

  void _takeImageFromCamera() async {
    var image =
        await Picker.ImagePicker.pickImage(source: Picker.ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  void _takeImageFromGallery() async {
    var image =
        await Picker.ImagePicker.pickImage(source: Picker.ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _key,
      backgroundColor: whiteColor,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: CustomCloseAppBar(title: accountDetails),
      body: (_loader)
          ? Center(child: CupertinoActivityIndicator())
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
            Center(
              child: InkWell(
                onTap: () {
                  showAlertDialog(context);
                },
                child: Stack(
                    alignment: AlignmentDirectional.center,
                    overflow: Overflow.clip,
                    children: <Widget>[
                      ClipOval(
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.2)),
                            child: _image == null
                                ? CachedNetworkImage(
                                    imageUrl: _userResponse.profilePic != null
                                        ? _userResponse.profilePic
                                        : userImageUrl,
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                    fit: BoxFit.fill,
                                  )
                                : Image.file(_image),
                          ),
                        ),
                      ),
                      Container(
                        width: 100.0,
                        height: 100.0,
                        child: new BackdropFilter(
                          filter:
                              new ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                          child: new Container(
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.2)),
                          ),
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 40.0,
                        height: 40.0,
                        child: new Image.asset(
                          'images/icons/camera_icon.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ]),
              ),
            ),
            SizedBox(height: 16),
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
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       vertical: 4.0, horizontal: 8.0),
                  //   child: TextFormField(
                  //     validator: validateName,
                  //     style: TextStyle(
                  //       letterSpacing: 1.0,
                  //       fontFamily: 'MontserratMedium',
                  //       color: Colors.black,
                  //       fontSize: 14.0,
                  //       fontWeight: FontWeight.w300,
                  //     ),
                  //     controller: _lastnameController,
                  //     keyboardType: TextInputType.text,
                  //     decoration:
                  //         new InputDecoration.collapsed(hintText: surname),
                  //   ),
                  // ),
                  // Container(
                  //   height: 1,
                  //   color: lightGrey,
                  // ),
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
            // Container(
            //   width: 400,
            //   decoration: BoxDecoration(
            //       color: cloudsColor,
            //       shape: BoxShape.rectangle,
            //       borderRadius: BorderRadius.all(
            //         Radius.circular(8.0),
            //       )),
            //   child: Column(
            //     children: <Widget>[
            //       Padding(
            //         padding: const EdgeInsets.symmetric(
            //             vertical: 4.0, horizontal: 8.0),
            //         child: DropdownButtonHideUnderline(
            //           child: DropdownButton<UniversityResponse>(
            //             isExpanded: true,
            //             items: universityData.map((UniversityResponse val) {
            //               return new DropdownMenuItem<UniversityResponse>(
            //                 value: val,
            //                 child: new Text(val.name,
            //                     style: CustomFontStyle.bottomButtonTextStyle(
            //                         blackColor)),
            //               );
            //             }).toList(),
            //             value: selectedUniversity ?? universityData.toList()[0],
            //             onChanged: (UniversityResponse val) {
            //               selectedUniversity = val;
            //               universitySelectedItem = val.name;
            //               setState(() {
            //                 getCampuses(val.slug);
            //               });
            //             },
            //           ),
            //         ),
            //       ),
            //       Container(
            //         height: 1,
            //         color: lightGrey,
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.symmetric(
            //             vertical: 4.0, horizontal: 8.0),
            //         child: DropdownButtonHideUnderline(
            //           child: DropdownButton<CampusResponse>(
            //             isExpanded: true,
            //             items: campusData.map((CampusResponse val) {
            //               return new DropdownMenuItem<CampusResponse>(
            //                 value: val,
            //                 child: new Text(val.name,
            //                     style: CustomFontStyle.bottomButtonTextStyle(
            //                         blackColor)),
            //               );
            //             }).toList(),
            //             value: selectedCampus ?? campusData.toList()[0],
            //             onChanged: (CampusResponse val) {
            //               selectedCampus = val;
            //               campusSelectedItem = val.name;
            //               setState(() {});
            //             },
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: 30),
            // Container(
            //   decoration: BoxDecoration(
            //     color: cloudsColor,
            //     shape: BoxShape.rectangle,
            //   ),
            //   child: Padding(
            //     padding:
            //         const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            //     child: TextFormField(
            //       obscureText: true,
            //       controller: _passwordController,
            //       keyboardType: TextInputType.text,
            //       style: CustomFontStyle.regularFormTextStyle(blackColor),
            //       decoration:
            //           new InputDecoration.collapsed(hintText: oldPassword),
            //     ),
            //   ),
            // ),
            // SizedBox(height: 30),
            // Container(
            //   width: 400,
            //   decoration: BoxDecoration(
            //       color: cloudsColor,
            //       shape: BoxShape.rectangle,
            //       borderRadius: BorderRadius.all(
            //         Radius.circular(8.0),
            //       )),
            //   child: Column(
            //     children: <Widget>[
            //       Padding(
            //         padding: const EdgeInsets.symmetric(
            //             vertical: 4.0, horizontal: 8.0),
            //         child: TextFormField(
            //           key: passKey,
            //           obscureText: true,
            //           style: TextStyle(
            //             letterSpacing: 1.0,
            //             fontFamily: 'MontserratMedium',
            //             color: Colors.black,
            //             fontSize: 14.0,
            //             fontWeight: FontWeight.w300,
            //           ),
            //           keyboardType: TextInputType.text,
            //           controller: _newPasswordController,
            //           decoration:
            //               new InputDecoration.collapsed(hintText: password),
            //           validator: (password) {
            //             String pattern =
            //                 r'^(?=.*[a-zA-Z])(?=.*\d)[A-Za-z\d!@#$%^&*()_+]{8,20}';
            //             RegExp regExp = new RegExp(pattern);
            //             if (_passwordController.text != "") {
            //               if (password.length == 0) {
            //                 return noEmptyFields;
            //               } else if (!regExp.hasMatch(password)) {
            //                 return passwordShould8digits;
            //               } else {
            //                 return null;
            //               }
            //             } else
            //               return null;
            //           },
            //         ),
            //       ),
            //       Container(
            //         height: 1,
            //         color: lightGrey,
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.symmetric(
            //             vertical: 4.0, horizontal: 8.0),
            //         child: TextFormField(
            //           obscureText: true,
            //           keyboardType: TextInputType.text,
            //           style: TextStyle(
            //             letterSpacing: 1.0,
            //             fontFamily: 'MontserratMedium',
            //             color: Colors.black,
            //             fontSize: 14.0,
            //             fontWeight: FontWeight.w300,
            //           ),
            //           decoration: new InputDecoration.collapsed(
            //               hintText: confirmPassword),
            //           validator: (confirmation) {
            //             var password = passKey.currentState.value;
            //             return (confirmation == password)
            //                 ? null
            //                 : passwordDoNotMatch;
            //           },
            //         ),
            // //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(context) {
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: InkWell(
          onTap: () {
            if (_formKey.currentState.validate()) {
              FocusScope.of(context).requestFocus(new FocusNode());
              _handleSaveDetails(context);
            }
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
                    update,
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
          ),
        ));
  }

  showAlertDialog(BuildContext context) {
    // set up the list options
    Widget optionOne = CupertinoDialogAction(
      child: const Text('camera'),
      onPressed: () {
        _takeImageFromCamera();
        Navigator.of(context).pop();
      },
    );
    Widget optionTwo = CupertinoDialogAction(
      child: const Text('gallery'),
      onPressed: () {
        _takeImageFromGallery();
        Navigator.of(context).pop();
      },
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
            data: ThemeData.light(),
            child: CupertinoAlertDialog(
              title: const Text('Set photo'),
              content:
                  new Text("Select a photo or take a picture with your camera"),
              actions: <Widget>[
                optionOne,
                optionTwo,
              ],
            ));
      },
    );
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
