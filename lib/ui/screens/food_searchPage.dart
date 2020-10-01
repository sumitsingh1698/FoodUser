import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/models/restaurant_detail_model.dart';
import 'package:Belly/ui/widgets/menu_list_cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodSearch extends StatefulWidget {
  final List<Single> foods;
  FoodSearch(this.foods);
  @override
  _FoodSearchState createState() => _FoodSearchState();
}

class _FoodSearchState extends State<FoodSearch> {
  TextEditingController searchContrller = TextEditingController();
  bool isLoading = false;
  SharedPreferences prefs;
  String token;
  bool isGuest = false;
  bool empty = false;
  final _key = new GlobalKey<ScaffoldState>();
  List<Single> filter = [];
  List<Single> result = [];
  String slug = '';

  getSearchData() async {
    result = [];
    print('entered search');
    String text = searchContrller.text;
    print(text);

    for (int i = 1; i < text.length; ++i) {
      final search = text.substring(0, i);
      print('seaerch for $search');
      filter.forEach((e) {
        print(e.name);
        if (e.name.toLowerCase().contains(search.toLowerCase())) {
          print('contains!!!!');
          if (!result.contains(e)) {
            print('aaaaaaaaaaaaadddddddddddddingggggggggggg');
            print(
                'enamemmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm  ${e.name}');
            setState(() {
              result.add(e);
            });
          }
        }
      });
    }
    print(result.map((e) => e.name));
  }

  selectedAdd(String itemSlug) {
    setState(() {
      slug = itemSlug;
    });
  }

  @override
  void initState() {
    super.initState();
    filter = widget.foods;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        backgroundColor: whiteBellyColor,
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey[500]),
                      shape: BoxShape.rectangle,
                    ),
                    child: Center(
                      child: TextFormField(
                        onEditingComplete: () {
                          getSearchData();
                        },
                        controller: searchContrller,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 18),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey[500],
                              size: 24,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                searchContrller.clear();
                              },
                              icon: Icon(Icons.clear),
                              color: Colors.grey[500],
                              iconSize: 24,
                            ),
                            hintText: "Search for Food... "),
                      ),
                    )),
              ),
              Expanded(
                  child: (isLoading)
                      ? Center(child: CupertinoActivityIndicator())
                      : result.isNotEmpty
                          ? Container(
                              child: ListView.builder(
                                itemCount: result.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return MenuCell(
                                      result[index], index, slug, selectedAdd);
                                },
                              ),
                            )
                          : empty
                              ? Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                0.2),
                                    child: Container(
                                      child: Text('Sorry,No Results Matched :(',
                                          style:
                                              CustomFontStyle.mediumTextStyle(
                                                  blackBellyColor)),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}
