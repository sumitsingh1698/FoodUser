import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/utils/app_config.dart';

class CustomCloseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  AppConfig _screenConfig;
  final bool back;

  CustomCloseAppBar({
    Key key,
    this.title,
    this.back = true,
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
            back
                ? IconButton(
                    icon: Icon(CupertinoIcons.back, color: blackColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                : Container(),
            SizedBox(
              width: 8,
            ),
            Text(
              title,
              style: CustomFontStyle.mediumTextStyle(blackColor),
              textScaleFactor: 1.2,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
