import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../common/colors.dart';

showToast({required String message, required BuildContext context}) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: MyColors.whiteColor,
    textColor: MyColors.blackColor,
    fontSize: 16.0,
  );
}
