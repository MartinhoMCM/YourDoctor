import 'package:flutter/cupertino.dart';

class AddHelper
{

  double width=0.0;
  double height=0.0;

  AddHelper(BuildContext context)
  {
     width = MediaQuery.of(context).size.width;
     height = MediaQuery.of(context).size.height;
  }

  // full screen width
  static double screenWidth(BuildContext context)
  {
    return MediaQuery.of(context).size.width;

  }
  // full screen height
  static double screenHeight(BuildContext context)
  {
    return MediaQuery.of(context).size.height;

  }

 double padding(BuildContext context)
  {
    // height without SafeArea
    var padding= MediaQuery.of(context).padding;
    return height - padding.top - padding.bottom;
  }


}