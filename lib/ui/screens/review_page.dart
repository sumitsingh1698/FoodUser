import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/models/past_order_model.dart';
import 'package:Belly/utils/base_url.dart';
import 'package:Belly/utils/network_utils.dart';
import 'package:Belly/utils/show_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewPage extends StatefulWidget {
  final String rating;
  final orderId;
  const ReviewPage({Key key, this.rating, this.orderId}) : super(key: key);
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  String token;
  bool isLoading = true;
  NetworkUtil _netUtil = new NetworkUtil();
  TextEditingController reviewController = TextEditingController();
  double rating = 1;
  final _key = GlobalKey<ScaffoldState>();
  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      token = prefs.getString('token');
      setState(() {
        isLoading = false;
      });
    } on Exception catch (error) {
      print(error);
      return null;
    }
  }

  _handleSubmit() async {
    setState(() {
      isLoading = true;
    });
    String url;
    if (widget.rating == 'Delivery Rating') {
      url = BaseUrl().mainUrl + 'rate/delivery/';
    } else {
      url = BaseUrl().mainUrl + 'rate/restaurant/';
    }
    Rating ratingModel = Rating(
        order: widget.orderId, review: reviewController.text, rating: rating);
    final data = ratingModel.toJson();
    final res = await _netUtil.submitRating(url, token, data);
    setState(() {
      isLoading = false;
    });
    // Utils.showSnackBar(_key, res.toString());
    if (res['status']) {
      Utils.showSnackBar(_key, res["message"]);
    } else {
      Utils.showSnackBar(_key, "error :(");
    }
  }

  @override
  void initState() {
    getSharedPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        body: (isLoading)
            ? Center(child: CupertinoActivityIndicator())
            : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 40.0, left: 40),
                        child: Text(
                          widget.rating,
                          style: CustomFontStyle.MediumHeadingStyle(
                              blackBellyColor),
                        )),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40.0),
                      child: RatingBar(
                        itemSize: 30,
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: greenBellyColor,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            this.rating = rating;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40.0),
                      child: Text('Write a review'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        color: Colors.grey[200],
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextFormField(
                          controller: reviewController,
                          minLines: 4,
                          maxLines: 8,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: () => _handleSubmit(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Submit',
                              style:
                                  TextStyle(color: Colors.green, fontSize: 15),
                            ),
                            Icon(
                              Icons.rate_review,
                              color: Colors.green,
                              size: 25,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
