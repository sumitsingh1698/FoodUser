import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/Style.dart';
import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function(String) sort;
  FilterBottomSheet(this.sort);
  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String val = '';
  Widget childSort() {
    print(val);
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Radio(
              activeColor: Colors.green,
              value: 'Distance',
              groupValue: val,
              onChanged: (value) {
                print('ssssssssssssss');
                setState(() {
                  val = value;
                });
              },
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Distance",
              style: CustomFontStyle.regularFormTextStyle(blackBellyColor),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Radio(
              activeColor: Colors.green,
              value: 'CostLtoH',
              groupValue: val,
              onChanged: (value) {
                print('ssssssssssssss');
                setState(() {
                  val = value;
                });
              },
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Cost: Low To High",
              style: CustomFontStyle.regularFormTextStyle(blackBellyColor),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Radio(
              activeColor: Colors.green,
              value: 'CostHtoL',
              groupValue: val,
              onChanged: (value) {
                print('ssssssssssssss');
                setState(() {
                  val = value;
                });
              },
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Cost: High To Low",
              style: CustomFontStyle.regularFormTextStyle(blackBellyColor),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Radio(
              activeColor: Colors.green,
              value: 'RatingHtoL',
              groupValue: val,
              onChanged: (value) {
                print('ssssssssssssss');
                setState(() {
                  val = value;
                });
              },
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Rating: High To Low",
              style: CustomFontStyle.regularFormTextStyle(blackBellyColor),
            )
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    val = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 360,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Sort',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontFamily: "NotoSansJP"),
              ),
            ),
            Container(
              width: double.infinity,
              height: 2,
              color: greenBellyColor,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            // border: Border.all(width: 2, color: Colors.green)),
                            ),
                        child: Center(
                            child: Text(
                          'Sort By',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              fontFamily: "NotoSansJP"),
                        )),
                      )
                    ],
                  ),
                ),
                Expanded(flex: 5, child: childSort()),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    val.isNotEmpty ? widget.sort(val) : null;
                    if (val.isNotEmpty) {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                    height: 50,
                    width: 100,
                    child: Center(
                        child: Text(
                      'Apply',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
