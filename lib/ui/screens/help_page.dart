import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/String.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/data/other_contents_data.dart';
import 'package:Belly/models/other_content_model.dart';
import 'package:Belly/ui/widgets/custom_close_app_bar.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  bool _dataLoaded = false;
  OtherContentModel data;
  OtherContentsData _otherContentsData = new OtherContentsData();

  @override
  void initState() {
    super.initState();
    _dataLoaded = false;
    getData();
  }

  void getData() async {
    data = await _otherContentsData.getHelpContents();
    setState(() {
      _dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomCloseAppBar(
        title: help,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // !_dataLoaded
                    //     ? Center(child: CupertinoActivityIndicator())
                    //     : buildInfoDetail(),
                    Text(
                      'Belly App,Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim ven',
                      style: CustomFontStyle.mediumTextStyle(Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'sconsectetur adipiscing elit, sed do eiusmod',
                      style: CustomFontStyle.mediumTextStyle(Colors.black),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'consectetur adipiscing elit, sed do eiusmod',
                      style: CustomFontStyle.mediumTextStyle(Colors.black),
                    ),
                    Text(
                      'consectetur adipiscing elit, sed do eiusmod',
                      style: CustomFontStyle.mediumTextStyle(Colors.black),
                    ),
                    Text(
                      'consectetur adipiscing elit, sed do eiusmod',
                      style: CustomFontStyle.mediumTextStyle(Colors.black),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 12.0),
        Container(
          width: double.infinity,
          color: cloudsColor,
          child: Padding(
            padding: EdgeInsets.only(
                left: 24.0, right: 24.0, top: 20.0, bottom: 20.0),
            child: Text(data.desc,
                style: CustomFontStyle.mediumTextStyle(greyColor)),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: data.levelone.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                child: ExpansionTile(
                  title: Text(
                    data.levelone[index].title,
                    style: CustomFontStyle.mediumTextStyle(blackColor),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_down),
                  backgroundColor: whiteColor,
                  children: [
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: Html(
                              data: """${data.levelone[index].content} """),
                        ),
                      ],
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: lightGrey,
                      width: 1.0,
                    ),
                  ),
                ));
          },
        ),
      ],
    );
  }
}
