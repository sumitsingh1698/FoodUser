import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/utils/app_config.dart';

class CloseAppBar extends StatelessWidget implements PreferredSizeWidget {
  AppConfig _screenConfig;

  CloseAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _customAppBar(context)),
      ],
    );
  }

  Widget _customAppBar(BuildContext context) {
    _screenConfig = AppConfig(context);
    return Padding(
      padding: EdgeInsets.only(top: _screenConfig.rH(2)),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 8,
            ),
            IconButton(
              icon: Icon(Icons.close, color: blackColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
