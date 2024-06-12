import 'package:flutter/widgets.dart';

class Config{
  static MediaQueryData? mediaQueryData;
  static double? screenWith;
  static double? screenHeight;

  void init(BuildContext context){
    mediaQueryData = MediaQuery.of(context);
    screenWith = mediaQueryData!.size.width;
    screenHeight = mediaQueryData!.size.height;
  }
  static get withSize{
    return screenWith;
  }
  static get withHeight{
    return screenHeight;
  }
}