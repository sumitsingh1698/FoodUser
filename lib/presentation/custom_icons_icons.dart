import 'package:flutter/widgets.dart';

class MyIcon {
  MyIcon._();

  static const _kFontFam = 'MyIcon';
  static const _kFontFam2 = 'BellyCart';
  static const _kFontPkg = null;

  static const IconData offerbutton =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bellyBag =
      IconData(0xe800, fontFamily: _kFontFam2, fontPackage: _kFontPkg);
}
